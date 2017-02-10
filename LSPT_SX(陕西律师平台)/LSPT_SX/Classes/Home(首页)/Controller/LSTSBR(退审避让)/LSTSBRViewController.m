//
//  LSTSBRViewController.m
//  LSPT_SX
//
//  Created by 何键键 on 16/2/24.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSTSBRViewController.h"
#import "LSTSBRTableViewCell.h"
#import "LSApplyViewController.h"
#import "LSBrDetailViewController.h"
#import "LSPT.h"
#import "LSTSBRModel.h"

static NSString *ID=@"tsbrCell";
@interface LSTSBRViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tsbrTableView;
@property (nonatomic, strong) NSMutableArray *tsbrArr;
@property (nonatomic, assign) int currentPage;
@property (weak, nonatomic) IBOutlet UIView *noDetailView;

@end

@implementation LSTSBRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"避让列表";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(applyView) image:@"btn_login" highImage:@"btn_press_login" title:@"申请"];
    [self.tsbrTableView registerNib:[UINib nibWithNibName:@"LSTSBRTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
    self.tsbrTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTSBR)];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    self.noDetailView.hidden = YES;
    self.tsbrTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTSBR)];
    [self.tsbrTableView.mj_header beginRefreshing];
}
- (void)loadNewTSBR
{
    self.currentPage = 1;
    [self.tsbrTableView.mj_footer endRefreshing];
    [self loadTSBR];
}
- (void)loadMoreTSBR
{
    self.currentPage ++;
    [self loadTSBR];
}

- (void)loadTSBR {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *lsid = [[NSUserDefaults standardUserDefaults]objectForKey:@"lsid"];
    params[@"lsid"] = lsid;
    params[@"currentPage"] = @(self.currentPage);
    params[@"pageSize"] = @"5";
    [LSHttpTool get:TSBRUrl params:params success:^(id json) {
        self.tsbrArr = [LSTSBRModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"result"]];
        if (self.tsbrArr.count < 5) {
            [self.tsbrTableView.mj_footer endRefreshingWithNoMoreData];
        }
        LSBaseModel *baseModel=[LSBaseModel mj_objectWithKeyValues:json];
        if ([baseModel.status isEqualToString:@"fail"]) {
            self.noDetailView.hidden = NO;
            self.noDetailView.layer.cornerRadius = 5.0f;
            self.noDetailView.layer.borderWidth = 1.0f;
            self.noDetailView.layer.borderColor = LSGrayColor.CGColor;
        }
        [self.tsbrTableView reloadData];
        NSLog(@"===%@",json);
    } failure:^(NSError *error) {
        NSLog(@"---%@",error);
        [MBProgressHUD showError:@"网络连接错误"];
    }];
    [self.tsbrTableView.mj_footer endRefreshing];
    [self.tsbrTableView.mj_header endRefreshing];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)applyView {
    LSApplyViewController *applyVC = [[LSApplyViewController alloc]init];
    [self.navigationController pushViewController:applyVC animated:YES];
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tsbrArr.count;
}


- (LSTSBRTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSTSBRTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[LSTSBRTableViewCell alloc]init];
    }
    cell.TSBR = self.tsbrArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LSBrDetailViewController *brDetailVC = [[LSBrDetailViewController alloc]init];
    brDetailVC.tsbrDetail = self.tsbrArr[indexPath.row];

    [self.navigationController pushViewController:brDetailVC animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSMutableArray *)tsbrArr {
	if(_tsbrArr == nil) {
		_tsbrArr = [[NSMutableArray alloc] init];
	}
	return _tsbrArr;
}

@end
