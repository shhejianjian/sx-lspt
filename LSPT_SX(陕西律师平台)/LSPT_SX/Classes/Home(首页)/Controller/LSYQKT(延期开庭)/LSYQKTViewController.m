//
//  LSYQKTViewController.m
//  LSPT_SX
//
//  Created by 何键键 on 16/2/25.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSYQKTViewController.h"
#import "LSYQKTTableViewCell.h"
#import "LSYqDetaiViewController.h"
#import "LSYqApplyViewController.h"
#import "LSPT.h"

#import "LSYQKTModel.h"
static NSString *ID=@"yqktCell";
@interface LSYQKTViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *yqktTableView;
@property (nonatomic ,strong) NSMutableArray *yqktArr;
@property (nonatomic, assign) int currentPage;
@property (weak, nonatomic) IBOutlet UIView *noDetailView;

@end

@implementation LSYQKTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"延期开庭";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(createView) image:@"btn_login" highImage:@"btn_press_login" title:@"新增"];
    [self.yqktTableView registerNib:[UINib nibWithNibName:@"LSYQKTTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
    self.yqktTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreYQKT)];
    // Do any additional setup after loading the view from its nib.
}

- (void)loadNewYQKT
{
    self.currentPage = 1;
    [self.yqktTableView.mj_footer endRefreshing];
    [self LoadYQKT];
}
- (void)loadMoreYQKT
{
    self.currentPage ++;
    [self LoadYQKT];
}

- (void)viewWillAppear:(BOOL)animated {
    self.noDetailView.hidden = YES;
    self.yqktTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewYQKT)];
    [self.yqktTableView.mj_header beginRefreshing];
}

- (void)LoadYQKT {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *lsid = [[NSUserDefaults standardUserDefaults]objectForKey:@"lsid"];
    params[@"lsid"] = lsid;
    params[@"currentPage"] = @(self.currentPage);
    params[@"pageSize"] = @"5";
    [LSHttpTool get:YQKTUrl params:params success:^(id json) {
        self.yqktArr = [LSYQKTModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"result"]];
        if (self.yqktArr.count < 5) {
            [self.yqktTableView.mj_footer endRefreshingWithNoMoreData];
        }
        LSBaseModel *baseModel=[LSBaseModel mj_objectWithKeyValues:json];
        if ([baseModel.status isEqualToString:@"fail"]) {
            self.noDetailView.hidden = NO;
            self.noDetailView.layer.cornerRadius = 5.0f;
            self.noDetailView.layer.borderWidth = 1.0f;
            self.noDetailView.layer.borderColor = LSGrayColor.CGColor;
        }
        [self.yqktTableView reloadData];
        NSLog(@"===%@",json);
    } failure:^(NSError *error) {
        NSLog(@"---%@",error);
        [MBProgressHUD showError:@"网络连接错误"];
    }];
    [self.yqktTableView.mj_footer endRefreshing];

    [self.yqktTableView.mj_header endRefreshing];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createView {
    LSYqApplyViewController *yqApplyVC = [[LSYqApplyViewController alloc]init];
    [self.navigationController pushViewController:yqApplyVC animated:YES];
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.yqktArr.count;
}

- (LSYQKTTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSYQKTTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[LSYQKTTableViewCell alloc]init];
    }
    cell.YQKT = self.yqktArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LSYqDetaiViewController *yqDetailVC = [[LSYqDetaiViewController alloc]init];
    yqDetailVC.yqktDetail = self.yqktArr[indexPath.row];
    [self.navigationController pushViewController:yqDetailVC animated:YES];
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

- (NSMutableArray *)yqktArr {
	if(_yqktArr == nil) {
		_yqktArr = [[NSMutableArray alloc] init];
	}
	return _yqktArr;
}

@end
