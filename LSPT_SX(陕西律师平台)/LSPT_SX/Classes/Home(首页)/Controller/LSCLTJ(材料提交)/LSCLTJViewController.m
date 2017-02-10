//
//  LSCLTJViewController.m
//  LSPT_SX
//
//  Created by 何键键 on 16/2/24.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSCLTJViewController.h"
#import "LSCLTJTableViewCell.h"
#import "LSClApplyViewController.h"
#import "UITableView+Popover.h"
#import "LSPT.h"
#import "LSCLTJModel.h"

static NSString *ID=@"cltjCell";

@interface LSCLTJViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *cltjTableView;
@property (nonatomic, strong) NSMutableArray *cltjArr;
@property(nonatomic,strong) NSString *documentPath;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) LSCLTJModel *cltjModel;;
@property (nonatomic, assign) int currentPage;
@property (weak, nonatomic) IBOutlet UIView *noDetailView;

@end

@implementation LSCLTJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"证据列表";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(create) image:@"btn_login" highImage:@"btn_press_login" title:@"新增"];
    
    [self.cltjTableView registerNib:[UINib nibWithNibName:@"LSCLTJTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
    self.cltjTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreCLTJ)];
        // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    self.noDetailView.hidden = YES;
    self.cltjTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewCLTJ)];
    [self.cltjTableView.mj_header beginRefreshing];
}
- (void)loadNewCLTJ
{
    self.currentPage = 1;
    [self.cltjTableView.mj_footer endRefreshing];
    [self LoadCLTJ];
}
- (void)loadMoreCLTJ
{
    self.currentPage ++;
    [self LoadCLTJ];
}
- (void)LoadCLTJ {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *lsid = [[NSUserDefaults standardUserDefaults]objectForKey:@"lsid"];
    params[@"lsid"] = lsid;
    params[@"currentPage"] = @(self.currentPage);
    params[@"pageSize"] = @"5";
    [LSHttpTool get:GetCLTJUrl params:params success:^(id json) {
        self.cltjArr = [LSCLTJModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"result"]];
        if (self.cltjArr.count < 5) {
            [self.cltjTableView.mj_footer endRefreshingWithNoMoreData];
        }
        LSBaseModel *baseModel=[LSBaseModel mj_objectWithKeyValues:json];
        if ([baseModel.status isEqualToString:@"fail"]) {
            self.noDetailView.hidden = NO;
            self.noDetailView.layer.cornerRadius = 5.0f;
            self.noDetailView.layer.borderWidth = 1.0f;
            self.noDetailView.layer.borderColor = LSGrayColor.CGColor;
        }
        [self.cltjTableView reloadData];
        NSLog(@"===%@",json);
    } failure:^(NSError *error) {
       [MBProgressHUD showError:@"网络连接错误"];
    }];
    [self.cltjTableView.mj_footer endRefreshing];
    [self.cltjTableView.mj_header endRefreshing];
}



- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)create {
    LSClApplyViewController *alDetailVC = [[LSClApplyViewController alloc]init];
    [self.navigationController pushViewController:alDetailVC animated:YES];
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cltjArr.count;
}


- (LSCLTJTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSCLTJTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[LSCLTJTableViewCell alloc]init];
    }
    cell.CLTJ = self.cltjArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.cltjModel = self.cltjArr[indexPath.row];

//    if ([self.cltjModel.zt isEqualToString:@"2"]) {
//        NSString *name = @"下载";
//        NSMutableArray *items = [NSMutableArray array];
//
//        PopoverItem *item = [[PopoverItem alloc]initWithName:name image:nil selectedHandler:^(PopoverItem *item) {
//            NSLog(@"下载下载下载");
//            NSString *filePath = [self.documentPath stringByAppendingPathComponent:self.cltjModel.wjmc];
//            self.params[@"wjmc"] = self.cltjModel.wjmc;
//            self.params[@"wjlj"] = filePath;
//            
//            [LSHttpTool get:downloadFileUrl params:self.params success:^(id json) {
//                NSLog(@"==%@",json);
//                [MBProgressHUD showSuccess:@"文件下载成功"];
//            } failure:^(NSError *error) {
//                [MBProgressHUD showError:@"文件下载失败"];
//            }];
//        }];
//        [items addObject:item];
//[tableView showPopoverWithItems:items forIndexPath:indexPath];
//
//    }
//    
//    else {
    
    NSLog(@"%@===",self.cltjModel.zt);
    
    NSArray *names = @[@"下载",@"提交",@"删除"];
    NSMutableArray *items = [NSMutableArray array];
    
    for (NSInteger i = 0; i<names.count; i++) {
        PopoverItem *item = [[PopoverItem alloc]initWithName:names[i] image:nil selectedHandler:^(PopoverItem *popoverItem) {
            if ([popoverItem.name isEqualToString:@"下载"]) {
                NSLog(@"下载下载下载");
                //NSString *filePath = [self.documentPath stringByAppendingPathComponent:self.cltjModel.wjmc];
                self.params[@"wjmc"] = self.cltjModel.wjmc;
                self.params[@"wjlj"] = self.cltjModel.wjlj;
                NSLog(@"===%@",self.params);
                NSString *savedPath = [NSHomeDirectory() stringByAppendingString:self.cltjModel.wjmc];
                NSLog(@"%@",savedPath);
                [self downloadFileWithOption:self.params
                               withInferface:downUrl
                                   savedPath:savedPath
                             downloadSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 NSLog(@"%@",responseObject);
                                 [MBProgressHUD showSuccess:@"文件下载成功"];
                                 UIImage *image = [[UIImage alloc] initWithContentsOfFile:savedPath];
                                 UIImageWriteToSavedPhotosAlbum(image, self,  nil , nil );
                             } downloadFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 [MBProgressHUD showError:@"文件下载失败"];
                             } progress:^(float progress) {
                                 
                             }];
            }
            if ([popoverItem.name isEqualToString:@"提交"]) {
                NSLog(@"提交提交提交");
                self.params[@"id"] = self.cltjModel.ID;
                [LSHttpTool get:CLTJUrl params:self.params success:^(id json) {
                    NSLog(@"==%@",json);
                    LSBaseModel *baseModel=[LSBaseModel mj_objectWithKeyValues:json];
                    if ([baseModel.status isEqualToString:@"success"]) {
                        [MBProgressHUD showSuccess:@"文件提交成功"];
                    } else {
                        [MBProgressHUD showError:@"文件提交失败"];
                    }
                    
                } failure:^(NSError *error) {
                    [MBProgressHUD showError:@"网络连接错误"];
                }];
            }
            if ([popoverItem.name isEqualToString:@"删除"]) {
                NSLog(@"删除删除删除");
                self.params[@"id"] = self.cltjModel.ID;
                [LSHttpTool get:CLDelUrl params:self.params success:^(id json) {
                    NSLog(@"==%@",json);
                    LSBaseModel *baseModel=[LSBaseModel mj_objectWithKeyValues:json];
                    if ([baseModel.status isEqualToString:@"success"]) {
                        [MBProgressHUD showSuccess:@"文件删除成功"];
                    } else {
                        [MBProgressHUD showError:@"文件删除失败"];
                    }
                } failure:^(NSError *error) {
                    [MBProgressHUD showError:@"网络连接错误"];
                }];
            }
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

- (NSMutableDictionary *)params {
	if(_params == nil) {
		_params = [[NSMutableDictionary alloc] init];
	}
	return _params;
}

@end
