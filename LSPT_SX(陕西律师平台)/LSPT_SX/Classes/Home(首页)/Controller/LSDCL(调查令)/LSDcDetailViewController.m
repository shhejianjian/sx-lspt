//
//  LSDcDetailViewController.m
//  LSPT_SX
//
//  Created by 何键键 on 16/2/25.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSDcDetailViewController.h"
#import "LSDCLModel.h"
#import "LSDropdownMenu.h"
#import "UIView+Extension.h"
#import "LSFGMenuTableViewController.h"
#import "LSPJTableViewController.h"
#import "LSPjXgScTableViewController.h"
#import "LSPJViewController.h"
#import "LSDclChangeViewController.h"
#import "LSPT.h"
@interface LSDcDetailViewController ()<LSDropdownMenuDelegate>
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *ahqcLabel;
@property (weak, nonatomic) IBOutlet UILabel *hfsjLabel;
@property (weak, nonatomic) IBOutlet UILabel *hfnrLabel;
@property (weak, nonatomic) IBOutlet UILabel *sqyyLabel;
@property (nonatomic, strong) LSDropdownMenu *menu;

@end

NSString *dclahqcStr;
NSString *dclnrStr;
NSString *dclIdStr;
@implementation LSDcDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"调查令详情";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
    if ([_dclDetail.zt isEqualToString:@"1"]) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(selectZanCun:) image:@"iv_pop_out" highImage:@"iv_pop_out" title:nil];
    } else if ([_dclDetail.zt isEqualToString:@"3"]) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(selectTG:) image:@"iv_pop_out" highImage:@"iv_pop_out" title:nil];
    } else if ([_dclDetail.zt isEqualToString:@"4"]) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(selectWTG:) image:@"iv_pop_out" highImage:@"iv_pop_out" title:nil];
    }
    self.detailView.layer.cornerRadius = 5;
    self.detailView.layer.masksToBounds = YES;
    self.detailView.layer.borderWidth = 1;
    self.detailView.layer.borderColor = LSGrayColor.CGColor;
    // Do any additional setup after loading the view from its nib.
    _ahqcLabel.text = _dclDetail.ahqc;
    if ([_dclDetail.spsj isEqualToString:@"0"]) {
        _hfsjLabel.text = @" ";
    } else {
        _hfsjLabel.text = [self covertToDateStringFromString:_dclDetail.spsj];
    }
    _hfnrLabel.text = _dclDetail.spyj;
    _sqyyLabel.text = _dclDetail.sqyy;
    
    dclahqcStr = _dclDetail.ahqc;
    dclnrStr = _dclDetail.sqyy;
    dclIdStr = _dclDetail.ID;
    NSLog(@"dclid===%@====%@",dclIdStr,_dclDetail.ID);
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
    LSDclChangeViewController *changeVC = [[LSDclChangeViewController alloc]init];
    [self.navigationController pushViewController:changeVC animated:YES];
    [self.menu dismiss];
}
- (void)deleteDidClick
{
    NSLog(@"删除");
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"id"] = _dclDetail.ID;
    [LSHttpTool get:DCLDelUrl params:param success:^(id json) {
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
