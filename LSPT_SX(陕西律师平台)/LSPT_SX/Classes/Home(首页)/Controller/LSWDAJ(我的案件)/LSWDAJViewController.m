//
//  LSWDAJViewController.m
//  LSPT_SX
//
//  Created by 谢琰 on 16/2/24.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSWDAJViewController.h"
#import "LSWDAJTableViewCell.h"
#import "LSAjDetailViewController.h"
#import "LSPT.h"

#import "LSWDAJModel.h"
static NSString *ID=@"wdajCell";
@interface LSWDAJViewController ()
@property (weak, nonatomic) IBOutlet UITableView *wdajTableView;
@property(nonatomic,strong)NSArray *products;
@property (nonatomic, strong) NSMutableArray *wdajArr;
@property (nonatomic, assign) int currentPage;

@property (weak, nonatomic) IBOutlet UIView *noDetailView;


@end

@implementation LSWDAJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"案件列表";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
    [self.wdajTableView registerNib:[UINib nibWithNibName:@"LSWDAJTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
    [self CreateSearchBar];
    self.wdajTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreWDAJ)];
}

- (void)viewWillAppear:(BOOL)animated {
    self.noDetailView.hidden = YES;
    self.wdajTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewWDAJ)];
    [self.wdajTableView.mj_header beginRefreshing];
}
- (void)loadNewWDAJ
{
    self.currentPage = 1;
    [self.wdajTableView.mj_footer endRefreshing];
    [self loadWDAJ];
}
- (void)loadMoreWDAJ
{
    self.currentPage ++;
    [self.wdajTableView.mj_footer endRefreshing];
    [self loadWDAJ];
}
//创建搜索栏
-(void)CreateSearchBar{
    _searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 0, 40)];
    _searchBar.placeholder=@"请输入案号";
    //显示取消按钮 默认NO
    _searchBar.showsCancelButton=YES;
    _searchBar.delegate=self;
    _searchBar.searchBarStyle = UIMinimumKeepAliveTimeout;
    //将搜索栏绑定到表格视图
    [_wdajTableView setTableHeaderView:_searchBar];
}
//点击搜索按钮响应的回调方法
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"搜索按钮🔍");
    if (!_searchArray) {
        _searchArray=[[NSMutableArray alloc]init];
    }
    else{
        [_searchArray removeAllObjects];
    }
    //获取搜索栏的文本内容
    NSString *strSearch=searchBar.text;
    //查找符合条件的数据Person对象列表
    for (int i=0; i<[_wdajArr count]; i++) {
        LSWDAJModel *wdaj=[_wdajArr objectAtIndex:i];
        NSString *strName=wdaj.ahqc;
        NSRange range=[strName rangeOfString:strSearch];
        if (range.location!=NSNotFound) {
            [_searchArray addObject:wdaj];
        }
    }
    
    //数组深度拷贝 内存空间的内容 地址不一样
    //_dataArr＝_searchArray
    //_dataArr引用_searchArray的内存地址 而没有拷贝 内存地址是一样的
    _wdajArr=[_searchArray mutableCopy];
    //_dataArray只拷贝内存空间存放的数据 不引用地址 所以地址不一样
    //刷新表格视图
    //[self RelateStudent];
    [_wdajTableView reloadData];
}
//点击取消按钮响应的回调方法
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"取消按钮");
    //_wdajArr=[_tempArray mutableCopy];
    //[self RelateStudent];
    //NSLog(@"%ld",_dataArray.count);
    //[_wdajTableView reloadData];
    //软键盘消失
    [_searchBar resignFirstResponder];
    [_wdajTableView reloadData];
}

- (void)loadWDAJ {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *lszh = [[NSUserDefaults standardUserDefaults]objectForKey:@"lszh"];
    NSString *sfzjhm = [[NSUserDefaults standardUserDefaults]objectForKey:@"sfzjhm"];
    params[@"lszh"] = lszh;
    params[@"sfzjhm"] = sfzjhm;
    params[@"currentPage"] = @(self.currentPage);
    params[@"pageSize"] = @"5";
    [LSHttpTool get:WDAJUrl params:params success:^(id json) {
        self.wdajArr = [LSWDAJModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
        if (self.wdajArr.count < 5) {
            [self.wdajTableView.mj_footer endRefreshingWithNoMoreData];
        }
        LSBaseModel *baseModel=[LSBaseModel mj_objectWithKeyValues:json];
        if ([baseModel.status isEqualToString:@"fail"]) {
            self.noDetailView.hidden = NO;
            self.noDetailView.layer.cornerRadius = 5.0f;
            self.noDetailView.layer.borderWidth = 1.0f;
            self.noDetailView.layer.borderColor = LSGrayColor.CGColor;
        }
        [self.wdajTableView reloadData];
        NSLog(@"===%@",json);
    } failure:^(NSError *error) {
        NSLog(@"---%@",error);
        [MBProgressHUD showError:@"网络连接错误"];
    }];
    [self.wdajTableView.mj_header endRefreshing];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.wdajArr.count;
}


- (LSWDAJTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSWDAJTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[LSWDAJTableViewCell alloc]init];
    }
    cell.WDAJ = self.wdajArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_searchBar resignFirstResponder];
    LSAjDetailViewController *ajDetailVC = [[LSAjDetailViewController alloc]init];
    ajDetailVC.wdajDetail = self.wdajArr[indexPath.row];
    [self.navigationController pushViewController:ajDetailVC animated:YES];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSArray *)products {
	if(_products == nil) {
		_products = [[NSArray alloc] init];
	}
	return _products;
}



- (NSMutableArray *)wdajArr {
	if(_wdajArr == nil) {
		_wdajArr = [[NSMutableArray alloc] init];
	}
	return _wdajArr;
}

@end
