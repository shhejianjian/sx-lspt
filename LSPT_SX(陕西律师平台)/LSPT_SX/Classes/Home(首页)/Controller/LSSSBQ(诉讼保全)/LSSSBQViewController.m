//
//  LSSSBQViewController.m
//  LSPT_SX
//
//  Created by 何键键 on 16/2/25.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSSSBQViewController.h"
#import "LSSSBQTableViewCell.h"
#import "LSBqDetailViewController.h"
#import "LSBqApplyViewController.h"
#import "LSPT.h"
#import "LSSSBQModel.h"
static NSString *ID=@"ssbqCell";
@interface LSSSBQViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *ssbqTableView;
@property (nonatomic, strong) NSMutableArray *ssbqArr;
@property (nonatomic, assign) int currentPage;
@property (weak, nonatomic) IBOutlet UIView *noDetailView;

@end

@implementation LSSSBQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"诉讼保全";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(applyView) image:@"btn_login" highImage:@"btn_press_login" title:@"申请"];
    
    [self.ssbqTableView registerNib:[UINib nibWithNibName:@"LSSSBQTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
    self.ssbqTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreSSBQ)];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    self.noDetailView.hidden = YES;
    self.ssbqTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewSSBQ)];
    [self.ssbqTableView.mj_header beginRefreshing];
}
- (void)loadNewSSBQ
{
    self.currentPage = 1;
    [self.ssbqTableView.mj_footer endRefreshing];
    [self LoadSSBQ];
}
- (void)loadMoreSSBQ
{
    self.currentPage ++;
    [self LoadSSBQ];
}
- (void)LoadSSBQ {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *lsid = [[NSUserDefaults standardUserDefaults]objectForKey:@"lsid"];
    params[@"lsid"] = lsid;
    params[@"currentPage"] = @(self.currentPage);
    params[@"pageSize"] = @"5";
    [LSHttpTool get:SSBQUrl params:params success:^(id json) {
        self.ssbqArr = [LSSSBQModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"result"]];
        if (self.ssbqArr.count < 5) {
            [self.ssbqTableView.mj_footer endRefreshingWithNoMoreData];
        }
        LSBaseModel *baseModel=[LSBaseModel mj_objectWithKeyValues:json];
        if ([baseModel.status isEqualToString:@"fail"]) {
            self.noDetailView.hidden = NO;
            self.noDetailView.layer.cornerRadius = 5.0f;
            self.noDetailView.layer.borderWidth = 1.0f;
            self.noDetailView.layer.borderColor = LSGrayColor.CGColor;
        }
        [self.ssbqTableView reloadData];
        NSLog(@"===%@",json);
    } failure:^(NSError *error) {
        NSLog(@"---%@",error);
        [MBProgressHUD showError:@"网络连接错误"];
    }];
    [self.ssbqTableView.mj_footer endRefreshing];
    [self.ssbqTableView.mj_header endRefreshing];
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)applyView {
    LSBqApplyViewController *bqApplyVC = [[LSBqApplyViewController alloc]init];
    [self.navigationController pushViewController:bqApplyVC animated:YES];
    
}
#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.ssbqArr.count;
}


- (LSSSBQTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSSSBQTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[LSSSBQTableViewCell alloc]init];
    }
    cell.SSBQ = self.ssbqArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LSBqDetailViewController *bqDetailVC = [[LSBqDetailViewController alloc]init];
    bqDetailVC.ssbqDetail = self.ssbqArr[indexPath.row];
    [self.navigationController pushViewController:bqDetailVC animated:YES];
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

- (NSMutableArray *)ssbqArr {
	if(_ssbqArr == nil) {
		_ssbqArr = [[NSMutableArray alloc] init];
	}
	return _ssbqArr;
}

@end
