//
//  LSNaturalPersonViewController.m
//  LSPT_SX
//
//  Created by 谢琰 on 16/2/25.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSNaturalPersonViewController.h"
#import "NIDropDown.h"
#import "LSPT.h"
#import "LSMzInfo.h"
#import "LSWhcdInfo.h"
#import "LSZzmmInfo.h"
#import "LSWSLA.h"
#import "LSSsdwInfo.h"
#import "LSLitigantListViewControlle.h"
#import "XYVerifyIDTool.h"
#import "LSAddLitigantViewController.h"

@interface LSNaturalPersonViewController ()<NIDropDownDelegate>
@property (weak, nonatomic) IBOutlet UIView *edgeView;
@property (nonatomic, strong) NIDropDown *dropDown;
@property (nonatomic, strong) NSMutableArray *MZs;
@property (nonatomic, strong) NSMutableArray *MzArr;
@property (nonatomic, strong) NSMutableArray *WHCDs;
@property (nonatomic, strong) NSMutableArray *WhcdArr;
@property (nonatomic, strong) NSMutableArray *ZZMMs;
@property (nonatomic, strong) NSMutableArray *ZzmmArr;
@property (nonatomic, strong) NSMutableArray *SSDWs;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *ssdwButton;
@property (weak, nonatomic) IBOutlet UITextField *dhhmTextField;
@property (weak, nonatomic) IBOutlet UIButton *mzButton;
@property (weak, nonatomic) IBOutlet UIButton *zzmmButton;
@property (weak, nonatomic) IBOutlet UIButton *whcdButton;
@property (weak, nonatomic) IBOutlet UITextField *sfzhTextField;
@property (weak, nonatomic) IBOutlet UITextField *dwmcTextField;
@property (weak, nonatomic) IBOutlet UIButton *sexButton;
@property (weak, nonatomic) IBOutlet UITextField *dzTextField;
@property (nonatomic, strong) NSMutableArray *SsdwArr;
@end

@implementation LSNaturalPersonViewController
extern LSWSLA *mWsla;
extern NSInteger VCindex;

- (NSMutableArray *)MZs
{
    if (!_MZs) {
        _MZs = [NSMutableArray array];
    }
    return _MZs;
}
- (NSMutableArray *)MzArr
{
    if (!_MzArr) {
        _MzArr = [NSMutableArray array];
    }
    return _MzArr;
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
- (NSMutableArray *)ZZMMs
{
    if (!_ZZMMs) {
        _ZZMMs = [NSMutableArray array];
    }
    return _ZZMMs;
}
- (NSMutableArray *)ZzmmArr
{
    if (!_ZzmmArr) {
        _ZzmmArr = [NSMutableArray array];
    }
    return _ZzmmArr;
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
    //[self clearNotificationAndGesture];
}
- (void)litigantSaveButtonDidClick
{
    if (VCindex == 0) {
        NSLog(@"LSNaturalPersonViewController");
        if ([self.ssdwButton.titleLabel.text isEqualToString:@"选择当事人诉讼地位"]) {
            NSLog(@"ssdwButton");
            [MBProgressHUD showError:@"请选择当事人诉讼地位"];
            return;
        }
        else if (self.nameTextField.text.length == 0) {
            NSLog(@"nameTextField");
            [MBProgressHUD showError:@"姓名不能为空"];
            return;
        }
       else if ([self.sexButton.titleLabel.text isEqualToString:@"请选择当事人性别"]) {
            [MBProgressHUD showError:@"请选择当事人性别"];
            return;
        }
       else if (self.dhhmTextField.text.length == 0) {
            [MBProgressHUD showError:@"电话号码不能为空"];
            return;
        }
       else if (self.dhhmTextField.text.length != 11 || ![[self.dhhmTextField.text substringToIndex:1] isEqualToString:@"1"]) {
            [MBProgressHUD showError:@"电话号码不正确"];
            return;
        }

       else if (self.sfzhTextField.text.length == 0) {
            [MBProgressHUD showError:@"身份证号不能为空"];
            return;
        }
      else if (![XYVerifyIDTool verifyIDCardNumber:self.sfzhTextField.text]) {
            [MBProgressHUD showError:@"身份证号码不正确"];
            return;
        }
       else if ([self.mzButton.titleLabel.text isEqualToString:@"请选择民族"]) {
            [MBProgressHUD showError:@"请选择民族"];
            return;
        }
      else  if ([self.zzmmButton.titleLabel.text isEqualToString:@"请选择政治面貌"]) {
            [MBProgressHUD showError:@"请选择政治面貌"];
            return;
        }
       else if ([self.whcdButton.titleLabel.text isEqualToString:@"请选择文化程度"]) {
            [MBProgressHUD showError:@"请选择文化程度"];
            return;
        }
       else if (self.dwmcTextField.text.length == 0) {
            [MBProgressHUD showError:@"单位名称不能为空"];
            return;
        }
      else  if (self.dzTextField.text.length == 0) {
            [MBProgressHUD showError:@"地址不能为空"];
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
        params[@"mc"] = self.nameTextField.text;
        if ([self.sexButton.titleLabel.text isEqualToString:@"男"]) {
            params[@"xb"] = @"2";
        }else if ([self.sexButton.titleLabel.text isEqualToString:@"女"]) {
            params[@"xb"] = @"3";
        }else if ([self.sexButton.titleLabel.text isEqualToString:@"未知"]) {
            params[@"xb"] = @"1";
        }else if ([self.sexButton.titleLabel.text isEqualToString:@"其他"]) {
            params[@"xb"] = @"4";
        }
        params[@"dhhm"] = self.dhhmTextField.text;
        params[@"gj"] = @"";
        params[@"sfzhm"] = self.sfzhTextField.text;
        params[@"csrq"] = @"";
        for (LSMzInfo *Mz in self.MZs) {
            if ([Mz.dmms isEqualToString:self.mzButton.titleLabel.text]) {
                params[@"mz"] = Mz.dm;
            }
        }
        for (LSZzmmInfo *Zzmm in self.ZZMMs) {
            if ([Zzmm.dmms isEqualToString:self.zzmmButton.titleLabel.text]) {
                params[@"zzmm"] = Zzmm.dm;
            }
        }
        for (LSWhcdInfo *Whcd in self.WHCDs) {
            if ([Whcd.dmms isEqualToString:self.whcdButton.titleLabel.text]) {
                params[@"whcd"] = Whcd.dm;
            }
        }
        params[@"dwmc"] = self.dwmcTextField.text;
        params[@"frxm"] = @"";
        params[@"frxb"] = @"";
        params[@"dz"] = self.dzTextField.text;
        params[@"zzjgdm"] = @"";

        [LSHttpTool get:SaveDsrUrl params:params success:^(id json) {
            NSLog(@"WSLASaveOrUpdateUrl---%@--%@",params,json);
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
    [LSHttpTool get:GetMzInfoUrl params:nil success:^(id json) {
        self.MZs = [LSMzInfo mj_objectArrayWithKeyValuesArray:json[@"data"][@"result"]];
        for (LSMzInfo *Mz in self.MZs) {
            [self.MzArr addObject:Mz.dmms];
        }
        NSLog(@"GetMzInfoUrl --%@",json);
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showError:@"网络不稳定,请稍后再试"];
    }];
    
    [LSHttpTool get:GetWhcdInfoUrl params:nil success:^(id json) {
        self.WHCDs = [LSWhcdInfo mj_objectArrayWithKeyValuesArray:json[@"data"][@"result"]];
        for (LSWhcdInfo *Whcd in self.WHCDs) {
            [self.WhcdArr addObject:Whcd.dmms];
        }
        NSLog(@"GetWhcdInfoUrl --%@",json);
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showError:@"网络不稳定,请稍后再试"];
    }];

    [LSHttpTool get:GetZzmmInfoUrl params:nil success:^(id json) {
        self.ZZMMs = [LSWhcdInfo mj_objectArrayWithKeyValuesArray:json[@"data"][@"result"]];
        for (LSZzmmInfo *Zzmm in self.ZZMMs) {
            [self.ZzmmArr addObject:Zzmm.dmms];
        }
        NSLog(@"GetZzmmInfoUrl --%@",json);
        
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

- (IBAction)selectDW:(id)sender {
    
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

- (IBAction)selectSex:(id)sender {
        NSArray * arr = [[NSArray alloc] init];
    arr = [NSArray arrayWithObjects:@"未知", @"男",@"女", @"其他",nil];
    if(self.dropDown == nil) {
        CGFloat f = 160;
        self.dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :nil :@"down"];
        self.dropDown.delegate = self;
    }
    else {
        [self.dropDown hideDropDown:sender];
        [self rel];
    }

}
- (IBAction)selectMZ:(id)sender {
   
    if(self.dropDown == nil) {
        CGFloat f = 160;
        self.dropDown = [[NIDropDown alloc]showDropDown:sender :&f :self.MzArr :nil :@"down"];
        self.dropDown.delegate = self;
    }
    else {
        [self.dropDown hideDropDown:sender];
        [self rel];
    }

}
- (IBAction)selectZZMM:(id)sender {
        if(self.dropDown == nil) {
        CGFloat f = 200;
        self.dropDown = [[NIDropDown alloc]showDropDown:sender :&f :self.ZzmmArr :nil :@"up"];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
