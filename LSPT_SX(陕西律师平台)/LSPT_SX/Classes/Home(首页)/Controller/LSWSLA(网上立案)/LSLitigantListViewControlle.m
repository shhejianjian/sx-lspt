//
//  LSLitigantListViewControlle.m
//  LSPT_SX
//
//  Created by 谢琰 on 16/3/3.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSLitigantListViewControlle.h"
#import "LSLitigantListCell.h"
#import "LSLitigantDetailViewController.h"
#import "LSAddLitigantViewController.h"
#import "LSWSLA.h"
#import "LSPT.h"
#import "LSLitigant.h"
#import "LSSsdwInfo.h"
@interface LSLitigantListViewControlle ()
@property (nonatomic, strong) NSMutableArray *SSDWs;
@property (weak, nonatomic) IBOutlet UITableView *litigantTableView;
@property (weak, nonatomic) IBOutlet UIView *noDataView;
@property (nonatomic ,strong) NSMutableArray *litigants;
@property (nonatomic, copy) NSString *status;

@end

@implementation LSLitigantListViewControlle
static NSString *ID=@"LSLitigantListCell";
extern LSWSLA *mWsla;
- (NSMutableArray *)SSDWs
{
    if (!_SSDWs) {
        _SSDWs = [NSMutableArray array];
    }
    return _SSDWs;
}

- (NSMutableArray *)litigants
{
    if (!_litigants) {
        _litigants = [NSMutableArray array];
    }
    return _litigants;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"当事人列表";
    self.litigantTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.litigantTableView registerNib:[UINib nibWithNibName:@"LSLitigantListCell" bundle:nil] forCellReuseIdentifier:ID];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
    if ([mWsla.zt isEqualToString:@"1"]) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(add) image:@"btn_login" highImage:@"btn_press_login" title:@"添加"];
    }
    
    [self loadData];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.noDataView.hidden = YES;
    // 添加上拉刷新
    self.litigantTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadLitigant)];
    [self.litigantTableView.mj_header beginRefreshing];

}
- (void)loadData
{
    //诉讼地位
    NSMutableDictionary *ssdwParams = [NSMutableDictionary dictionary];
    ssdwParams[@"ajbs"] = mWsla.ajbs;
    [LSHttpTool get:GetSsdwInfoUrl params:ssdwParams success:^(id json) {
        self.SSDWs = [LSSsdwInfo mj_objectArrayWithKeyValuesArray:json[@"data"][@"result"]];
        
        NSLog(@"GetSsdwInfoUrl %@--%@",ssdwParams,json);
        
    } failure:^(NSError *error) {
        NSLog(@"GetSsdwInfoUrl --%@",ssdwParams);
        [MBProgressHUD showError:@"xxxx网络不稳定,请稍后再试"];
    }];
}

- (void)loadLitigant
{
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"ajbs"] = mWsla.ajbs;
    
    [LSHttpTool get:DsrUrl params:params success:^(id json) {
        NSLog(@"litigant 请求参数%@--请求结果%@",params,json);
        self.status = json[@"status"];
        self.litigants = [LSLitigant mj_objectArrayWithKeyValuesArray:json[@"data"]];
        [self.litigantTableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不稳定,请稍后再试"];
    }];
    [self.litigantTableView.mj_header endRefreshing];

}
- (void)add
{
    LSAddLitigantViewController *addVC = [[LSAddLitigantViewController alloc]init];
    [self.navigationController pushViewController:addVC animated:YES];
    
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.status isEqualToString:@"fail"]) {
        NSLog(@"numberOfRowsInSection");
        self.noDataView.hidden = NO;
        self.noDataView.layer.cornerRadius = 5.0f;
        self.noDataView.layer.borderWidth = 1.0f;
        self.noDataView.layer.borderColor = LSGrayColor.CGColor;
    }
    
    return self.litigants.count;
}
- (LSLitigantListCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSLitigantListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    if (!cell) {
        cell = [[LSLitigantListCell alloc]init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LSLitigant *litigant = self.litigants[indexPath.row];
    cell.mcLabel.text = litigant.mc;
    for (LSSsdwInfo *Ssdw in self.SSDWs) {
        if ([Ssdw.dm isEqualToString:litigant.ssdw]) {
            cell.ssdwLabel.text = Ssdw.dmms;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSLitigantDetailViewController *detailVC = [[LSLitigantDetailViewController alloc]init];
    detailVC.litigiant = self.litigants[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
    NSLog(@"didSelectRowAtIndexPath666");
}

@end
