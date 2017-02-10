//
//  LSWSLAMainViewController.m
//  LSPT_SX
//
//  Created by 何键键 on 16/3/11.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSWSLAMainViewController.h"
#import "LSWSLACell.h"
#import "LSWSLADetailViewController.h"
#import "LSPT.h"
#import "LSWSLA.h"
#import "LSAddFirstViewController.h"
@interface LSWSLAMainViewController ()
@property (weak, nonatomic) IBOutlet UITableView *wslaMainTableView;
@property (weak, nonatomic) IBOutlet UIView *noDetailView;
/** 记录当前页码 */
@property (nonatomic, assign) int  currentPage;
@property (nonatomic,strong) NSMutableArray *WSLAs;
@end

@implementation LSWSLAMainViewController
LSWSLA *mWsla;
static NSString *ID=@"LSWSLACell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.wslaMainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.wslaMainTableView registerNib:[UINib nibWithNibName:@"LSWSLACell" bundle:nil] forCellReuseIdentifier:ID];
    self.navigationItem.title = @"案件列表";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(add) image:@"btn_login" highImage:@"btn_press_login" title:@"新增"];
    self.wslaMainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreWSLA)];
    self.wslaMainTableView.mj_footer.automaticallyHidden = YES;
    // Do any additional setup after loading the view from its nib.
    
    
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    self.noDetailView.hidden = YES;
    // 添加上拉刷新
    self.wslaMainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewWSLA)];
    
    [self.wslaMainTableView.mj_header beginRefreshing];
}
- (void)loadNewWSLA
{
    self.currentPage = 1;
    [self.wslaMainTableView.mj_footer endRefreshing];
    [self loadWSLA];
}
- (void)loadMoreWSLA
{
    self.currentPage ++;
    //[self.tableView.mj_footer endRefreshing];
    [self loadWSLA];
}

- (void)loadWSLA
{
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"lawyerId"]=[[NSUserDefaults standardUserDefaults]objectForKey:@"lsid"];
    params[@"currentPage"] = @(self.currentPage);
    params[@"pageSize"] = @"5";
    [LSHttpTool get:WSLAUrl params:params success:^(id json) {
        NSLog(@"WSLA--%@",json);
        self.WSLAs = [LSWSLA mj_objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
        if (self.WSLAs.count < 5) {
            [self.wslaMainTableView.mj_footer endRefreshingWithNoMoreData];
        } else if (self.WSLAs.count == 0) {
            [self loadNewWSLA];
        }
        LSBaseModel *baseModel=[LSBaseModel mj_objectWithKeyValues:json];
        if ([baseModel.status isEqualToString:@"fail"]) {
            self.noDetailView.hidden = NO;
            self.noDetailView.layer.cornerRadius = 5.0f;
            self.noDetailView.layer.borderWidth = 1.0f;
            self.noDetailView.layer.borderColor = LSGrayColor.CGColor;
        }
        [self.wslaMainTableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不稳定,请稍后再试"];
        
    }];
    // 3.结束上拉加载
    [self.wslaMainTableView.mj_footer endRefreshing];
    [self.wslaMainTableView.mj_header endRefreshing];
    //[self.tableView.mj_footer endRefreshing];
}


\

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)add
{
    LSAddFirstViewController *firstVC = [[LSAddFirstViewController alloc]init];
    [self.navigationController pushViewController:firstVC animated:YES];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.WSLAs.count;
}

- (LSWSLACell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSWSLACell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    if (!cell) {
        cell = [[LSWSLACell alloc]init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.wsla = self.WSLAs[indexPath.row];
    return cell;
}
#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    LSWSLADetailViewController *detailVC = [[LSWSLADetailViewController alloc]init];
    mWsla = self.WSLAs[indexPath.row];
    detailVC.wsla = self.WSLAs[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
    NSLog(@"didSelectRowAtIndexPath");
}

- (NSMutableArray *)WSLAs {
	if(_WSLAs == nil) {
		_WSLAs = [[NSMutableArray alloc] init];
	}
	return _WSLAs;
}

@end
