//
//  LSYJJYViewController.m
//  LSPT_SX
//
//  Created by 何键键 on 16/3/2.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSYJJYViewController.h"
#import "LSPT.h"
#import "LSYJJYTableViewCell.h"
#import "LSYJJYModel.h"
#import "LSYjjyDetailViewController.h"
#import "LSTJYJViewController.h"
static NSString *ID=@"yjjyCell";
@interface LSYJJYViewController ()
@property (weak, nonatomic) IBOutlet UITableView *yjjyTableView;
@property (nonatomic, strong) NSMutableArray *yjjyArr;
@property (nonatomic, assign) int currentPage;
@property (weak, nonatomic) IBOutlet UIView *noDetailView;

@end

@implementation LSYJJYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"意见建议";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(createView) image:@"btn_login" highImage:@"btn_press_login" title:@"新增"];
    [self.yjjyTableView registerNib:[UINib nibWithNibName:@"LSYJJYTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
   self.yjjyTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreYJJY)];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    self.noDetailView.hidden = YES;
    self.yjjyTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewYJJY)];
    [self.yjjyTableView.mj_header beginRefreshing];
}
- (void)loadNewYJJY
{
    self.currentPage = 1;
    [self loadYJJY];
}
- (void)loadMoreYJJY
{
    self.currentPage ++;
    [self loadYJJY];
}
- (void) loadYJJY {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *lsid = [[NSUserDefaults standardUserDefaults]objectForKey:@"lsid"];
    params[@"lsid"] = lsid;
    params[@"currentPage"] = @(self.currentPage);
    params[@"pageSize"] = @"5";
    [LSHttpTool get:byjyQueryUrl params:params success:^(id json) {
        self.yjjyArr = [LSYJJYModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"result"]];
        if (self.yjjyArr.count < 5) {
            [self.yjjyTableView.mj_footer endRefreshingWithNoMoreData];
        }
        LSBaseModel *baseModel=[LSBaseModel mj_objectWithKeyValues:json];
        if ([baseModel.status isEqualToString:@"fail"]) {
            self.noDetailView.hidden = NO;
            self.noDetailView.layer.cornerRadius = 5.0f;
            self.noDetailView.layer.borderWidth = 1.0f;
            self.noDetailView.layer.borderColor = LSGrayColor.CGColor;
        }
        [self.yjjyTableView reloadData];
        NSLog(@"%@==",json);
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络连接错误"];
    }];
    [self.yjjyTableView.mj_footer endRefreshing];
    [self.yjjyTableView.mj_header endRefreshing];
}

- (void)createView {
    LSTJYJViewController *tjyjVC = [[LSTJYJViewController alloc]init];
    [self.navigationController pushViewController:tjyjVC animated:YES];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.yjjyArr.count;
}


- (LSYJJYTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSYJJYTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[LSYJJYTableViewCell alloc]init];
    }
    cell.YJJY = self.yjjyArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LSYjjyDetailViewController *yjjyDetailVC = [[LSYjjyDetailViewController alloc]init];
    yjjyDetailVC.YjjyDetail = self.yjjyArr[indexPath.row];
    [self.navigationController pushViewController:yjjyDetailVC animated:YES];
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

- (NSMutableArray *)yjjyArr {
	if(_yjjyArr == nil) {
		_yjjyArr = [[NSMutableArray alloc] init];
	}
	return _yjjyArr;
}

@end
