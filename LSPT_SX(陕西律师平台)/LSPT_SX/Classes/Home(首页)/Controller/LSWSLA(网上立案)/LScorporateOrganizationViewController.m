//
//  LScorporateOrganizationViewController.m
//  LSPT_SX
//
//  Created by 谢琰 on 16/2/25.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LScorporateOrganizationViewController.h"
#import "NIDropDown.h"
#import "LSPT.h"
#import "LSGjInfo.h"
#import "LSWSLA.h"
#import "LSSsdwInfo.h"
#import "LSLitigantListViewControlle.h"
#import "LSAddLitigantViewController.h"
@interface LScorporateOrganizationViewController ()<NIDropDownDelegate>
@property (nonatomic, strong) NSMutableArray *SSDWs;
@property (nonatomic, strong) NSMutableArray *SsdwArr;
@property (weak, nonatomic) IBOutlet UIView *edgeView;
@property (nonatomic, strong) NIDropDown *dropDown;
@property (nonatomic, strong) NSMutableArray *GJs;
@property (weak, nonatomic) IBOutlet UIButton *ssdwButton;
@property (weak, nonatomic) IBOutlet UITextField *zzmcTextField;
@property (weak, nonatomic) IBOutlet UITextField *dzTextField;
@property (weak, nonatomic) IBOutlet UITextField *dwdhTextField;
@property (weak, nonatomic) IBOutlet UIButton *gjButton;
@property (weak, nonatomic) IBOutlet UITextField *zzjgdmTextField;
@property (nonatomic, strong) NSMutableArray *GjArr;
@end

@implementation LScorporateOrganizationViewController
extern LSWSLA *mWsla;
extern NSInteger VCindex;

- (NSMutableArray *)GJs
{
    if (!_GJs) {
        _GJs = [NSMutableArray array];
    }
    return _GJs;
}
- (NSMutableArray *)GjArr
{
    if (!_GjArr) {
        _GjArr = [NSMutableArray array];
    }
    return _GjArr;
}
- (NSMutableArray *)SSDWs
{
    if (!_SSDWs) {
        _SSDWs = [NSMutableArray array];
    }
    return _SSDWs;
}
- (NSMutableArray *)SsdwArr
{
    if (!_SsdwArr) {
        _SsdwArr = [NSMutableArray array];
    }
    return _SsdwArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgeView.layer.borderColor = LSGlobalColor.CGColor;
    self.edgeView.layer.cornerRadius = 5.0f;
    self.edgeView.layer.borderWidth = 2.0f;
    [self loadData];
    [LSNotificationCenter addObserver:self selector:@selector(litigantSaveButtonDidClick) name:LsLitigantSaveButtonDidClickNotification object:nil];
}
- (void)dealloc
{
    NSLog(@"dealloc LSIncorporateOrganizationViewController");
    [LSNotificationCenter removeObserver:self name:LsLitigantSaveButtonDidClickNotification object:nil];
}
- (void)litigantSaveButtonDidClick
{
    if (VCindex == 2) {
        if ([self.ssdwButton.titleLabel.text isEqualToString:@"选择当事人诉讼地位"]) {
            [MBProgressHUD showError:@"请选择当事人诉讼地位"];
            return;
        }
        if ([self.gjButton.titleLabel.text isEqualToString:@"请选择国籍"]) {
            [MBProgressHUD showError:@"请选择国籍"];
            return;
        }
        if (self.zzmcTextField.text.length == 0) {
            [MBProgressHUD showError:@"组织名称不能为空"];
            return;
        }
        if (self.dzTextField.text.length == 0) {
            [MBProgressHUD showError:@"地址不能为空"];
            return;
        }
        if (self.zzjgdmTextField.text.length == 0) {
            [MBProgressHUD showError:@"组织机构代码不能为空"];
            return;
        }
        if (self.dwdhTextField.text.length == 0) {
            [MBProgressHUD showError:@"单位电话不能为空"];
            return;
        }
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"ajbs"] = mWsla.ajbs;
        for (LSSsdwInfo *ssdw in self.SSDWs) {
            if ([self.ssdwButton.titleLabel.text isEqualToString:ssdw.dmms]) {
                params[@"ssdw"] = ssdw.dm;
            }
        }
        params[@"lxbm"] = mWsla.lxbm;
        params[@"mc"] = @"";
        params[@"xb"] = @"";
        for (LSGjInfo *Gj in self.GJs) {
            if ([Gj.dmms isEqualToString:self.gjButton.titleLabel.text]) {
                params[@"gj"] = Gj.dm;
            }
        }
        params[@"sfzhm"] = @"";
        params[@"csrq"] = @"";
        params[@"mz"] = @"";
        params[@"zzmm"] = @"";
        params[@"whcd"] = @"";
        params[@"dhhm"] = self.dwdhTextField.text;
        params[@"dwmc"] = self.zzmcTextField.text;
        params[@"frxm"] = @"";
        params[@"frxb"] = @"";
        params[@"dz"] = self.dzTextField.text;
        params[@"zzjgdm"] = self.zzjgdmTextField.text;
        
        [LSHttpTool get:SaveDsrUrl params:params success:^(id json) {
            
            [LSNotificationCenter postNotificationName:@"SaveDsrSuccessNotification" object:nil];
            LSBaseModel *baseModel=[LSBaseModel mj_objectWithKeyValues:json];
            if ([baseModel.status isEqualToString:@"success"]) {
                [MBProgressHUD showSuccess:@"添加成功"];
                [self jumpToVC];
            } else {
                [MBProgressHUD showError:@"添加失败"];
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"网络不稳定,请稍后再试"];
        }];

    }
}
- (void)jumpToVC {
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[LSLitigantListViewControlle class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}
- (void)loadData
{
    [LSHttpTool get:GetGjInfoUrl params:nil success:^(id json) {
        self.GJs = [LSGjInfo mj_objectArrayWithKeyValuesArray:json[@"data"][@"result"]];
        for (LSGjInfo *Gj in self.GJs) {
            [self.GjArr addObject:Gj.dmms];
        }
        NSLog(@"GetGjInfoUrl --%@",json);
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showError:@"网络不稳定,请稍后再试"];
    }];
    //诉讼地位
    NSMutableDictionary *ssdwParams = [NSMutableDictionary dictionary];
    ssdwParams[@"ajbs"] = mWsla.ajbs;
    [LSHttpTool get:GetSsdwInfoUrl params:ssdwParams success:^(id json) {
        self.SSDWs = [LSSsdwInfo mj_objectArrayWithKeyValuesArray:json[@"data"][@"result"]];
        for (LSSsdwInfo *Ssdw in self.SSDWs) {
            [self.SsdwArr addObject:Ssdw.dmms];
        }
        NSLog(@"GetSsdwInfoUrl %@--%@",ssdwParams,json);
        
    } failure:^(NSError *error) {
        NSLog(@"GetSsdwInfoUrl --%@",ssdwParams);
        [MBProgressHUD showError:@"xxxx网络不稳定,请稍后再试"];
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)selectBtn1:(id)sender {
          if(self.dropDown == nil) {
        CGFloat f = 120;
        self.dropDown = [[NIDropDown alloc]showDropDown:sender :&f :self.SsdwArr :nil :@"down"];
        self.dropDown.delegate = self;
    }
    else {
        [self.dropDown hideDropDown:sender];
        [self rel];
    }

}
- (IBAction)selectCountry:(id)sender {
    
    if(self.dropDown == nil) {
        CGFloat f = 200;
        self.dropDown = [[NIDropDown alloc]showDropDown:sender :&f :self.GjArr :nil :@"down"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
