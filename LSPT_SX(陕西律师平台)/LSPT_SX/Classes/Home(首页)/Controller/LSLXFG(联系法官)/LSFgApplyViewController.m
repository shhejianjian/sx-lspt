//
//  LSFgApplyViewController.m
//  LSPT_SX
//
//  Created by 何键键 on 16/2/24.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSFgApplyViewController.h"
#import "NIDropDown.h"
#import "LSFgAhInfo.h"
#import "LSPT.h"



@interface LSFgApplyViewController ()<NIDropDownDelegate>
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UITextView *fgApplyTextView;
@property (weak, nonatomic) IBOutlet UILabel *cbfgLabel;
@property (weak, nonatomic) IBOutlet UITextField *problemTextField;
@property (weak, nonatomic) IBOutlet UIButton *selectAhBtn;

@property (nonatomic, strong)NIDropDown *dropDown;
@property (nonatomic, strong) NSMutableArray *ahInfoArr;
@property (nonatomic, strong) NSMutableArray *cbrNameArr;

@property (nonatomic, copy) NSString *ahqcStr;
@property (nonatomic, copy) NSString *fgDmStr;
@property (nonatomic, copy) NSString *ajbsStr;
@end

@implementation LSFgApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"申请联系法官";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
    self.detailView.layer.cornerRadius = 5;
    self.detailView.layer.masksToBounds = YES;
    self.detailView.layer.borderWidth = 1;
    self.detailView.layer.borderColor = LSGrayColor.CGColor;
    self.fgApplyTextView.layer.cornerRadius = 5;
    self.fgApplyTextView.layer.borderWidth = 1;
    self.fgApplyTextView.layer.borderColor = LSGrayColor.CGColor;
    [self loadAhInfo];
    // Do any additional setup after loading the view from its nib.
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)loadAhInfo {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *sfzjhm = [[NSUserDefaults standardUserDefaults]objectForKey:@"sfzjhm"];
    params[@"sfzjhm"] = sfzjhm;
    [LSHttpTool get:GetAhInfoUrl params:params success:^(id json) {
        NSArray *arr = [LSFgAhInfo mj_objectArrayWithKeyValuesArray:json[@"data"][@"result"]];
        for (LSFgAhInfo *ah in arr) {
            [self.ahInfoArr addObject:ah.ahqc];
            [self.cbrNameArr addObject:ah];
        }
        NSLog(@"%@==",json);
    } failure:^(NSError *error) {
        
    }];
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
    
    self.fgApplyTextView.contentInset=UIEdgeInsetsMake(0, 0,keyboardRect.size.height, 0);
}

- (void)handleKeyboardDidHidden
{
    self.fgApplyTextView.contentInset=UIEdgeInsetsZero;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.fgApplyTextView  resignFirstResponder];
    [self.problemTextField resignFirstResponder];
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
    //self.cbfgLabel.text = self.cbrNameArr[3];
    LSFgAhInfo *ahInfo = self.cbrNameArr[self.dropDown.index];
    NSLog(@"ahinfo==%@---%d",ahInfo.ajbs,self.dropDown.index);
    self.cbfgLabel.text = ahInfo.cbrmc;
    self.ahqcStr = ahInfo.ahqc;
    self.fgDmStr = ahInfo.cbrbm;
    self.ajbsStr = ahInfo.ajbs;
    [self rel];
}

- (IBAction)zanCunBtn:(id)sender {
    if (!self.ajbsStr || self.problemTextField.text.length == 0 || self.fgApplyTextView.text.length == 0) {
        [MBProgressHUD showError:@"请选择案号并输入申请原因和标题"];
    } else {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *lsid = [[NSUserDefaults standardUserDefaults]objectForKey:@"lsid"];
    NSString *username = [[NSUserDefaults standardUserDefaults]objectForKey:@"usernameCN"];
    params[@"id"] = @"";
    params[@"ahqc"] = self.ahqcStr;
    params[@"fgdm"] = self.fgDmStr;
    params[@"cbfgmc"] = self.cbfgLabel.text;
    params[@"bt"] = self.problemTextField.text;
    params[@"nr"] = self.fgApplyTextView.text;
    params[@"zt"] = @"1";
    params[@"ajbs"] = self.ajbsStr;
    params[@"lsid"] = lsid;
    params[@"username"] = username;
    [LSHttpTool get:LXFGSaveOrUpdateUrl params:params success:^(id json) {
        NSLog(@"json%@",json);
        LSBaseModel *baseModel=[LSBaseModel mj_objectWithKeyValues:json];
        if ([baseModel.status isEqualToString:@"success"]) {
            [MBProgressHUD showSuccess:@"暂存成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showError:@"暂存失败"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络连接错误"];
    }];
    }

}


- (IBAction)tiJiaoBtn:(id)sender {
    if (!self.ajbsStr || self.problemTextField.text.length == 0 || self.fgApplyTextView.text.length == 0) {
        [MBProgressHUD showError:@"请选择案号并输入申请原因和标题"];
    } else {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *lsid = [[NSUserDefaults standardUserDefaults]objectForKey:@"lsid"];
    NSString *username = [[NSUserDefaults standardUserDefaults]objectForKey:@"usernameCN"];
    params[@"id"] = @"";
    params[@"ahqc"] = self.ahqcStr;
    params[@"fgdm"] = self.fgDmStr;
    params[@"cbfgmc"] = self.cbfgLabel.text;
    params[@"bt"] = self.problemTextField.text;
    params[@"nr"] = self.fgApplyTextView.text;
    params[@"zt"] = @"2";
    params[@"ajbs"] = self.ajbsStr;
    params[@"lsid"] = lsid;
    params[@"username"] = username;
    [LSHttpTool get:LXFGSaveOrUpdateUrl params:params success:^(id json) {
        NSLog(@"json%@",json);
        LSBaseModel *baseModel=[LSBaseModel mj_objectWithKeyValues:json];
        if ([baseModel.status isEqualToString:@"success"]) {
            [MBProgressHUD showSuccess:@"提交成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showError:@"提交失败"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络连接错误"];
    }];
    }

}



-(void)rel{
    self.dropDown = nil;
}
- (NSMutableArray *)ahInfoArr {
	if(_ahInfoArr == nil) {
		_ahInfoArr = [[NSMutableArray alloc] init];
	}
	return _ahInfoArr;
}

- (NSMutableArray *)cbrNameArr {
	if(_cbrNameArr == nil) {
		_cbrNameArr = [[NSMutableArray alloc] init];
	}
	return _cbrNameArr;
}

@end
