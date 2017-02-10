//
//  LSWSLADetailViewController.m
//  LSPT_SX
//
//  Created by 谢琰 on 16/2/24.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSWSLADetailViewController.h"
#import "LSDropdownMenu.h"
#import "LSMenuViewController.h"
#import "LSWslaSixTableViewController.h"
#import "LSWslaThreeTableViewController.h"
#import "UIView+Extension.h"
#import "LSWSLADetailCell.h"
#import "LSWSLAFirstViewController.h"
#import "LSLitigantListViewControlle.h"
#import "LSMaterialListViewController.h"
#import "LSWSLA.h"
#import "LSPT.h"
#import "LSWSLAMainViewController.h"
#import "LSSsdwInfo.h"
#import "LSPJViewController.h"
#import "LSCLType.h"
@interface LSWSLADetailViewController ()<LSDropdownMenuDelegate,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (nonatomic, strong) LSDropdownMenu *menu;
@end

NSString *wslaIDStr;
@implementation LSWSLADetailViewController
extern LSWSLA *mWsla;
extern NSInteger menuCount;

static NSString *ID = @"LSWSLADetailCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"案件详情";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
    if ([_wsla.zt isEqualToString:@"1"]) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(select:) image:@"iv_pop_out" highImage:@"iv_pop_out" title:nil];
    } else if ([_wsla.zt isEqualToString:@"4"]) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(selectSix:) image:@"iv_pop_out" highImage:@"iv_pop_out" title:nil];
    } else if ([_wsla.zt isEqualToString:@"3"]) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(selectThree:) image:@"iv_pop_out" highImage:@"iv_pop_out" title:nil];
    }
    
    
    wslaIDStr = _wsla.ajbs;
    NSLog(@"%@==---%@",wslaIDStr,_wsla.ID);
    [self.detailTableView registerNib:[UINib nibWithNibName:@"LSWSLADetailCell" bundle:nil] forCellReuseIdentifier:ID];
    self.detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}


- (void)viewWillAppear:(BOOL)animated
{
    // 监听修改点击
    [LSNotificationCenter addObserver:self selector:@selector(modifyDidClick) name:LSModifyDidClickNotification object:nil];
    // 监听删除点击
    [LSNotificationCenter addObserver:self selector:@selector(deleteDidClick) name:LSDeleteDidClickNotification object:nil];
    // 监听当事人点击
    [LSNotificationCenter addObserver:self selector:@selector(litigantDidClick) name:LSLitigantDidClickNotification object:nil];
    // 监听诉讼材料点击
    [LSNotificationCenter addObserver:self selector:@selector(materialDidClick) name:LSMaterialDidClickNotification object:nil];
    // 监听提交点击
    [LSNotificationCenter addObserver:self selector:@selector(submitDidClick) name:LSSubmitDidClickNotification object:nil];
    // 监听评价点击
    [LSNotificationCenter addObserver:self selector:@selector(accessDidClick) name:LSAssessDidClickNotification object:nil];
}

#pragma mark - 监听通知

- (void)modifyDidClick
{
    NSLog(@"modifyDidClick");
    LSWSLAFirstViewController *firstVC = [[LSWSLAFirstViewController alloc]init];
    firstVC.ajfldmStr = self.wsla.ajfldm;
    firstVC.fymcStr = [NSString stringWithFormat:@"%@(%@)",self.wsla.fymc,self.wsla.fydm];
    if ([self.wsla.ajxzdm isEqualToString:@"2"]) {
        firstVC.ajlbStr = @"民事";
    }else if([self.wsla.ajxzdm isEqualToString:@"6"]){
        firstVC.ajlbStr = @"行政";
    }else if([self.wsla.ajxzdm isEqualToString:@"8"]){
        firstVC.ajlbStr = @"执行";
    }
    if ([self.wsla.ajxzdm isEqualToString:@"2"] || [self.wsla.ajxzdm isEqualToString:@"6"]) {
        firstVC.spcxStr = @"一审";
    }
    else if([self.wsla.ajxzdm isEqualToString:@"8"]){
        firstVC.spcxStr = @"执行";
    }
    firstVC.fydmStr = self.wsla.fydm;
    firstVC.lxbmStr = self.wsla.lxbm;
    [self.navigationController pushViewController:firstVC animated:YES];
    
    [self.menu dismiss];
}
- (void)deleteDidClick
{
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"您确定要删除吗？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self deleteWsla];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    [self.menu dismiss];
}
- (void)deleteWsla
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"ajbs"] = mWsla.ajbs;
    NSLog(@"删除-%@",params);
    [LSHttpTool get:WSLADelUrl params:params success:^(id json) {
        NSLog(@"删除 %@--%@",params,json);
        LSBaseModel *baseModel=[LSBaseModel mj_objectWithKeyValues:json];
        if ([baseModel.status isEqualToString:@"success"]) {
            [MBProgressHUD showSuccess:@"删除成功"];
            [self jumpToVC];
        } else {
            [MBProgressHUD showError:@"删除失败"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不稳定,请稍后再试"];
    }];
    NSLog(@"deleteDidClick");
}
- (void)jumpToVC {
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[LSWSLAMainViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}
- (void)litigantDidClick
{
    LSLitigantListViewControlle *litigantVC = [[LSLitigantListViewControlle alloc]init];
    [self.navigationController pushViewController:litigantVC animated:YES];
     [self.menu dismiss];
}
- (void)materialDidClick
{
    LSMaterialListViewController *materialVC = [[LSMaterialListViewController alloc]init];
    [self.navigationController pushViewController:materialVC animated:YES];
    NSLog(@"materialDidClick");
    [self.menu dismiss];
}
- (void)submitDidClick
{
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"您确定要提交吗？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self submitWsla];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    [self.menu dismiss];
}
- (void)accessDidClick
{
    LSPJViewController *pjVC = [[LSPJViewController alloc]init];
    [self.menu dismiss];
    [self.navigationController pushViewController:pjVC animated:YES];
    
}
- (void)submitWsla
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"ajbs"] = mWsla.ajbs;
    [LSHttpTool get:WSLASubUrl params:params success:^(id json) {
        NSLog(@"sub%@--%@",params,json);
        LSBaseModel *baseModel=[LSBaseModel mj_objectWithKeyValues:json];
        if ([baseModel.status isEqualToString:@"success"]) {
            [MBProgressHUD showSuccess:@"提交成功"];
            [self jumpToVC];
        } else {
            [LSHttpTool get:GetClmcInfoUrl params:nil success:^(id json) {
                NSArray *arr = [LSCLType mj_objectArrayWithKeyValuesArray:json[@"data"][@"result"]];
                for (LSCLType *sscl in arr) {
                    if ([sscl.bt isEqualToString:@"1"]) {
                        [MBProgressHUD showError:[NSString stringWithFormat:@"提交失败,%@未上传",sscl.dmms]];
                    }
                }
                NSLog(@"%@=",json);
            } failure:^(NSError *error) {
                
            }];
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不稳定,请稍后再试"];
    }];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [LSNotificationCenter removeObserver:self];
}
- (void)select:(UIView *)view
{
    // 1.创建下拉菜单
    self.menu = [LSDropdownMenu menu];
    self.menu.delegate = self;
    
    // 2.设置内容
    LSMenuViewController *vc = [[LSMenuViewController alloc] init];
    vc.view.height = 5 * 44;
    vc.view.width = 115;
    self.menu.contentController = vc;
    
    // 3.显示
    [self.menu showFrom:view];
}
- (void)selectSix:(UIView *)view
{
    // 1.创建下拉菜单
    self.menu = [LSDropdownMenu menu];
    self.menu.delegate = self;
    
    // 2.设置内容
    LSWslaSixTableViewController *vc = [[LSWslaSixTableViewController alloc] init];
    vc.view.height = 6 * 44;
    vc.view.width = 115;
    self.menu.contentController = vc;
    
    // 3.显示
    [self.menu showFrom:view];
}
- (void)selectThree:(UIView *)view
{
    // 1.创建下拉菜单
    self.menu = [LSDropdownMenu menu];
    self.menu.delegate = self;
    
    // 2.设置内容
    LSWslaThreeTableViewController *vc = [[LSWslaThreeTableViewController alloc] init];
    vc.view.height = 3 * 44;
    vc.view.width = 115;
    self.menu.contentController = vc;
    
    // 3.显示
    [self.menu showFrom:view];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 16;
}

#pragma mark - Table view  delegate

- (LSWSLADetailCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSWSLADetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[LSWSLADetailCell alloc]init];
    }
    cell.categoryLabel.backgroundColor = LSBlueColor;
    cell.categoryLabel.font = [UIFont systemFontOfSize:15];
    cell.categoryDetailLabel.font = [UIFont systemFontOfSize:15];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    if (indexPath.row == 0) {
        
        cell.categoryLabel.text = @"立案法院";
        cell.categoryDetailLabel.text = self.wsla.fymc;
        cell.categoryDetailLabel.layer.borderWidth = 0.0f;
    }
    else if (indexPath.row == 1) {
        cell.categoryLabel.text = @"案件类别";

        if ([self.wsla.ajxzdm isEqualToString:@"2"]) {
            cell.categoryDetailLabel.text = @"民事";
        }else if([self.wsla.ajxzdm isEqualToString:@"6"]){
            cell.categoryDetailLabel.text = @"行政";
        }else if([self.wsla.ajxzdm isEqualToString:@"8"]){
            cell.categoryDetailLabel.text = @"执行";
        }

        cell.categoryDetailLabel.layer.borderWidth = 0.0f;
        cell.categoryDetailLabel.layer.borderWidth = 0.0f;
    }
    else if (indexPath.row == 2) {
        
        cell.categoryLabel.text = @"审判程序";
        if ([self.wsla.ajxzdm isEqualToString:@"2"] || [self.wsla.ajxzdm isEqualToString:@"6"]) {
            cell.categoryDetailLabel.text = @"一审";
                }
        else if([self.wsla.ajxzdm isEqualToString:@"8"]){
            cell.categoryDetailLabel.text = @"执行";
        }
        cell.categoryDetailLabel.layer.borderWidth = 0.0f;

    }
    else if (indexPath.row == 3) {
        
        cell.categoryLabel.text = @"申请人";
        cell.categoryDetailLabel.text = self.wsla.sqr;
        cell.categoryDetailLabel.layer.borderWidth = 0.0f;

    }
    else if (indexPath.row == 4) {
        
        cell.categoryLabel.text = @"联系电话";
        cell.categoryDetailLabel.text = self.wsla.sqrdh;
        cell.categoryDetailLabel.layer.borderWidth = 0.0f;

    } else if (indexPath.row == 5) {
        
        cell.categoryLabel.text = @"手机号码";
        cell.categoryDetailLabel.text = self.wsla.sqrsj;
        cell.categoryDetailLabel.layer.borderWidth = 0.0f;

    }
    else if (indexPath.row == 6) {
        
        cell.categoryLabel.text = @"证件号码";
        cell.categoryDetailLabel.text = self.wsla.sqrzjhm;
        cell.categoryDetailLabel.layer.borderWidth = 0.0f;

    }
    else if (indexPath.row == 7) {

        cell.categoryLabel.text = @"与当事人关系";
        if ([self.wsla.ydsrgxdm isEqualToString:@"3"]) {
            cell.categoryDetailLabel.text = @"当事人律师";
        }
        cell.categoryDetailLabel.layer.borderWidth = 0.0f;

    }
    else if (indexPath.row == 8) {

        cell.categoryLabel.text = @"案由";
        cell.categoryDetailLabel.text = self.wsla.aymc;
        cell.categoryDetailLabel.layer.borderWidth = 0.0f;

    }
    else if (indexPath.row == 9) {

        cell.categoryLabel.text = @"行政赔偿方式";
        cell.categoryDetailLabel.text = self.wsla.tqxzpcfs;
        //cell.categoryDetailLabel.text = self.wsla.tqxzpcfs;
        cell.categoryDetailLabel.layer.borderWidth = 0.0f;

    }
    else if (indexPath.row == 10) {

        cell.categoryLabel.text = @"执行依据";
        cell.categoryDetailLabel.text = self.wsla.zxyj;
//        cell.categoryDetailLabel.text = self.wsla.zxyj;
        cell.categoryDetailLabel.layer.borderWidth = 0.0f;

    }
    else if (indexPath.row == 11) {

        cell.categoryLabel.text = @"依据机关";
        cell.categoryDetailLabel.text = self.wsla.yjjg;
        //cell.categoryDetailLabel.text = self.wsla.yjjg;
        cell.categoryDetailLabel.layer.borderWidth = 0.0f;

    }
    else if (indexPath.row == 12) {

        cell.categoryLabel.text = @"依据文号";
        cell.categoryDetailLabel.text = self.wsla.yjwh;
        cell.categoryDetailLabel.layer.borderWidth = 0.0f;

    }
    else if (indexPath.row == 13) {
        cell.categoryLabel.text = @"标的额(元)";
        cell.categoryDetailLabel.text = self.wsla.ajbd;
        cell.categoryDetailLabel.layer.borderWidth = 0.0f;

    }
    else if (indexPath.row == 14) {

        cell.categoryLabel.text = @"诉讼请求*";
        cell.categoryDetailLabel.text = self.wsla.ssqq;
        //cell.categoryDetailLabel.text = self.wsla.ssqq;
//        cell.categoryDetailLabel.layer.borderColor = LSGrayColor.CGColor;
//        cell.categoryDetailLabel.layer.borderWidth = 1.0f;
//        cell.categoryDetailLabel.layer.cornerRadius = 5;
    }
    else if (indexPath.row == 15) {

        cell.categoryLabel.text = @"事实理由";
        cell.categoryDetailLabel.text = self.wsla.ssly;
        //cell.categoryDetailLabel.text = self.wsla.ssly;
//        cell.categoryDetailLabel.layer.borderColor = LSGrayColor.CGColor;
//        cell.categoryDetailLabel.layer.borderWidth = 1.0f;
//        cell.categoryDetailLabel.layer.cornerRadius = 5;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 14 || indexPath.row == 15) {
        return 120.0f;
    }else{
        return 40.0f;
    }
}


@end
