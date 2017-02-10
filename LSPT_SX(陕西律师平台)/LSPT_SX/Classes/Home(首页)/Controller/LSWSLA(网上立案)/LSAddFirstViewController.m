//
//  LSAddFirstViewController.m
//  LSPT_SX
//
//  Created by 谢琰 on 16/3/1.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSAddFirstViewController.h"
#import "LSPT.h"
#import "LSFYInfo.h"
#import "NIDropDown.h"
#import "LSSPCXInfo.h"
#import "LSAddSecondMsViewController.h"
#import "LSAddSecondZxViewController.h"
#import "LSAddSecondXzViewController.h"
@interface LSAddFirstViewController ()<NIDropDownDelegate>
@property (weak, nonatomic) IBOutlet UIView *edgeView;
@property (nonatomic, strong) NIDropDown *dropDown;
@property (nonatomic ,strong) NSMutableArray *FYs;
@property (nonatomic ,strong) NSMutableArray *FyArr;
@property (nonatomic, strong) NSMutableArray *SPCXs;
@property (weak, nonatomic) IBOutlet UIButton *spcxButton;
@property (weak, nonatomic) IBOutlet UIButton *fyButton;
@property (nonatomic, strong) NSMutableArray *SpcxArr;
@property (weak, nonatomic) IBOutlet UIButton *ajlbButton;
@property (nonatomic ,copy) NSString *fydmAddStr;
@property (weak, nonatomic) IBOutlet UIView *instructionView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end
extern NSString *msAyStr;
extern NSString *msAyDm;
extern NSString *xzAyStr;
extern NSString *xzAyDm;
extern NSString *zxAyStr;
extern NSString *zxAyDm;
@implementation LSAddFirstViewController
- (NSMutableArray *)SpcxArr
{
    if (!_SpcxArr) {
        _SpcxArr = [NSMutableArray array];
    }
    return _SpcxArr;
}

- (NSMutableArray *)SPCXs
{
    if (!_SPCXs) {
        _SPCXs = [NSMutableArray array];
    }
    return _SPCXs;
}

- (NSMutableArray *)FYs
{
    if (!_FYs) {
        _FYs = [NSMutableArray array];
    }
    return _FYs;
}
- (NSMutableArray *)FyArr
{
    if (!_FyArr) {
        _FyArr = [NSMutableArray array];
    }
    return _FyArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"网上立案";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
    [self updateUI];
    [self loadData];
}
- (void)updateUI
{
    self.edgeView.layer.cornerRadius = 5.0f;
    self.edgeView.layer.borderWidth = 1.0f;
    self.edgeView.layer.borderColor = LSGrayColor.CGColor;
    self.nextButton.layer.cornerRadius = 5.0f;
    self.instructionView.layer.cornerRadius = 5.0f;
    self.instructionView.layer.borderWidth = 1.0f;
    self.instructionView.layer.borderColor = LSGrayColor.CGColor;
}

- (void)loadData
{
    //法院信息接口
    [LSHttpTool get:GetFyInfoUrl params:nil success:^(id json) {
        self.FYs = [LSFYInfo mj_objectArrayWithKeyValuesArray:json[@"data"][@"fyList"]];
        for (LSFYInfo *fy in self.FYs) {
            [self.FyArr addObject:[NSString stringWithFormat:@"%@(%@)",fy.dmms,fy.xssx]];
        }
        
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
- (IBAction)spcxInfoClick:(id)sender {
    
    if(self.dropDown == nil) {
        CGFloat f = self.SpcxArr.count * 40;
        self.dropDown = [[NIDropDown alloc]showDropDown:sender :&f :self.SpcxArr :nil :@"down"];
        self.dropDown.delegate = self;
    }
    else {
        [self.dropDown hideDropDown:sender];
        [self rel];
    }

}
- (IBAction)fyInfoClick:(id)sender {
    NSLog(@"fyInfoClick");
    if(self.dropDown == nil) {
        CGFloat f = 160;
        self.dropDown = [[NIDropDown alloc]showDropDown:sender :&f :self.FyArr :nil :@"down"];
        self.dropDown.delegate = self;
    }
    else {
        [self.dropDown hideDropDown:sender];
        [self rel];
    }
}
- (IBAction)ajlbClick:(id)sender {
    if ([self.fyButton.titleLabel.text isEqualToString:@"请输入法院名称"]) {
        [MBProgressHUD showError:@"请先输入正确的法院"];
        return;
    }
    //民事
    NSArray * arr = [[NSArray alloc] init];
    arr = [NSArray arrayWithObjects:@"民事", @"行政", @"执行",nil];
    if(self.dropDown == nil) {
        CGFloat f = 120;
        self.dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :nil :@"down"];
        self.dropDown.delegate = self;
    }
    else {
        [self.dropDown hideDropDown:sender];
        [self rel];
    }
    
}
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    if (![self.ajlbButton.titleLabel.text isEqualToString:@"请选择案件类别"] && ![self.fyButton.titleLabel.text isEqualToString:@"请输入法院名称"]) {
        self.spcxButton.enabled = YES;
        [self loadSpcx];
    }
    [self rel];
}
- (void)loadSpcx
{
    [self.SpcxArr removeAllObjects];
    //审判程序
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    if (![self.fyButton.titleLabel.text isEqualToString:@"请输入法院名称"]) {
        NSRange range;
        range.location = [self.fyButton.titleLabel.text rangeOfString:@"("].location + 1;
        range.length = [self.fyButton.titleLabel.text rangeOfString:@")"].location - range.location;
        params[@"fybm"] = [self.fyButton.titleLabel.text substringWithRange:range];
        self.fydmAddStr = [self.fyButton.titleLabel.text substringWithRange:range];
    }
    if ([self.ajlbButton.titleLabel.text isEqualToString:@"民事"]) {
        params[@"ajlb"] = @"20";
    }else if([self.ajlbButton.titleLabel.text isEqualToString:@"行政"]){
        params[@"ajlb"] = @"60";
    }else if([self.ajlbButton.titleLabel.text isEqualToString:@"执行"]){
        params[@"ajlb"] = @"80";
    }

    NSLog(@"000--%@",params);
    [LSHttpTool get:GetSpcxInfoUrl params:params success:^(id json) {
        NSLog(@"spcx----> %@--%@",params,json);
        self.SPCXs = [LSSPCXInfo mj_objectArrayWithKeyValuesArray:json[@"data"][@"result"]];
        for (LSSPCXInfo *spcx in self.SPCXs) {
            [self.SpcxArr addObject:spcx.dmqc];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"xxx网络不稳定,请稍后再试"];
    }];

}
-(void)rel{
    //    [dropDown release];
    self.dropDown = nil;
}
- (IBAction)nextClick:(id)sender {
//    if (![self.ajlbButton.titleLabel.text isEqualToString:@"请选择案件类别"] && ![self.fyButton.titleLabel.text isEqualToString:@"请输入法院名称"])
    if (msAyStr) {
        msAyStr = nil;
        msAyDm = nil;
    }
    if (xzAyStr) {
        xzAyStr = nil;
        xzAyDm = nil;
    }
    if (zxAyStr) {
        zxAyStr = nil;
        zxAyDm = nil;
    }
    if ([self.fyButton.titleLabel.text isEqualToString:@"请输入法院名称"]) {
        [MBProgressHUD showError:@"请先输入正确的法院"];
        return;
    }
    if ([self.ajlbButton.titleLabel.text isEqualToString:@"请选择案件类别"]) {
        [MBProgressHUD showError:@"请选择案件类别"];
        return;
    }
    if ([self.spcxButton.titleLabel.text isEqualToString:@"请选择审判程序"]) {
        [MBProgressHUD showError:@"请选择审判程序"];
        return;
    }
    if (![self.spcxButton.titleLabel.text containsString:self.ajlbButton.titleLabel.text]) {
        [MBProgressHUD showError:@"请选择正确的审判程序"];
        return;
    }
    if ([self.ajlbButton.titleLabel.text isEqualToString:@"民事"]) {
        LSAddSecondMsViewController *secondVC = [[LSAddSecondMsViewController alloc]init];
        secondVC.SPCXs = self.SPCXs;
        secondVC.fydmAddStr = self.fydmAddStr;
        secondVC.spcxAddStr = self.spcxButton.titleLabel.text;
        secondVC.ajlbAddStr = self.ajlbButton.titleLabel.text;
        [self.navigationController pushViewController:secondVC animated:YES];
    }
    if ([self.ajlbButton.titleLabel.text isEqualToString:@"行政"]) {
        LSAddSecondXzViewController *secondVC = [[LSAddSecondXzViewController alloc]init];
        secondVC.SPCXs = self.SPCXs;
        secondVC.fydmAddStr = self.fydmAddStr;
        secondVC.spcxAddStr = self.spcxButton.titleLabel.text;
        secondVC.ajlbAddStr = self.ajlbButton.titleLabel.text;
        [self.navigationController pushViewController:secondVC animated:YES];
    }
    if ([self.ajlbButton.titleLabel.text isEqualToString:@"执行"]) {
        LSAddSecondZxViewController *secondVC = [[LSAddSecondZxViewController alloc]init];
        secondVC.SPCXs = self.SPCXs;
        secondVC.fydmAddStr = self.fydmAddStr;
        secondVC.spcxAddStr = self.spcxButton.titleLabel.text;
        secondVC.ajlbAddStr = self.ajlbButton.titleLabel.text;
        [self.navigationController pushViewController:secondVC animated:YES];
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

@end
