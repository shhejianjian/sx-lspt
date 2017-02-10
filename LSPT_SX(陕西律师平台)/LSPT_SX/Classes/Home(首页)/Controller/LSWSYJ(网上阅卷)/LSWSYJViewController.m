//
//  LSWSYJViewController.m
//  LSPT_SX
//
//  Created by 何键键 on 16/2/24.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSWSYJViewController.h"
#import "LSWSYJTableViewCell.h"
#import "LSYjDetailViewController.h"
#import "LSWSYJModel.h"
#import "LSyjCreateViewController.h"
#import "LSPT.h"

static NSString *ID=@"wsyjCell";
@interface LSWSYJViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *wsyjTableView;
@property (nonatomic, strong) NSMutableArray *wsyjArr;
@property (nonatomic, assign) int currentPage;
@property (weak, nonatomic) IBOutlet UIView *noDetailView;

@end

@implementation LSWSYJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"借阅列表";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(createView) image:@"btn_login" highImage:@"btn_press_login" title:@"新增"];
    [self.wsyjTableView registerNib:[UINib nibWithNibName:@"LSWSYJTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
    self.wsyjTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreWSYJ)];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    self.noDetailView.hidden = YES;
    self.wsyjTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewWSYJ)];
    [self.wsyjTableView.mj_header beginRefreshing];
}
- (void)loadNewWSYJ
{
    self.currentPage = 1;
    [self.wsyjTableView.mj_footer endRefreshing];
    [self LoadWSYJ];
}
- (void)loadMoreWSYJ
{
    self.currentPage ++;
    [self LoadWSYJ];
}
- (void)createView {
    LSyjCreateViewController *yjnewVC = [[LSyjCreateViewController alloc]init];
    [self.navigationController pushViewController:yjnewVC animated:YES];
}

- (void)LoadWSYJ {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *lsid = [[NSUserDefaults standardUserDefaults]objectForKey:@"lsid"];
    params[@"lsid"] = lsid;
    params[@"currentPage"] = @(self.currentPage);
    params[@"pageSize"] = @"5";
    [LSHttpTool get:WSYJUrl params:params success:^(id json) {
        self.wsyjArr = [LSWSYJModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"result"]];
        if (self.wsyjArr.count < 5) {
            [self.wsyjTableView.mj_footer endRefreshingWithNoMoreData];
        }
        LSBaseModel *baseModel=[LSBaseModel mj_objectWithKeyValues:json];
        if ([baseModel.status isEqualToString:@"fail"]) {
            self.noDetailView.hidden = NO;
            self.noDetailView.layer.cornerRadius = 5.0f;
            self.noDetailView.layer.borderWidth = 1.0f;
            self.noDetailView.layer.borderColor = LSGrayColor.CGColor;
        }
        [self.wsyjTableView reloadData];
        NSLog(@"===%@",json);
    } failure:^(NSError *error) {
        NSLog(@"---%@",error);
        [MBProgressHUD showError:@"网络连接错误"];
    }];
    [self.wsyjTableView.mj_footer endRefreshing];

    [self.wsyjTableView.mj_header endRefreshing];
}



- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.wsyjArr.count;
}


- (LSWSYJTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSWSYJTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[LSWSYJTableViewCell alloc]init];
    }
    cell.WSYJ = self.wsyjArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LSYjDetailViewController *yjDetailVC = [[LSYjDetailViewController alloc]init];
    yjDetailVC.wsyjDetail = self.wsyjArr[indexPath.row];
    [self.navigationController pushViewController:yjDetailVC animated:YES];
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

- (NSMutableArray *)wsyjArr {
	if(_wsyjArr == nil) {
		_wsyjArr = [[NSMutableArray alloc] init];
	}
	return _wsyjArr;
}

@end
