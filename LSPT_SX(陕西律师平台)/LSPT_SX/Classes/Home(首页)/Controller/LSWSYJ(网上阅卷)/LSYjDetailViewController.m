//
//  LSYjDetailViewController.m
//  LSPT_SX
//
//  Created by 何键键 on 16/2/24.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSYjDetailViewController.h"
#import "LSChangeAppointViewController.h"
#import "LSDropdownMenu.h"
#import "LSFGMenuTableViewController.h"
#import "UIView+Extension.h"
#import "LSWSYJModel.h"
#import "LSPJTableViewController.h"
#import "LSPjXgScTableViewController.h"
#import "LSPJViewController.h"
#import "LSPT.h"

@interface LSYjDetailViewController ()<LSDropdownMenuDelegate>
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) LSDropdownMenu *menu;
@property (weak, nonatomic) IBOutlet UILabel *ahqcLabel;
@property (weak, nonatomic) IBOutlet UILabel *jysjLabel;
@property (weak, nonatomic) IBOutlet UILabel *jymdLabel;

@end
NSString *wsyjAhqcStr;
NSString *wsyjIdStr;
NSString *wsyjjymdStr;
NSString *wsyjjysjStr;
NSString *wsyjajbsStr;
NSString *wsyjjynrStr;
@implementation LSYjDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"借阅详情";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
    self.detailView.layer.cornerRadius = 5;
    self.detailView.layer.masksToBounds = YES;
    self.detailView.layer.borderWidth = 1;
    self.detailView.layer.borderColor = LSGrayColor.CGColor;
    
    _ahqcLabel.text = _wsyjDetail.ahqc;
    _jysjLabel.text = [NSString stringWithFormat:@"借阅日期:%@",[self covertToDateStringFromString:_wsyjDetail.jyrq]];
    _jymdLabel.text = _wsyjDetail.jymd;
    
    wsyjAhqcStr = _wsyjDetail.ahqc;
    wsyjIdStr = _wsyjDetail.ID;
    wsyjjymdStr = _wsyjDetail.jymd;
    wsyjajbsStr = _wsyjDetail.ajbs;
    wsyjjynrStr = _wsyjDetail.jynr;
    wsyjjysjStr = [self covertToDateStringFromString:_wsyjDetail.jyrq];
    self.contentLabel.text = _wsyjDetail.jynr;
    
    
    
    if ([_wsyjDetail.zt isEqualToString:@"1"]) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(selectZanCun:) image:@"iv_pop_out" highImage:@"iv_pop_out" title:nil];
    } else if ([_wsyjDetail.zt isEqualToString:@"3"]) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(selectTG:) image:@"iv_pop_out" highImage:@"iv_pop_out" title:nil];
    } else if ([_wsyjDetail.zt isEqualToString:@"4"]) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(selectWTG:) image:@"iv_pop_out" highImage:@"iv_pop_out" title:nil];
    }

    
    
    [self.view setNeedsLayout];
    // Do any additional setup after loading the view from its nib.
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
    LSChangeAppointViewController *changeVC = [[LSChangeAppointViewController alloc]init];
    [self.navigationController pushViewController:changeVC animated:YES];
    [self.menu dismiss];
}
- (void)deleteDidClick
{
    NSLog(@"删除");
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"id"] = _wsyjDetail.ID;
    [LSHttpTool get:WSYJDelUrl params:param success:^(id json) {
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
