//
//  LSZxAyViewController.m
//  LSPT_SX
//
//  Created by 何键键 on 16/3/10.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSZxAyViewController.h"
#import "LSPT.h"
#import "LSAYInfo.h"
#import "BDDynamicTreeNode.h"
@interface LSZxAyViewController ()
{
    BDDynamicTree *_dynamicTree1;
    
}

@property (nonatomic, strong) NSMutableArray *ZxAYArr;
@end
NSString *zxAyStr;
NSString *zxAyDm;
@implementation LSZxAyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择案由";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
    [self loadAY];
    
    _dynamicTree1 = [[BDDynamicTree alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) nodes:self.ZxAYArr];
    _dynamicTree1.delegate = self;
    
    [self.view addSubview:_dynamicTree1];

    // Do any additional setup after loading the view.
}
- (void)loadAY {
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"myAy"ofType:@"json"];
    //根据文件路径读取数据
    NSData *data = [[NSData alloc]initWithContentsOfFile:filePath];
    //格式化成json数据
    //id jsonObject = [NSJSONSerialization JSONObjectWithData:jdata options:Nil Optionserror:&error];
    NSError *error = nil;
    id JsonObject=[NSJSONSerialization JSONObjectWithData:data
                                                  options:NSJSONReadingAllowFragments
                                                    error:&error];
    NSLog(@"===%@===",JsonObject);
    NSArray *arr = [LSAYInfo mj_objectArrayWithKeyValuesArray:JsonObject[@"RECORDS"]];
    BDDynamicTreeNode *root = [[BDDynamicTreeNode alloc] init];
    root.originX = 20.f;
    root.isDepartment = YES;
    root.fatherNodeId = nil;
    root.nodeId = @"node_1000";
    root.name = @"请选择案由";
    root.data = @{@"dmms":@"请选择案由"};
    [self.ZxAYArr addObject:root];
    
    BDDynamicTreeNode *root1 = [[BDDynamicTreeNode alloc] init];
    root1.isDepartment = YES;
    root1.fatherNodeId = @"node_1000";
    root1.nodeId = @"3001";
    root1.name = @"执行案由";
    root1.data = @{@"dmms":@"执行案由"};
    [self.ZxAYArr addObject:root1];
    
    
    for (LSAYInfo *ay in arr) {
        BDDynamicTreeNode *caiwu = [[BDDynamicTreeNode alloc] init];
        if ([ay.leaf isEqualToString:@"1"]) {
            caiwu.isDepartment = NO;
        } else {
            caiwu.isDepartment = YES;
        }
        caiwu.fatherNodeId = ay.sjdm;
        caiwu.nodeId = ay.dm;
        caiwu.name = ay.dmms;
        caiwu.data = @{@"name":ay.dmms};
        [self.ZxAYArr addObject:caiwu];
    }
}

- (void)dynamicTree:(BDDynamicTree *)dynamicTree didSelectedRowWithNode:(BDDynamicTreeNode *)node
{
    if (!node.isDepartment) {
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"确认选择此案由吗？" message:node.name preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            zxAyStr = node.name;
            zxAyDm = node.nodeId;
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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

- (NSMutableArray *)ZxAYArr {
	if(_ZxAYArr == nil) {
		_ZxAYArr = [[NSMutableArray alloc] init];
	}
	return _ZxAYArr;
}

@end
