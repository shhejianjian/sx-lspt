//
//  LSFgChangeViewController.m
//  LSPT_SX
//
//  Created by 何键键 on 16/2/25.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSFgChangeViewController.h"
#import "NIDropDown.h"
#import "LSFgAhInfo.h"
#import "LSLXFGViewController.h"
#import "LSPT.h"

@interface LSFgChangeViewController ()<NIDropDownDelegate>
@property (weak, nonatomic) IBOutlet UIView *detailView;

@property (weak, nonatomic) IBOutlet UILabel *cbfgLabel;
@property (weak, nonatomic) IBOutlet UITextView *changeFgTextView;
@property (weak, nonatomic) IBOutlet UITextField *changeProblemTextField;
@property (weak, nonatomic) IBOutlet UIButton *ahBtnTitle;
@property (nonatomic, strong)NIDropDown *dropDown;

@property (nonatomic, strong) NSMutableArray *ahInfoArr;
@property (nonatomic, strong) NSMutableArray *ahAllArr;

@property (nonatomic, copy) NSString *ahqcStr;
@property (nonatomic, copy) NSString *fgDmStr;
@property (nonatomic, copy) NSString *ajbsStr;


@end
extern NSString *ahqcStr;
extern NSString *cbfgStr;
extern NSString *twbtStr;
extern NSString *nrStr;
extern NSString *idStr;
@implementation LSFgChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"123");
    self.navigationItem.title = @"修改联系法官";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
    self.detailView.layer.cornerRadius = 5;
    self.detailView.layer.masksToBounds = YES;
    self.detailView.layer.borderWidth = 1;
    self.detailView.layer.borderColor = LSGrayColor.CGColor;
    self.changeFgTextView.layer.cornerRadius = 5;
    self.changeFgTextView.layer.borderWidth = 1;
    self.changeFgTextView.layer.borderColor = LSGrayColor.CGColor;
    self.cbfgLabel.text = cbfgStr;
    [self.ahBtnTitle setTitle:ahqcStr forState:UIControlStateNormal];
    self.changeProblemTextField.text = twbtStr;
    self.changeFgTextView.text = nrStr;
    [self.view setNeedsDisplay];
    [self loadAhInfo];
    // Do any additional setup after loading the view from its nib.
}
- (void)loadAhInfo {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *sfzjhm = [[NSUserDefaults standardUserDefaults]objectForKey:@"sfzjhm"];
    params[@"sfzjhm"] = sfzjhm;
    [LSHttpTool get:GetAhInfoUrl params:params success:^(id json) {
        NSArray *arr = [LSFgAhInfo mj_objectArrayWithKeyValuesArray:json[@"data"][@"result"]];
        for (LSFgAhInfo *ah in arr) {
            [self.ahInfoArr addObject:ah.ahqc];
            [self.ahAllArr addObject:ah];
        }
        NSLog(@"%@==",json);
    } failure:^(NSError *error) {
        
    }];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)zanCunBtn:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *lsid = [[NSUserDefaults standardUserDefaults]objectForKey:@"lsid"];
    NSString *username = [[NSUserDefaults standardUserDefaults]objectForKey:@"usernameCN"];
    params[@"id"] = idStr;
    params[@"ahqc"] = self.ahqcStr;
    params[@"fgdm"] = self.fgDmStr;
    params[@"cbfgmc"] = self.cbfgLabel.text;
    params[@"bt"] = self.changeProblemTextField.text;
    params[@"nr"] = self.changeFgTextView.text;
    params[@"zt"] = @"1";
    params[@"ajbs"] = self.ajbsStr;
    params[@"lsid"] = lsid;
    params[@"username"] = username;
    [LSHttpTool get:LXFGSaveOrUpdateUrl params:params success:^(id json) {
        NSLog(@"json%@",json);
        LSBaseModel *baseModel=[LSBaseModel mj_objectWithKeyValues:json];
        if ([baseModel.status isEqualToString:@"success"]) {
            [MBProgressHUD showSuccess:@"暂存成功"];
            [self jumpToVC];
        } else {
            [MBProgressHUD showError:@"暂存失败"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络连接错误"];
    }];
    


}

- (IBAction)tiJiaoBtn:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *lsid = [[NSUserDefaults standardUserDefaults]objectForKey:@"lsid"];
    NSString *username = [[NSUserDefaults standardUserDefaults]objectForKey:@"usernameCN"];
    params[@"id"] = idStr;
    params[@"ahqc"] = self.ahqcStr;
    params[@"fgdm"] = self.fgDmStr;
    params[@"cbfgmc"] = self.cbfgLabel.text;
    params[@"bt"] = self.changeProblemTextField.text;
    params[@"nr"] = self.changeFgTextView.text;
    params[@"zt"] = @"2";
    params[@"ajbs"] = self.ajbsStr;
    params[@"lsid"] = lsid;
    params[@"username"] = username;
    [LSHttpTool get:LXFGSaveOrUpdateUrl params:params success:^(id json) {
        NSLog(@"json%@",json);
        LSBaseModel *baseModel=[LSBaseModel mj_objectWithKeyValues:json];
        if ([baseModel.status isEqualToString:@"success"]) {
            [MBProgressHUD showSuccess:@"提交成功"];
            [self jumpToVC];
        } else {
            [MBProgressHUD showError:@"提交失败"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络连接错误"];
    }];
    


}

- (void)jumpToVC {
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[LSLXFGViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -- textView键盘
- (void)viewWillAppear:(BOOL)animated
{
    //注册通知,监听键盘出现
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleKeyboardDidShow:)
                                                name:UIKeyboardDidShowNotification
                                              object:nil];
    //注册通知，监听键盘消失事件
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleKeyboardDidHidden)
                                                name:UIKeyboardDidHideNotification
                                              object:nil];
    [super viewWillAppear:YES];
}

//监听事件
- (void)handleKeyboardDidShow:(NSNotification*)paramNotification
{
    //获取键盘高度
    NSValue *keyboardRectAsObject=[[paramNotification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect;
    [keyboardRectAsObject getValue:&keyboardRect];
    
    self.changeFgTextView.contentInset=UIEdgeInsetsMake(0, 0,keyboardRect.size.height, 0);
}

- (void)handleKeyboardDidHidden
{
    self.changeFgTextView.contentInset=UIEdgeInsetsZero;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.changeFgTextView  resignFirstResponder];
    [self.changeProblemTextField resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickSelect:(id)sender {
    if(self.dropDown == nil) {
        CGFloat f = 200;
        self.dropDown = [[NIDropDown alloc]showDropDown:sender :&f :self.ahInfoArr :nil :@"down"];
        self.dropDown.delegate = self;
    }
    else {
        [self.dropDown hideDropDown:sender];
        [self rel];
    }
}
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    LSFgAhInfo *ahInfo = self.ahAllArr[self.dropDown.index];
    self.cbfgLabel.text = ahInfo.cbrmc;
    self.ahqcStr = ahInfo.ahqc;
    self.fgDmStr = ahInfo.cbrbm;
    self.ajbsStr = ahInfo.ajbs;
    [self rel];
}

-(void)rel{
    //    [dropDown release];
    self.dropDown = nil;
}
- (NSMutableArray *)ahInfoArr {
	if(_ahInfoArr == nil) {
		_ahInfoArr = [[NSMutableArray alloc] init];
	}
	return _ahInfoArr;
}

- (NSMutableArray *)ahAllArr {
	if(_ahAllArr == nil) {
		_ahAllArr = [[NSMutableArray alloc] init];
	}
	return _ahAllArr;
}

@end
