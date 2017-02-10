//
//  LSDSWSViewController.m
//  LSPT_SX
//
//  Created by 何键键 on 16/2/24.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSDSWSViewController.h"
#import "LSDSWSTableViewCell.h"
#import "UITableView+Popover.h"
#import "LSDSWSModel.h"
#import "LSPT.h"
#import "AFNetWorking.h"

static NSString *ID=@"dswsCell";
@interface LSDSWSViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *dswsTableView;
@property (nonatomic, strong) NSMutableArray *dswsArr;
@property (nonatomic, strong) LSDSWSModel *dswsModel;
@property (nonatomic, assign) int currentPage;
@property (weak, nonatomic) IBOutlet UIView *noDetailView;

@end

@implementation LSDSWSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"文书详情";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
    [self.dswsTableView registerNib:[UINib nibWithNibName:@"LSDSWSTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
    
    self.dswsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDSWS)];
    self.dswsTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDSWS)];
    [self.dswsTableView.mj_header beginRefreshing];
    // Do any additional setup after loading the view from its nib.
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadNewDSWS
{
    self.currentPage = 1;
    [self.dswsTableView.mj_footer endRefreshing];

    [self LoadDSWS];
}
- (void)loadMoreDSWS
{
    self.currentPage ++;
    [self LoadDSWS];
}
- (void)LoadDSWS {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *lsid = [[NSUserDefaults standardUserDefaults]objectForKey:@"lsid"];
    params[@"lsid"] = lsid;
    params[@"currentPage"] = @(self.currentPage);
    params[@"pageSize"] = @"5";
    [LSHttpTool get:DSWSUrl params:params success:^(id json) {
        self.dswsArr = [LSDSWSModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"result"]];
        if (self.dswsArr.count < 5) {
            [self.dswsTableView.mj_footer endRefreshingWithNoMoreData];
        }
        LSBaseModel *baseModel=[LSBaseModel mj_objectWithKeyValues:json];
        if ([baseModel.status isEqualToString:@"fail"]) {
            self.noDetailView.hidden = NO;
            self.noDetailView.layer.cornerRadius = 5.0f;
            self.noDetailView.layer.borderWidth = 1.0f;
            self.noDetailView.layer.borderColor = LSGrayColor.CGColor;
        }

        [self.dswsTableView reloadData];
        NSLog(@"===%@---%@",json,self.dswsArr);
    } failure:^(NSError *error) {
        NSLog(@"---%@",error);
        [MBProgressHUD showError:@"网络连接错误"];
    }];
    [self.dswsTableView.mj_footer endRefreshing];
    [self.dswsTableView.mj_header endRefreshing];
}


#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dswsArr.count;
}


- (LSDSWSTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSDSWSTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[LSDSWSTableViewCell alloc]init];
    }
    cell.DSWS = self.dswsArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *names = @[@"下载"];
    self.dswsModel = self.dswsArr[indexPath.row];
    NSMutableArray *items = [NSMutableArray array];
    for (NSInteger i = 0; i<names.count; i++) {
        PopoverItem *item = [[PopoverItem alloc]initWithName:names[i] image:nil selectedHandler:^(PopoverItem *popoverItem) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"wjmc"] = self.dswsModel.wjmc;
            params[@"wjlj"] = self.dswsModel.wjlj;
            NSLog(@"%@",params);
            [LSHttpTool post:downloadFileUrl params:params success:^(id json) {
                NSLog(@"==%@",json);
                    [MBProgressHUD showSuccess:@"文件下载成功"];
            } failure:^(NSError *error) {
                [MBProgressHUD showError:@"网络连接错误"];
            }];
            NSString *savedPath = [NSHomeDirectory() stringByAppendingString:self.dswsModel.wjmc];
            NSLog(@"%@",savedPath);
            [self downloadFileWithOption:params
                           withInferface:downUrl
                               savedPath:savedPath
                         downloadSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                             NSLog(@"--%@",responseObject);
                             [MBProgressHUD showSuccess:@"文件下载成功"];
                              UIImage *image = [[UIImage alloc] initWithContentsOfFile:savedPath];
                             UIImageWriteToSavedPhotosAlbum(image, self,  nil , nil );
                         } downloadFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             [MBProgressHUD showError:@"文件下载失败"];
                         } progress:^(float progress) {
                             
                         }];
                }];
        [items addObject:item];
    }
    [tableView showPopoverWithItems:items forIndexPath:indexPath];
}



- (void)downloadFileWithOption:(NSDictionary *)paramDic
                 withInferface:(NSString*)requestURL
                     savedPath:(NSString*)savedPath
               downloadSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               downloadFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                      progress:(void (^)(float progress))progress

{
    //沙盒路径    //NSString *savedPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/xxx.zip"];
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request =[serializer requestWithMethod:@"POST" URLString:requestURL parameters:paramDic error:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:savedPath append:NO]];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        float p = (float)totalBytesRead / totalBytesExpectedToRead;
        progress(p);
        NSLog(@"download：%f", (float)totalBytesRead / totalBytesExpectedToRead);
        
    }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
        NSLog(@"下载成功");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        success(operation,error);
        NSLog(@"下载失败");
    }];
    [operation start];
    
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

- (NSMutableArray *)dswsArr {
	if(_dswsArr == nil) {
		_dswsArr = [[NSMutableArray alloc] init];
	}
	return _dswsArr;
}


@end
