//
//  LSDcApplyViewController.m
//  LSPT_SX
//
//  Created by 何键键 on 16/2/25.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSDcApplyViewController.h"
#import "NIDropDown.h"
#import "LSPT.h"
#import "LSFgAhInfo.h"
#import "LSDCLViewController.h"
#import "NSString+LoveData.h"
@interface LSDcApplyViewController ()<NIDropDownDelegate>
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UITextView *dclTextView;
@property (nonatomic, strong)NIDropDown *dropDown;
@property (nonatomic, strong) NSMutableArray *ahInfoArr;
@property (nonatomic, strong) NSMutableArray *ahAllArr;
@property (nonatomic, copy) NSString *ahqcStr;
@property (nonatomic, copy) NSString *ajbsStr;
@end

@implementation LSDcApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"调查令申请";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
    self.detailView.layer.cornerRadius = 5;
    self.detailView.layer.masksToBounds = YES;
    self.detailView.layer.borderWidth = 1;
    self.detailView.layer.borderColor = LSGrayColor.CGColor;
    self.dclTextView.layer.cornerRadius = 5;
    self.dclTextView.layer.borderWidth = 1;
    self.dclTextView.layer.borderColor = LSGrayColor.CGColor;
    // Do any additional setup after loading the view from its nib.
    [self loadAhInfo];
    NSLog(@"%@<><><><>%d",self.dclTextView.text,self.dclTextView.text.length);
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
    
    self.dclTextView.contentInset=UIEdgeInsetsMake(0, 0,keyboardRect.size.height, 0);
}

- (void)handleKeyboardDidHidden
{
    self.dclTextView.contentInset=UIEdgeInsetsZero;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.dclTextView  resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)zancunBtn:(id)sender {
    if (!self.ajbsStr  ) {
        [MBProgressHUD showError:@"请选择案号"];
    } else if (self.dclTextView.text.length == 0){
        [MBProgressHUD showError:@"申请原因不能为空"];
    }else{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = @"";
    params[@"ajbs"] = self.ajbsStr;
    params[@"ahqc"] = self.ahqcStr;
    params[@"sqyy"] = self.dclTextView.text;
    params[@"zt"] = @"1";
    NSString *lsid = [[NSUserDefaults standardUserDefaults]objectForKey:@"lsid"];
    params[@"lsid"] = lsid;
        
        [LSHttpTool get:DCLSaveOrChangeUrl params:nil success:^(id json) {
        NSLog(@"json-%@-?%@",json,params);
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


- (IBAction)tijiaoBtn:(id)sender {
    if (!self.ajbsStr) {
        [MBProgressHUD showError:@"请选择案号"];
    }
    if (self.dclTextView.text.length == 0){
        [MBProgressHUD showError:@"申请原因不能为空"];
    }else {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = @"";
    params[@"ajbs"] = self.ajbsStr;
    params[@"ahqc"] = self.ahqcStr;
    params[@"sqyy"] = self.dclTextView.text;
    params[@"zt"] = @"2";
    NSString *lsid = [[NSUserDefaults standardUserDefaults]objectForKey:@"lsid"];
    params[@"lsid"] = lsid;
    [LSHttpTool get:DCLSaveOrChangeUrl params:params success:^(id json) {
        NSLog(@"json-%@",json);
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







- (IBAction)btnSelect:(id)sender {
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
