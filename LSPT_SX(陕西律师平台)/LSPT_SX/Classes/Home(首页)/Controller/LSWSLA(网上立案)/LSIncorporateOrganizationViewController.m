//
//  LSIncorporateOrganizationViewController.m
//  LSPT_SX
//
//  Created by 谢琰 on 16/2/25.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSIncorporateOrganizationViewController.h"
#import "LSPT.h"
#import "NIDropDown.h"
#import "LSGjInfo.h"
#import "LSWhcdInfo.h"
#import "LSWSLA.h"
#import "LSSsdwInfo.h"
#import "LSLitigantListViewControlle.h"
#import "XYVerifyIDTool.h"
#import "LSAddLitigantViewController.h"

@interface LSIncorporateOrganizationViewController ()<NIDropDownDelegate>
@property (nonatomic, strong) NIDropDown *dropDown;
@property (nonatomic, strong) NSMutableArray *GJs;
@property (nonatomic, strong) NSMutableArray *GjArr;
@property (nonatomic, strong) NSMutableArray *WHCDs;
@property (nonatomic, strong) NSMutableArray *WhcdArr;
@property (nonatomic, strong) NSMutableArray *SSDWs;
@property (nonatomic, strong) NSMutableArray *SsdwArr;
@property (weak, nonatomic) IBOutlet UIButton *ssdwButton;
@property (weak, nonatomic) IBOutlet UIButton *gjButton;
@property (weak, nonatomic) IBOutlet UITextField *zzmcTextField;
@property (weak, nonatomic) IBOutlet UITextField *dzTextField;
@property (weak, nonatomic) IBOutlet UITextField *zzjgdmTextField;
@property (weak, nonatomic) IBOutlet UITextField *dwdhTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *sexButton;
@property (weak, nonatomic) IBOutlet UITextField *zwTextField;
@property (weak, nonatomic) IBOutlet UIButton *whcdButton;
@property (weak, nonatomic) IBOutlet UITextField *dhTextField;
@property (weak, nonatomic) IBOutlet UITextField *sfzhTextField;
@property (weak, nonatomic) IBOutlet UITextField *zcTextField;
@property (weak, nonatomic) IBOutlet UIView *detailView;

@end

@implementation LSIncorporateOrganizationViewController
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
- (NSMutableArray *)WHCDs
{
    if (!_WHCDs) {
        _WHCDs = [NSMutableArray array];
    }
    return _WHCDs;
}
- (NSMutableArray *)WhcdArr
{
    if (!_WhcdArr) {
        _WhcdArr = [NSMutableArray array];
    }
    return _WhcdArr;
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

    self.detailView.layer.borderColor = LSGlobalColor.CGColor;
    self.detailView.layer.cornerRadius = 5.0f;
    self.detailView.layer.borderWidth = 2.0f;
    [self loadData];
    [LSNotificationCenter addObserver:self selector:@selector(litigantSaveButtonDidClick) name:LsLitigantSaveButtonDidClickNotification object:nil];
}

- (void)litigantSaveButtonDidClick
{
    if (VCindex == 1) {
        NSLog(@"LSIncorporateOrganizationViewController");
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
            [MBProgressHUD showError:@"组织机构不能为空"];
            return;
        }
        if (self.dwdhTextField.text.length == 0) {
            [MBProgressHUD showError:@"单位电话不能为空"];
            return;
        }
        if (self.nameTextField.text.length == 0) {
            [MBProgressHUD showError:@"姓名不能为空"];
            return;
        }
        if ([self.sexButton.titleLabel.text isEqualToString:@"请选择当事人性别"]) {
            [MBProgressHUD showError:@"请选择当事人性别"];
            return;
        }
        if (self.zwTextField.text.length == 0) {
            [MBProgressHUD showError:@"职务不能为空"];
            return;
        }
        if ([self.whcdButton.titleLabel.text isEqualToString:@"请选择文化程度"]) {
            [MBProgressHUD showError:@"请选择文化程度"];
            return;
        }
        if (self.dhTextField.text.length == 0) {
            [MBProgressHUD showError:@"电话不能为空"];
            return;
        }
         if (self.dhTextField.text.length != 11 || ![[self.dhTextField.text substringToIndex:1] isEqualToString:@"1"]) {
            [MBProgressHUD showError:@"电话号码不正确"];
            return;
        }
        if (self.sfzhTextField.text.length == 0) {
            [MBProgressHUD showError:@"身份证号不能为空"];
            return;
        }
        if (![XYVerifyIDTool verifyIDCardNumber:self.sfzhTextField.text]) {
            [MBProgressHUD showError:@"身份证号码不正确"];
            return;
        }
        if (self.zcTextField.text.length == 0) {
            [MBProgressHUD showError:@"住处不能为空"];
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
        params[@"dhhm"] = self.dwdhTextField.text;
        for (LSGjInfo *Gj in self.GJs) {
            if ([Gj.dmms isEqualToString:self.gjButton.titleLabel.text]) {
                params[@"gj"] = Gj.dm;
            }
        }
        params[@"sfzhm"] = self.sfzhTextField.text;
        params[@"csrq"] = @"";
        params[@"mz"] = @"";
        params[@"zzmm"] = @"";
        for (LSWhcdInfo *Whcd in self.WHCDs)
        {
            if ([Whcd.dmms isEqualToString:self.whcdButton.titleLabel.text]) {
                params[@"whcd"] = Whcd.dm;
            }
        }
        params[@"dwmc"] = self.zzmcTextField.text;
        params[@"frxm"] = self.nameTextField.text;
        if ([self.sexButton.titleLabel.text isEqualToString:@"男"]) {
            params[@"xb"] = @"2";
        }else if ([self.sexButton.titleLabel.text isEqualToString:@"女"]) {
            params[@"xb"] = @"3";
        }else if ([self.sexButton.titleLabel.text isEqualToString:@"未知"]) {
            params[@"xb"] = @"1";
        }else if ([self.sexButton.titleLabel.text isEqualToString:@"其他"]) {
            params[@"xb"] = @"4";
        }

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
            NSLog(@"SaveDsrUrl-----%@",params);

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
- (void)dealloc
{
    NSLog(@"dealloc LSIncorporateOrganizationViewController");
}

- (void)loadData
{
    //国籍
    [LSHttpTool get:GetWhcdInfoUrl params:nil success:^(id json) {
        self.WHCDs = [LSWhcdInfo mj_objectArrayWithKeyValuesArray:json[@"data"][@"result"]];
        for (LSWhcdInfo *Whcd in self.WHCDs) {
            [self.WhcdArr addObject:Whcd.dmms];
        }
        NSLog(@"GetWhcdInfoUrl --%@",json);
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showError:@"网络不稳定,请稍后再试"];
    }];
    //文化程度
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
- (IBAction)selectDiWei:(id)sender {
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
- (IBAction)selectSex:(id)sender {
    NSArray * arr = [[NSArray alloc] init];
    arr = [NSArray arrayWithObjects:@"未知", @"男",@"女", @"其他",nil];
    if(self.dropDown == nil) {
        CGFloat f = 160;
        self.dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :nil :@"up"];
        self.dropDown.delegate = self;
    }
    else {
        [self.dropDown hideDropDown:sender];
        [self rel];
    }

}
- (IBAction)selectEdu:(id)sender {
       if(self.dropDown == nil) {
        CGFloat f = 200;
        self.dropDown = [[NIDropDown alloc]showDropDown:sender :&f :self.WhcdArr :nil :@"up"];
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

@end
