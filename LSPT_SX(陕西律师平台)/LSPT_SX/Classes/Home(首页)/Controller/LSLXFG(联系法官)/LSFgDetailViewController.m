//
//  LSFgDetailViewController.m
//  LSPT_SX
//
//  Created by 何键键 on 16/2/25.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSFgDetailViewController.h"
#import "LSDropdownMenu.h"
#import "UIView+Extension.h"
#import "LSFGMenuTableViewController.h"
#import "LSPJTableViewController.h"
#import "LSPjXgScTableViewController.h"
#import "LSPJViewController.h"
#import "LSFgChangeViewController.h"
#import "LSWSLAFirstViewController.h"
#import "LSLXFGModel.h"
#import "LSPT.h"

@interface LSFgDetailViewController ()<LSDropdownMenuDelegate>
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (nonatomic, strong) LSDropdownMenu *menu;

@property (weak, nonatomic) IBOutlet UILabel *ahqcLabel;
@property (weak, nonatomic) IBOutlet UILabel *cbfgLabel;
@property (weak, nonatomic) IBOutlet UILabel *fqlsLabel;
@property (weak, nonatomic) IBOutlet UILabel *btLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *hfnrLabel;
@property (weak, nonatomic) IBOutlet UILabel *nrLabel;


@end


NSString *ahqcStr;
NSString *cbfgStr;
NSString *twbtStr;
NSString *nrStr;
NSString *idStr;
@implementation LSFgDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"联系法官详情";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
    self.detailView.layer.cornerRadius = 5;
    self.detailView.layer.masksToBounds = YES;
    self.detailView.layer.borderWidth = 1;
    self.detailView.layer.borderColor = LSGrayColor.CGColor;
    if ([_lxfgDetail.zt isEqualToString:@"1"]) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(selectZanCun:) image:@"iv_pop_out" highImage:@"iv_pop_out" title:nil];
    } else if ([_lxfgDetail.zt isEqualToString:@"3"]) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(selectTG:) image:@"iv_pop_out" highImage:@"iv_pop_out" title:nil];
    } else if ([_lxfgDetail.zt isEqualToString:@"4"]) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(selectWTG:) image:@"iv_pop_out" highImage:@"iv_pop_out" title:nil];
    }
    self.ahqcLabel.text = _lxfgDetail.ahqc;
    self.cbfgLabel.text = _lxfgDetail.cbfgmc;
    self.fqlsLabel.text = _lxfgDetail.fqlsmc;
    self.btLabel.text = _lxfgDetail.bt;
    if ([_lxfgDetail.hfsj isEqualToString:@"0"]) {
        _dateLabel.text = @" ";
    } else {
        _dateLabel.text = [self covertToDateStringFromString:_lxfgDetail.hfsj];
    }
    self.hfnrLabel.text = _lxfgDetail.hfnr;
    self.nrLabel.text = _lxfgDetail.nr;
    ahqcStr = _lxfgDetail.ahqc;
    cbfgStr = _lxfgDetail.cbfgmc;
    twbtStr = _lxfgDetail.bt;
    nrStr = _lxfgDetail.nr;
    idStr = _lxfgDetail.ID;
    NSLog(@"%@==%@",idStr,_lxfgDetail.ID);
    [self.view setNeedsDisplay];
}
- (NSString *)covertToDateStringFromString:(NSString *)Str
{
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:[Str longLongValue]/1000.0];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter stringFromDate:date];
}
- (void)back
{
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
    LSFgChangeViewController *changeVC = [[LSFgChangeViewController alloc]init];
    [self.navigationController pushViewController:changeVC animated:YES];
    [self.menu dismiss];
}
- (void)deleteDidClick
{
    NSLog(@"删除");
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"id"] = _lxfgDetail.ID;
    [LSHttpTool get:LXFGDelUrl params:param success:^(id json) {
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
