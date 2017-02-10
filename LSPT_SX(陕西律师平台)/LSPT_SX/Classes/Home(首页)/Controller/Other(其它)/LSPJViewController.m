//
//  LSPJViewController.m
//  LSPT_SX
//
//  Created by 何键键 on 16/3/1.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSPJViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "LSConst.h"
#import "LSHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "LSBaseModel.h"
#import "MJExtension.h"
#import "UIView+Extension.h"
@interface LSPJViewController ()
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UITextView *pjTextView;

@property (weak, nonatomic) IBOutlet UIButton *hmyBtn;
@property (weak, nonatomic) IBOutlet UIButton *jbmyBtn;
@property (weak, nonatomic) IBOutlet UIButton *myBtn;
@property (weak, nonatomic) IBOutlet UIButton *bmyBtn;

@property (nonatomic, copy) NSString *myd;


@end

extern NSString *ssbqIdStr;
extern NSString *tsbrIdStr;
extern NSString *dclIdStr;
extern NSString *idStr;
extern NSString *yqktIdStr;
extern NSString *wsyjIdStr;
extern NSString *wslaIDStr;
@implementation LSPJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"满意度评价";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
    self.detailView.layer.cornerRadius = 5;
    self.detailView.layer.borderWidth = 1;
    self.detailView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.pjTextView.layer.cornerRadius = 5;
    self.pjTextView.layer.borderWidth = 1;
    self.pjTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    _hmyBtn.imageView.size = CGSizeMake(20, 20);
    _jbmyBtn.imageView.size = CGSizeMake(20, 20);
    _myBtn.imageView.size = CGSizeMake(20, 20);
    _bmyBtn.imageView.size = CGSizeMake(20, 20);
    
    // Do any additional setup after loading the view from its nib.
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)hmyBtnClick:(UIButton *)sender {
    _hmyBtn.selected = !_hmyBtn.selected;
    _jbmyBtn.selected = NO;
    _myBtn.selected = NO;
    _bmyBtn.selected = NO;
    if ((sender.selected = YES)) {
        self.myd = @"很满意";
    }
}
- (IBAction)jbmyBtnClick:(UIButton *)sender {
    _jbmyBtn.selected = !_jbmyBtn.selected;
    _hmyBtn.selected = NO;
    _myBtn.selected = NO;
    _bmyBtn.selected = NO;
    if ((sender.selected = YES)) {
        self.myd = @"基本满意";
    }
}
- (IBAction)myBtnClick:(UIButton *)sender {
    _myBtn.selected = !_myBtn.selected;
    _jbmyBtn.selected = NO;
    _hmyBtn.selected = NO;
    _bmyBtn.selected = NO;
    if ((sender.selected = YES)) {
        self.myd = @"满意";
    }
}
- (IBAction)bmyBtnClick:(UIButton *)sender {
    _bmyBtn.selected = !_bmyBtn.selected;
    _jbmyBtn.selected = NO;
    _myBtn.selected = NO;
    _hmyBtn.selected = NO;
    if ((sender.selected = YES)) {
        self.myd = @"不满意";
    }
}


- (IBAction)tijiaobtn:(id)sender {
    if ( self.pjTextView.text.length == 0) {
        [MBProgressHUD showError:@"没有输入评价内容"];
    } else if (!self.myd) {
        [MBProgressHUD showError:@"请选择满意度"];
    } else {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"myd"] = self.myd;
    params[@"yjnr"] = self.pjTextView.text;
    if (tsbrIdStr) {
        params[@"id"] = tsbrIdStr;
        params[@"type"] = @"tsbr";
    } else if (dclIdStr) {
        params[@"id"] = dclIdStr;
        params[@"type"] = @"dcl";
    } else if (ssbqIdStr) {
        params[@"id"] = ssbqIdStr;
        params[@"type"] = @"ssbq";
    } else if (yqktIdStr) {
        params[@"id"] = yqktIdStr;
        params[@"type"] = @"yqkt";
    } else if (idStr) {
        params[@"id"] = idStr;
        params[@"type"] = @"lxfg";
    } else if (wsyjIdStr) {
        params[@"id"] = wsyjIdStr;
        params[@"type"] = @"wsyj";
    } else if (wslaIDStr) {
        params[@"id"] = wslaIDStr;
        params[@"type"] = @"wsla";
    }
        
        NSLog(@"params==%@",params);
    [LSHttpTool post:mydPjUrl params:params success:^(id json) {
        LSBaseModel *baseModel=[LSBaseModel mj_objectWithKeyValues:json];
        if ([baseModel.status isEqualToString:@"success"]) {
            [MBProgressHUD showSuccess:@"评价成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showError:@"评价失败"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络连接错误"];
    }];
        

    }
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
    
    self.pjTextView.contentInset=UIEdgeInsetsMake(0, 0,keyboardRect.size.height, 0);
}

- (void)handleKeyboardDidHidden
{
    self.pjTextView.contentInset=UIEdgeInsetsZero;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.pjTextView  resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
