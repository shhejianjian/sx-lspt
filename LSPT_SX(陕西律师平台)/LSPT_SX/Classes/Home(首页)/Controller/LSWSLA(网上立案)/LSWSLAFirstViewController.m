//
//  LSWSLAFirstViewController.m
//  LSPT_SX
//
//  Created by 谢琰 on 16/2/25.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSWSLAFirstViewController.h"
#import "NIDropDown.h"
#import "LSWSLA.h"
#import "LSPT.h"
#import "LSWSLASecondZxViewController.h"
#import "LSWSLASecondMsViewController.h"
#import "LSWSLASecondXzViewController.h"
#import "LSSPCXInfo.h"
@interface LSWSLAFirstViewController ()<NIDropDownDelegate>
@property (weak, nonatomic) IBOutlet UIView *edgeView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (nonatomic, strong) NIDropDown *dropDown;
@property (weak, nonatomic) IBOutlet UILabel *fymcLabel;
@property (weak, nonatomic) IBOutlet UIButton *ajlbButton;
@property (weak, nonatomic) IBOutlet UIButton *spcxButton;
@property (nonatomic, strong) NSMutableArray *SPCXs;
@property (nonatomic, strong) NSMutableArray *arr;
@property (weak, nonatomic) IBOutlet UIView *instructionView;
@end
extern NSString *msAyStr;
extern NSString *msAyDm;
extern NSString *xzAyStr;
extern NSString *xzAyDm;
extern NSString *zxAyStr;
extern NSString *zxAyDm;
@implementation LSWSLAFirstViewController
- (NSMutableArray *)arr
{
    if (!_arr) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}

- (NSMutableArray *)SPCXs
{
    if (!_SPCXs) {
        _SPCXs = [NSMutableArray array];
    }
    return _SPCXs;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"网上立案";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
    [self updateUI];
    [self loadData];
}
- (void)loadData
{
    self.fymcLabel.text = self.fymcStr;
    NSLog(@"xxxx%@",self.ajlbStr);
    [self.ajlbButton setTitle:self.ajlbStr forState:UIControlStateNormal];
    NSLog(@"xxx%@",self.ajlbStr);
//    [self.spcxButton setTitle:self.spcxStr forState:UIControlStateNormal];
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"fybm"] = self.fydmStr;
    
    params[@"ajlb"] = self.lxbmStr;
    [LSHttpTool get:GetSpcxInfoUrl params:params success:^(id json) {
        NSLog(@"spcx%@--%@",params,json);
        self.SPCXs = [LSSPCXInfo mj_objectArrayWithKeyValuesArray:json[@"data"][@"result"]];
        for (LSSPCXInfo *spcx in self.SPCXs) {
            if ([spcx.dm isEqualToString:self.ajfldmStr]) {
            [self.spcxButton setTitle:spcx.dmqc forState:UIControlStateNormal];

            }
            [self.arr addObject:spcx.dmqc];
        }
        NSLog(@"fefexxx%@",self.SPCXs);
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不稳定,请稍后再试"];
    }];

}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)selectType:(id)sender {
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
- (IBAction)nextClick:(id)sender {
    
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
    
    NSLog(@"nextClick %@--%@",self.spcxButton.titleLabel.text,self.ajlbButton.titleLabel.text);
    if (!self.ajlbButton.titleLabel.text) {
        [MBProgressHUD showError:@"请先选择案件类别"];
        return;
    }
    if (![self.spcxButton.titleLabel.text containsString:self.ajlbButton.titleLabel.text]) {
        [MBProgressHUD showError:@"请选择正确的审判程序"];
        return;
    }
    if ([self.ajlbButton.titleLabel.text isEqualToString:@"民事"]) {
        LSWSLASecondMsViewController *secondVC = [[LSWSLASecondMsViewController alloc]init];
        secondVC.SPCXs = self.SPCXs;
        secondVC.spcxStr = self.spcxButton.titleLabel.text;
        secondVC.ajlbStr = self.ajlbButton.titleLabel.text;
        [self.navigationController pushViewController:secondVC animated:YES];
     }
    if ([self.ajlbButton.titleLabel.text isEqualToString:@"行政"]) {
        LSWSLASecondXzViewController *secondVC = [[LSWSLASecondXzViewController alloc]init];
        secondVC.SPCXs = self.SPCXs;
        secondVC.spcxStr = self.spcxButton.titleLabel.text;
        secondVC.ajlbStr = self.ajlbButton.titleLabel.text;
        [self.navigationController pushViewController:secondVC animated:YES];
    }
    if ([self.ajlbButton.titleLabel.text isEqualToString:@"执行"]) {
        LSWSLASecondZxViewController *secondVC = [[LSWSLASecondZxViewController alloc]init];
        secondVC.SPCXs = self.SPCXs;
        secondVC.spcxStr = self.spcxButton.titleLabel.text;
        secondVC.ajlbStr = self.ajlbButton.titleLabel.text;
        [self.navigationController pushViewController:secondVC animated:YES];
    }
   }
- (IBAction)selectNum:(id)sender {
        if(self.dropDown == nil) {
        CGFloat f = self.arr.count * 40;
        self.dropDown = [[NIDropDown alloc]showDropDown:sender :&f :self.arr :nil :@"down"];
        self.dropDown.delegate = self;
    }
    else {
        [self.dropDown hideDropDown:sender];
        [self rel];
    }
}
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    [self rel];
    if (self.ajlbButton.titleLabel.text) {
        [self loadSPCX];
    }    NSLog(@"niDropDownDelegateMethod");
}
- (void)loadSPCX
{
    
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"fybm"] = self.fydmStr;
    if ([self.ajlbButton.titleLabel.text isEqualToString:@"民事"]) {
        params[@"ajlb"] = @"20";
    }else if([self.ajlbButton.titleLabel.text isEqualToString:@"行政"]){
        params[@"ajlb"] = @"60";
    }else if([self.ajlbButton.titleLabel.text isEqualToString:@"执行"]){
        params[@"ajlb"] = @"80";
    }
    [LSHttpTool get:GetSpcxInfoUrl params:params success:^(id json) {
        [self.arr removeAllObjects];
        NSLog(@"loadSPCX %@--%@",params,json);
        self.SPCXs = [LSSPCXInfo mj_objectArrayWithKeyValuesArray:json[@"data"][@"result"]];
        for (LSSPCXInfo *spcx in self.SPCXs) {
//            if ([spcx.dm isEqualToString:self.ajfldmStr]) {
//                [self.spcxButton setTitle:spcx.dmqc forState:UIControlStateNormal];
//            }
            [self.arr addObject:spcx.dmqc];
        }
        NSLog(@"fefexxx%@",self.SPCXs);
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不稳定,请稍后再试"];
    }];


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
