//
//  LSDclChangeViewController.m
//  LSPT_SX
//
//  Created by 何键键 on 16/3/1.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSDclChangeViewController.h"
#import "NIDropDown.h"
#import "LSFgAhInfo.h"
#import "LSDCLViewController.h"
#import "LSPT.h"


@interface LSDclChangeViewController ()<NIDropDownDelegate>
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UIButton *ahqcBtnTitle;
@property (weak, nonatomic) IBOutlet UITextView *sqyyTextView;
@property (nonatomic, strong)NIDropDown *dropDown;
@property (nonatomic, strong) NSMutableArray *ahInfoArr;
@property (nonatomic, strong) NSMutableArray *ahAllArr;
@property (nonatomic, copy) NSString *ahqcStr;
@property (nonatomic, copy) NSString *ajbsStr;

@end
extern NSString *dclahqcStr;
extern NSString *dclnrStr;
extern NSString *dclIdStr;
@implementation LSDclChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改调查令";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
    self.detailView.layer.cornerRadius = 5;
    self.detailView.layer.borderWidth = 1;
    self.detailView.layer.borderColor = LSGrayColor.CGColor;
    self.sqyyTextView.layer.cornerRadius = 5;
    self.sqyyTextView.layer.borderWidth = 1;
    self.sqyyTextView.layer.borderColor = LSGrayColor.CGColor;
    // Do any additional setup after loading the view from its nib.
    [self.ahqcBtnTitle setTitle:dclahqcStr forState:UIControlStateNormal];
    self.sqyyTextView.text = dclnrStr;
    [self loadAhInfo];
}

- (void)back {
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
            [self.ahAllArr addObject:ah];
        }
        NSLog(@"%@==",json);
    } failure:^(NSError *error) {
        
    }];
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
    
    self.sqyyTextView.contentInset=UIEdgeInsetsMake(0, 0,keyboardRect.size.height, 0);
}

- (void)handleKeyboardDidHidden
{
    self.sqyyTextView.contentInset=UIEdgeInsetsZero;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.sqyyTextView  resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)selectBtn:(id)sender {
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
    self.ahqcStr = ahInfo.ahqc;
    self.ajbsStr = ahInfo.ajbs;
    [self rel];
}

-(void)rel{
    //    [dropDown release];
    self.dropDown = nil;
}

- (IBAction)zancunBtn:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = dclIdStr;
    params[@"ajbs"] = self.ajbsStr;
    params[@"ahqc"] = self.ahqcStr;
    params[@"sqyy"] = self.sqyyTextView.text;
    params[@"zt"] = @"1";
    NSString *lsid = [[NSUserDefaults standardUserDefaults]objectForKey:@"lsid"];
    params[@"lsid"] = lsid;
    [LSHttpTool get:DCLSaveOrChangeUrl params:params success:^(id json) {
        NSLog(@"json-%@",json);
        LSBaseModel *baseModel=[LSBaseModel mj_objectWithKeyValues:json];
        if ([baseModel.status isEqualToString:@"success"]) {
            [MBProgressHUD showSuccess:@"文件提交成功"];
            [self jumpToVC];
        } else {
            [MBProgressHUD showError:@"文件提交失败"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络连接错误"];
    }];
    

}
- (IBAction)tijiaoBtn:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = dclIdStr;
    params[@"ajbs"] = self.ajbsStr;
    params[@"ahqc"] = self.ahqcStr;
    params[@"sqyy"] = self.sqyyTextView.text;
    params[@"zt"] = @"2";
    NSString *lsid = [[NSUserDefaults standardUserDefaults]objectForKey:@"lsid"];
    params[@"lsid"] = lsid;
    [LSHttpTool get:DCLSaveOrChangeUrl params:params success:^(id json) {
        NSLog(@"json-%@",json);
        LSBaseModel *baseModel=[LSBaseModel mj_objectWithKeyValues:json];
        if ([baseModel.status isEqualToString:@"success"]) {
            [MBProgressHUD showSuccess:@"文件提交成功"];
            [self jumpToVC];
        } else {
            [MBProgressHUD showError:@"文件提交失败"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络连接错误"];
    }];
    

}
- (void)jumpToVC {
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[LSDCLViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
