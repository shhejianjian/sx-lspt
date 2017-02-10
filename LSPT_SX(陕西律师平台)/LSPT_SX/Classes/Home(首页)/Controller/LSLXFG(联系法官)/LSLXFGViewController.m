//
//  LSLXFGViewController.m
//  LSPT_SX
//
//  Created by 何键键 on 16/2/24.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSLXFGViewController.h"
#import "LSLXFGTableViewCell.h"
#import "LSFgApplyViewController.h"
#import "LSFgDetailViewController.h"
#import "LSLXFGModel.h"
#import "LSPT.h"

static NSString *ID=@"lxfgCell";

@interface LSLXFGViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *lxfgTableView;

@property (nonatomic, strong) NSMutableArray *lxfgArr;
@property (nonatomic, assign) int currentPage;
@property (weak, nonatomic) IBOutlet UIView *noDetailView;

@end

@implementation LSLXFGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"联系法官";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(applyFgView) image:@"btn_login" highImage:@"btn_press_login" title:@"申请"];
    [self.lxfgTableView registerNib:[UINib nibWithNibName:@"LSLXFGTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
    self.lxfgTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreLXFG)];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    self.noDetailView.hidden = YES;
    self.lxfgTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewLXFG)];
    [self.lxfgTableView.mj_header beginRefreshing];
}
- (void)loadNewLXFG
{
    self.currentPage = 1;
    [self.lxfgTableView.mj_footer endRefreshing];
    [self LoadLXFG];
}
- (void)loadMoreLXFG
{
    self.currentPage ++;
    [self LoadLXFG];
}
- (void)LoadLXFG {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *lszh = [[NSUserDefaults standardUserDefaults]objectForKey:@"lszh"];
    NSString *sfzjhm = [[NSUserDefaults standardUserDefaults]objectForKey:@"sfzjhm"];

    params[@"lszh"] = lszh;
    params[@"sfzjhm"] = sfzjhm;
    params[@"currentPage"] = @(self.currentPage);
    params[@"pageSize"] = @"5";
    [LSHttpTool get:LXFGUrl params:params success:^(id json) {
        self.lxfgArr = [LSLXFGModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
        if (self.lxfgArr.count < 5) {
            [self.lxfgTableView.mj_footer endRefreshingWithNoMoreData];
        }
        LSBaseModel *baseModel=[LSBaseModel mj_objectWithKeyValues:json];
        if ([baseModel.status isEqualToString:@"fail"]) {
            self.noDetailView.hidden = NO;
            self.noDetailView.layer.cornerRadius = 5.0f;
            self.noDetailView.layer.borderWidth = 1.0f;
            self.noDetailView.layer.borderColor = LSGrayColor.CGColor;
        }

        [self.lxfgTableView reloadData];
        NSLog(@"===%@---%@",json,self.lxfgArr);
    } failure:^(NSError *error) {
        NSLog(@"---%@",error);
        [MBProgressHUD showError:@"网络连接错误"];
    }];
    [self.lxfgTableView.mj_footer endRefreshing];
    [self.lxfgTableView.mj_header endRefreshing];
}


- (void)applyFgView{
    LSFgApplyViewController *fgApplyVC = [[LSFgApplyViewController alloc]init];
    [self.navigationController pushViewController:fgApplyVC animated:YES];
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lxfgArr.count;
}


- (LSLXFGTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSLXFGTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[LSLXFGTableViewCell alloc]init];
    }
    cell.LXFG = self.lxfgArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LSFgDetailViewController *fgDetailVC = [[LSFgDetailViewController alloc]init];
    fgDetailVC.lxfgDetail = self.lxfgArr[indexPath.row];
    
    [self.navigationController pushViewController:fgDetailVC animated:YES];
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

- (NSMutableArray *)lxfgArr {
	if(_lxfgArr == nil) {
		_lxfgArr = [[NSMutableArray alloc] init];
	}
	return _lxfgArr;
}

@end
