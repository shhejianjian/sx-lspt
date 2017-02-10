//
//  LSDCLViewController.m
//  LSPT_SX
//
//  Created by 何键键 on 16/2/25.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSDCLViewController.h"
#import "LSDCLTableViewCell.h"
#import "LSDcDetailViewController.h"
#import "LSDcApplyViewController.h"
#import "LSPT.h"
#import "LSDCLModel.h"
#import "NSString+LoveData.h"
static NSString *ID=@"dclCell";

@interface LSDCLViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dclArr;
@property (nonatomic, assign) int currentPage;
@property (weak, nonatomic) IBOutlet UIView *noDetailView;

//@property (nonatomic, assign) int pageSize;
@end

@implementation LSDCLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"调查令";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(createView) image:@"btn_login" highImage:@"btn_press_login" title:@"新增"];
    
    [self.dclTableView registerNib:[UINib nibWithNibName:@"LSDCLTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
    NSLog(@"123");
    self.dclTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDCL)];
    // Do any additional setup after loading the view from its nib.
}
- (void)loadNewDCL
{
    self.currentPage = 1;
    [self.dclTableView.mj_footer endRefreshing];
    [self LoadDCL];
}
- (void)loadMoreDCL
{
    self.currentPage ++;
    [self LoadDCL];
}

- (void)viewWillAppear:(BOOL)animated {
    self.noDetailView.hidden = YES;
    self.dclTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDCL)];
    
    [self.dclTableView.mj_header beginRefreshing];
}

- (void)LoadDCL {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *lsid = [[NSUserDefaults standardUserDefaults]objectForKey:@"lsid"];
    params[@"lsid"] = lsid;
    params[@"currentPage"] = @(self.currentPage);
    params[@"pageSize"] = @"5";
    [LSHttpTool get:DCLUrl params:params success:^(id json) {
        self.dclArr = [LSDCLModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"result"]];
        NSLog(@"%@+++%d",json,self.dclArr.count);
        if (self.dclArr.count < 5) {
            [self.dclTableView.mj_footer endRefreshingWithNoMoreData];
        }
        LSBaseModel *baseModel=[LSBaseModel mj_objectWithKeyValues:json];
        if ([baseModel.status isEqualToString:@"fail"]) {
            self.noDetailView.hidden = NO;
            self.noDetailView.layer.cornerRadius = 5.0f;
            self.noDetailView.layer.borderWidth = 1.0f;
            self.noDetailView.layer.borderColor = LSGrayColor.CGColor;
        }
        [self.dclTableView reloadData];

    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络连接错误"];
    }];
    [self.dclTableView.mj_footer endRefreshing];
    [self.dclTableView.mj_header endRefreshing];
}


- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createView {
    LSDcApplyViewController *dcCreateView = [[LSDcApplyViewController alloc]init];
    [self.navigationController pushViewController:dcCreateView animated:YES];
    
}
#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (self.totalCount == self.dclArr.count) {
//        [self.dclTableView.mj_footer endRefreshingWithNoMoreData];
//    }
    return self.dclArr.count;
}


- (LSDCLTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSDCLTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[LSDCLTableViewCell alloc]init];
    }
    cell.DCL = self.dclArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LSDcDetailViewController *dcDetailVC = [[LSDcDetailViewController alloc]init];
    dcDetailVC.dclDetail = self.dclArr[indexPath.row];
    [self.navigationController pushViewController:dcDetailVC animated:YES];
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
