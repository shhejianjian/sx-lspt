//
//  LSMaterialListViewController.m
//  LSPT_SX
//
//  Created by 谢琰 on 16/3/2.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSMaterialListViewController.h"
#import "LSMaterialCell.h"
#import "LSWSLA.h"
#import "LSPT.h"
#import "LSMaterial.h"
#import "LSUpSSCLViewController.h"
@interface LSMaterialListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) NSMutableArray *materials;
@property (weak, nonatomic) IBOutlet UIView *noDataView;
@property (weak, nonatomic) IBOutlet UITableView *materialTableView;
@property (nonatomic, copy) NSString *status;
@end

@implementation LSMaterialListViewController
static NSString *ID=@"LSMaterialCell";
extern LSWSLA *mWsla;
- (NSMutableArray *)materials
{
    if (!_materials) {
        _materials = [NSMutableArray array];
    }
    return _materials;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"诉讼材料列表";
    [self.materialTableView registerNib:[UINib nibWithNibName:@"LSMaterialCell" bundle:nil] forCellReuseIdentifier:ID];
    self.materialTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
    if ([mWsla.zt isEqualToString:@"1"]) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(add) image:@"btn_login" highImage:@"btn_press_login" title:@"添加"];
    }
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 1.0;
    [self.materialTableView addGestureRecognizer:longPressGr];
    

}

- (void)viewWillAppear:(BOOL)animated {
    self.noDataView.hidden = YES;
    // 添加上拉刷新
    self.materialTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMaterial)];
    [self.materialTableView.mj_header beginRefreshing];
}

- (void)add
{
    LSUpSSCLViewController *upSSCLVC = [[LSUpSSCLViewController alloc]init];
    [self.navigationController pushViewController:upSSCLVC animated:YES];
}
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:self.materialTableView];
        NSIndexPath * indexPath = [self.materialTableView indexPathForRowAtPoint:point];
        if(indexPath == nil) return ;
        LSMaterial *material = self.materials[indexPath.row];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"id"] = material.ID;
        [LSHttpTool get:DelSsclUrl params:params success:^(id json) {
            [MBProgressHUD showError:@"删除成功"];
            [self.materialTableView reloadData];
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"网络不稳定,请稍后再试"];
        }];
        
    }
}

- (void)loadMaterial
{
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"ajbs"] = mWsla.ajbs;
    [LSHttpTool get:SsclUrl params:params success:^(id json) {
        NSLog(@"material 请求参数%@--请求结果%@",params,json);
        self.status = json[@"status"];
        self.materials = [LSMaterial mj_objectArrayWithKeyValuesArray:json[@"data"]];
        [self.materialTableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不稳定,请稍后再试"];
    }];
    [self.materialTableView.mj_header endRefreshing];
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.status isEqualToString:@"fail"]) {
        self.noDataView.hidden = NO;
        self.noDataView.layer.cornerRadius = 5.0f;
        self.noDataView.layer.borderWidth = 1.0f;
        self.noDataView.layer.borderColor = LSGrayColor.CGColor;
    }
    return self.materials.count;
}


- (LSMaterialCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSMaterialCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    if (!cell) {
        cell = [[LSMaterialCell alloc]init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.material = self.materials[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"长按可删除";
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:3];
}

@end
