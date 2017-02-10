//
//  LSYjjyDetailViewController.m
//  LSPT_SX
//
//  Created by 何键键 on 16/3/2.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSYjjyDetailViewController.h"
#import "LSYJJYModel.h"
#import "LSyjtjTableViewController.h"
#import "LSDropdownMenu.h"
#import "UIView+Extension.h"

#import "LSPT.h"
@interface LSYjjyDetailViewController ()<LSDropdownMenuDelegate>
@property (weak, nonatomic) IBOutlet UILabel *btLabel;
@property (weak, nonatomic) IBOutlet UILabel *cjrqLabel;
@property (weak, nonatomic) IBOutlet UILabel *ztLabel;
@property (weak, nonatomic) IBOutlet UILabel *nrLabel;
@property (nonatomic, strong) LSDropdownMenu *menu;

@property (weak, nonatomic) IBOutlet UIView *detailView;
@end

@implementation LSYjjyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"意见详情";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
    self.detailView.layer.cornerRadius = 5;
    self.detailView.layer.borderColor = LSGrayColor.CGColor;
    self.detailView.layer.borderWidth = 1;
    
    self.btLabel.text = _YjjyDetail.bt;
    self.cjrqLabel.text = _YjjyDetail.creattime;
    if ([_YjjyDetail.zt isEqualToString:@"1"]) {
        self.ztLabel.text = @"暂存";
         self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(selectZanCun:) image:@"iv_pop_out" highImage:@"iv_pop_out" title:nil];
    } else {
        self.ztLabel.text = @"已提交";
    }
    self.nrLabel.text = _YjjyDetail.nr;
    [self.view setNeedsDisplay];
    // Do any additional setup after loading the view from its nib.
}

- (void) back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    //监听评价点击
    [LSNotificationCenter addObserver:self selector:@selector(pingJiaDidClick) name:LSPJModifyDidClickNotification object:nil];
   
    
}
#pragma mark - 监听通知

- (void)pingJiaDidClick {
    NSLog(@"提交");
//    LSPJViewController *pjVC = [[LSPJViewController alloc]init];
//    [self.navigationController pushViewController:pjVC animated:YES];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"id"] = _YjjyDetail.ID;
    [LSHttpTool get:byjyTJUrl params:param success:^(id json) {
        NSLog(@"%@",json);
        LSBaseModel *baseModel=[LSBaseModel mj_objectWithKeyValues:json];
        if ([baseModel.status isEqualToString:@"success"]) {
            [MBProgressHUD showSuccess:@"文件提交成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showError:@"文件提交失败"];
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
    LSyjtjTableViewController *vc = [[LSyjtjTableViewController alloc] init];
    vc.view.height = 44;
    vc.view.width = 115;
    self.menu.contentController = vc;
    // 3.显示
    [self.menu showFrom:view];
    
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
