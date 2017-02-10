//
//  LSBrDetailViewController.m
//  LSPT_SX
//
//  Created by 何键键 on 16/2/25.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSBrDetailViewController.h"
#import "LSTSBRModel.h"
#import "LSFGMenuTableViewController.h"
#import "LSPJTableViewController.h"
#import "LSPjXgScTableViewController.h"
#import "LSPJViewController.h"
#import "LSDropdownMenu.h"
#import "UIView+Extension.h"
#import "LSBrChangeViewController.h"
#import "MBProgressHUD+MJ.h"
#import "LSPT.h"

@interface LSBrDetailViewController ()<LSDropdownMenuDelegate>
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *ahqcLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *clsjLabel;
@property (weak, nonatomic) IBOutlet UILabel *clyjLabel;
@property (weak, nonatomic) IBOutlet UILabel *sqyyLabel;
@property (nonatomic, strong) LSDropdownMenu *menu;

@end
NSString *tsbrAhqcStr;
NSString *tsbrIdStr;
NSString *tsbrSqyyStr;
@implementation LSBrDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"避让详情";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
    if ([_tsbrDetail.zt isEqualToString:@"1"]) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(selectZanCun:) image:@"iv_pop_out" highImage:@"iv_pop_out" title:nil];
    } else if ([_tsbrDetail.zt isEqualToString:@"3"]) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(selectTG:) image:@"iv_pop_out" highImage:@"iv_pop_out" title:nil];
    } else if ([_tsbrDetail.zt isEqualToString:@"4"]) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(selectWTG:) image:@"iv_pop_out" highImage:@"iv_pop_out" title:nil];
    }
    
    self.detailView.layer.cornerRadius = 5;
    self.detailView.layer.masksToBounds = YES;
    self.detailView.layer.borderWidth = 1;
    self.detailView.layer.borderColor = LSGrayColor.CGColor;
    // Do any additional setup after loading the view from its nib.
    _ahqcLabel.text = _tsbrDetail.ahqc;
    _dateLabel.text = _tsbrDetail.updatetime;
    if ([_tsbrDetail.zt isEqualToString:@"1"]) {
        self.statusLabel.text = @"暂存";
    } else if ([_tsbrDetail.zt isEqualToString:@"2"]) {
        self.statusLabel.text = @"提交";
    } else if ([_tsbrDetail.zt isEqualToString:@"3"]) {
        self.statusLabel.text = @"已通过审核";
    } else if ([_tsbrDetail.zt isEqualToString:@"4"]) {
        self.statusLabel.text = @"未通过审核";
    }
    _clyjLabel.text = _tsbrDetail.spyj;
    _sqyyLabel.text = _tsbrDetail.sqyy;
//    if ([_lxfgDetail.hfsj isEqualToString:@"0"]) {
//        _dateLabel.text = nil;
//    } else {
//        _dateLabel.text = [self covertToDateStringFromString:_lxfgDetail.hfsj];
//    }
    if ([_tsbrDetail.sqsj isEqualToString:@"0"]) {
        _dateLabel.text = @" ";
    } else {
    _dateLabel.text = [self covertToDateStringFromString:_tsbrDetail.sqsj];
    }
    if ([_tsbrDetail.spsj isEqualToString:@"0"]) {
        _clsjLabel.text = @" ";
    } else {
    _clsjLabel.text = [self covertToDateStringFromString:_tsbrDetail.spsj];
    }
    tsbrAhqcStr= _tsbrDetail.ahqc;
    tsbrIdStr = _tsbrDetail.ID;
    tsbrSqyyStr = _tsbrDetail.sqyy;
    [self.view setNeedsLayout];
    
}
- (NSString *)covertToDateStringFromString:(NSString *)Str
{
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:[Str longLongValue]/1000.0];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter stringFromDate:date];
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    //监听评价点击
    [LSNotificationCenter addObserver:self selector:@selector(pingJiaDidClick) name:LSPJModifyDidClickNotification object:nil];
    // 监听修改点击
    [LSNotificationCenter addObserver:self selector:@selector(modifyDidClick) name:LSFGModifyDidClickNotification object:nil];
    // 监听删除点击
    [LSNotificationCenter addObserver:self selector:@selector(deleteDidClick) name:LSFGDeleteDidClickNotification object:nil];
    
}
#pragma mark - 监听通知

- (void)pingJiaDidClick {
    NSLog(@"评价");
    LSPJViewController *pjVC = [[LSPJViewController alloc]init];
    [self.navigationController pushViewController:pjVC animated:YES];
    [self.menu dismiss];
}

- (void)modifyDidClick
{
    NSLog(@"修改");
    LSBrChangeViewController *changeVC = [[LSBrChangeViewController alloc]init];
    [self.navigationController pushViewController:changeVC animated:YES];
    [self.menu dismiss];
}
- (void)deleteDidClick
{
    NSLog(@"删除");
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"id"] = _tsbrDetail.ID;
    [LSHttpTool get:TSBRDelUrl params:param success:^(id json) {
        NSLog(@"==%@",json);
        LSBaseModel *baseModel=[LSBaseModel mj_objectWithKeyValues:json];
        if ([baseModel.status isEqualToString:@"success"]) {
            [MBProgressHUD showSuccess:@"删除成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showError:@"删除失败"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络连接错误"];
    }];
    

    [self.menu dismiss];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [LSNotificationCenter removeObserver:self];
}


- (void)selectZanCun:(UIView *)view
{
    // 1.创建下拉菜单
    self.menu = [LSDropdownMenu menu];
    self.menu.delegate = self;
    // 2.设置内容
    LSFGMenuTableViewController *vc = [[LSFGMenuTableViewController alloc] init];
    vc.view.height = 88;
    vc.view.width = 115;
    self.menu.contentController = vc;
    // 3.显示
    [self.menu showFrom:view];
    
}
- (void)selectTG:(UIView *)view
{
    // 1.创建下拉菜单
    self.menu = [LSDropdownMenu menu];
    self.menu.delegate = self;
    // 2.设置内容
    LSPJTableViewController *vc = [[LSPJTableViewController alloc] init];
    vc.view.height = 44;
    vc.view.width = 115;
    self.menu.contentController = vc;
    // 3.显示
    [self.menu showFrom:view];
    
}
- (void)selectWTG:(UIView *)view
{
    // 1.创建下拉菜单
    self.menu = [LSDropdownMenu menu];
    self.menu.delegate = self;
    // 2.设置内容
    LSPjXgScTableViewController *vc = [[LSPjXgScTableViewController alloc] init];
    vc.view.height = 132;
    vc.view.width = 115;
    self.menu.contentController = vc;
    // 3.显示
    [self.menu showFrom:view];
    
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
