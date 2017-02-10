//
//  LSWSLASecondMsViewController.m
//  LSPT_SX
//
//  Created by 谢琰 on 16/3/3.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSWSLASecondMsViewController.h"
#import "LSPT.h"
#import "LSWSLA.h"
#import "LSAYInfo.h"
#import "LSGXYJInfo.h"
#import "NIDropDown.h"
#import "LSWSLAMainViewController.h"
#import "LSSPCXInfo.h"
#import "XYVerifyIDTool.h"
#import "LSAYTreeViewController.h"
@interface LSWSLASecondMsViewController ()<NIDropDownDelegate>
@property (weak, nonatomic) IBOutlet UIView *edgeView;
@property (weak, nonatomic) IBOutlet UITextField *sqrTextField;
@property (weak, nonatomic) IBOutlet UITextField *sqrdhTextField;
@property (weak, nonatomic) IBOutlet UITextField *sqrsjTextField;
@property (weak, nonatomic) IBOutlet UITextField *sqrzjhmTextField;
@property (weak, nonatomic) IBOutlet UITextField *ajbdTextField;
@property (weak, nonatomic) IBOutlet UITextView *ssqqTextView;
@property (weak, nonatomic) IBOutlet UITextView *sslyTextView;
@property (weak, nonatomic) IBOutlet UILabel *ydsrgxLabel;
@property (nonatomic, strong) NSMutableArray *AYs;
@property (nonatomic, strong) NSMutableArray *Ayarr;
@property (nonatomic, strong) NSMutableArray *GXYJs;
@property (nonatomic, strong) NSMutableArray *Gxyjarr;
@property (nonatomic, strong) NIDropDown *dropDown;
@property (weak, nonatomic) IBOutlet UIButton *ayButton;
@property (weak, nonatomic) IBOutlet UIButton *GxyjButton;

@end
extern NSString *msAyStr;
extern NSString *msAyDm;
@implementation LSWSLASecondMsViewController
extern LSWSLA *mWsla;
- (NSMutableArray *)AYs
{
    if (!_AYs) {
        _AYs = [NSMutableArray array];
    }
    return _AYs;
}
- (NSMutableArray *)GXYJs
{
    if (!_GXYJs) {
        _GXYJs = [NSMutableArray array];
    }
    return _GXYJs;
}
- (NSMutableArray *)Ayarr
{
    if (!_Ayarr) {
        _Ayarr = [NSMutableArray array];
    }
    return _Ayarr;
}
- (NSMutableArray *)Gxyjarr
{
    if (!_Gxyjarr) {
        _Gxyjarr = [NSMutableArray array];
    }
    return _Gxyjarr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"网上立案";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
    //    self.scrollView.bounces = NO;
    self.edgeView.layer.borderColor = LSGlobalColor.CGColor;
    self.edgeView.layer.cornerRadius = 5.0f;
    self.edgeView.layer.borderWidth = 2.0f;
    //    self.scrollView.contentSize = CGSizeMake(0, 1000);
    [self loadData];
    
    //    [self.view setNeedsDisplay];
}

- (void)viewWillAppear:(BOOL)animated {
    if (msAyStr) {
        [self.ayButton setTitle:msAyStr forState:UIControlStateNormal];
    }
}

- (void)loadData
{
    self.sqrTextField.text = mWsla.sqr;
    self.sqrdhTextField.text = mWsla.sqrdh;
    self.sqrsjTextField.text = mWsla.sqrsj;
    self.sqrzjhmTextField.text = mWsla.sqrzjhm;
    self.ajbdTextField.text = mWsla.ajbd;
    self.ssqqTextView.text = mWsla.ssqq;
    self.sslyTextView.text = mWsla.ssly;
    self.ydsrgxLabel.text = @"当事人律师";
    [self.ayButton setTitle:mWsla.aymc forState:UIControlStateNormal];
    //管辖依据
    [LSHttpTool get:GetGxyjInfoUrl params:nil success:^(id json) {
        self.GXYJs = [LSGXYJInfo mj_objectArrayWithKeyValuesArray:json[@"data"][@"result"]];
        for (LSGXYJInfo *Gxyj in self.GXYJs) {
            if ([Gxyj.dm isEqualToString:mWsla.gxyjdm]) {
                [self.GxyjButton setTitle:Gxyj.dmms forState:UIControlStateNormal];
            }
            [self.Gxyjarr addObject:Gxyj.dmms];
        }
        NSLog(@"GetGxyjInfoUrl--%@",json);
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不稳定,请稍后再试"];
    }];
}



- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)ayClick:(id)sender {
    LSAYTreeViewController *msAyVC = [[LSAYTreeViewController alloc]init];
    [self.navigationController pushViewController:msAyVC animated:YES];
}
- (IBAction)ygdClick:(id)sender {
    if(self.dropDown == nil) {
        CGFloat f = 160;
        self.dropDown = [[NIDropDown alloc]showDropDown:sender :&f :self.Gxyjarr :nil :@"down"];
        self.dropDown.delegate = self;
    }
    else {
        [self.dropDown hideDropDown:sender];
        [self rel];
    }
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    [self rel];
}

-(void)rel{
    //    [dropDown release];
    self.dropDown = nil;
}

- (IBAction)saveClick:(id)sender {
    if (self.sqrTextField.text.length == 0) {
        [MBProgressHUD showError:@"申请人不能为空"];
        return;
    }
    if (self.sqrdhTextField.text.length == 0) {
        [MBProgressHUD showError:@"联系电话不能为空"];
        return;
    }
    if (self.sqrsjTextField.text.length == 0) {
        [MBProgressHUD showError:@"手机号码不能为空"];
        return;
    }
    if (self.sqrsjTextField.text.length != 11 || ![[self.sqrsjTextField.text substringToIndex:1] isEqualToString:@"1"]) {
        [MBProgressHUD showError:@"手机号码不正确"];
        return;
    }
    if (self.sqrzjhmTextField.text.length == 0) {
        [MBProgressHUD showError:@"身份证号码不能为空"];
        return;
    }
    if (![XYVerifyIDTool verifyIDCardNumber:self.sqrzjhmTextField.text]) {
        [MBProgressHUD showError:@"身份证号码不正确"];
        return;
    }
    if ([self.ayButton.titleLabel.text isEqualToString:@"点击选择立案案由"]) {
        [MBProgressHUD showError:@"请选择案由"];
        return;
    }

    
    if (self.ajbdTextField.text.length == 0) {
        [MBProgressHUD showError:@"标的额不能为空"];
        return;
    }
    if (self.sslyTextView.text.length == 0) {
        [MBProgressHUD showError:@"事实理由不能为空"];
        return;
    } if (self.ssqqTextView.text.length == 0) {
        [MBProgressHUD showError:@"诉讼请求不能为空"];
        return;
    }
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"ajbs"] = mWsla.ajbs;
    params[@"fydm"] = mWsla.fydm;
    if ([self.ajlbStr isEqualToString:@"民事"]) {
        params[@"lxbm"] = @"20";
    }else if([self.ajlbStr isEqualToString:@"行政"]){
        params[@"lxbm"] = @"60";
    }else if([self.ajlbStr isEqualToString:@"执行"]){
        params[@"lxbm"] = @"80";
    }
    for (LSSPCXInfo *Spcx in self.SPCXs) {
        if ([self.spcxStr isEqualToString:Spcx.dmqc]) {
            params[@"ajfldm"] = Spcx.dm;
        }
    }
    params[@"sqr"] = self.sqrTextField.text;
    params[@"sqrdh"] = self.sqrdhTextField.text;
    params[@"sqrsj"] = self.sqrsjTextField.text;
    params[@"sqrzjhm"] = self.sqrzjhmTextField.text;
    params[@"ydsrgxdm"] = @"3";
#warning 案由名称要改
    params[@"aymc"] = self.ayButton.titleLabel.text;
    params[@"aybm"] = msAyDm;
    
    for (LSGXYJInfo *Gxyj in self.GXYJs) {
        if ([Gxyj.dmms isEqualToString:self.GxyjButton.titleLabel.text]) {
            params[@"gxyjdm"] = Gxyj.dm;
        }
    }
    params[@"ajbd"] = self.ajbdTextField.text;
    params[@"ssqq"] = self.ssqqTextView.text;
    params[@"ssly"] = self.sslyTextView.text;
    params[@"tqxzpcfs"] = mWsla.tqxzpcfs;
    params[@"sqxzpcje"] = mWsla.sqxzpcje;
    params[@"zxyj"] = mWsla.zxyj;
    params[@"yjjg"] = mWsla.yjjg;
    params[@"yjwh"] = mWsla.yjwh;
    params[@"lsid"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"lsid"];
    NSLog(@"xxxxfefe%@",params);
    [LSHttpTool get:WSLASaveOrUpdateUrl params:params success:^(id json) {
        NSLog(@"000--%@",json);
        LSBaseModel *baseModel=[LSBaseModel mj_objectWithKeyValues:json];
        if ([baseModel.status isEqualToString:@"success"]) {
            [MBProgressHUD showSuccess:@"修改成功"];
            [self jumpToVC];
        } else {
            [MBProgressHUD showError:@"修改失败"];
        }

    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不稳定,请稍后再试"];
    }];
    
}
- (void)jumpToVC {
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[LSWSLAMainViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}
@end
