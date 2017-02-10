//
//  LSAYTreeViewController.m
//  LSPT_SX
//
//  Created by 何键键 on 16/3/3.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSAYTreeViewController.h"
#import "LSPT.h"
#import "LSAYInfo.h"
#import "BDDynamicTreeNode.h"

@interface LSAYTreeViewController ()
{
    BDDynamicTree *_dynamicTree1;

}

@property (nonatomic, strong) NSMutableArray *AYArr;
@end
NSString *msAyStr;
NSString *msAyDm;
@implementation LSAYTreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择案由";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
     [self loadAY];
    _dynamicTree1 = [[BDDynamicTree alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) nodes:self.AYArr];
    _dynamicTree1.delegate = self;
    
    [self.view addSubview:_dynamicTree1];
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height/2, self.view.bounds.size.width, 2)];
//    view.backgroundColor = LSGrayColor;
//    [self.view addSubview:view];
//    _dynamicTree2 = [[BDDynamicTree alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height/2+2, self.view.bounds.size.width, self.view.bounds.size.height - 20) nodes:self.newArr];
//    _dynamicTree2.delegate = self;
//    [self.view addSubview:_dynamicTree2];
   
    
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
    [self.AYArr addObject:root];
    
    BDDynamicTreeNode *root1 = [[BDDynamicTreeNode alloc] init];
    root1.isDepartment = YES;
    root1.fatherNodeId = @"node_1000";
    root1.nodeId = @"896";
    root1.name = @"民事案由";
    root1.data = @{@"dmms":@"民事案由"};
    [self.AYArr addObject:root1];
    
    BDDynamicTreeNode *root2 = [[BDDynamicTreeNode alloc] init];
    root2.isDepartment = YES;
    root2.fatherNodeId = @"node_1000";
    root2.nodeId = @"200000";
    root2.name = @"民事新案由";
    root2.data = @{@"dmms":@"民事新案由"};
    [self.AYArr addObject:root2];

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
        [self.AYArr addObject:caiwu];
    }
}

- (void)dynamicTree:(BDDynamicTree *)dynamicTree didSelectedRowWithNode:(BDDynamicTreeNode *)node
{
    if (!node.isDepartment) {
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"确认选择此案由吗？" message:node.name preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            msAyStr = node.name;
            msAyDm = node.nodeId;
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

- (NSMutableArray *)AYArr {
	if(_AYArr == nil) {
		_AYArr = [[NSMutableArray alloc] init];
	}
	return _AYArr;
}

@end
