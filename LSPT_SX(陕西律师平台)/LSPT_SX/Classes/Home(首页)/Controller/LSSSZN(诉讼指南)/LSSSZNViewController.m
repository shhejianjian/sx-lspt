//
//  LSSSZNViewController.m
//  LSPT_SX
//
//  Created by 谢琰 on 16/2/24.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSSSZNViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "LSSSZNCell.h"
#import "LSSSZNDetailViewController.h"


@interface LSSSZNViewController ()
@property(nonatomic,strong) NSFileManager *fileMgr;

@end

NSString *mySelectIndex;
@implementation LSSSZNViewController
static NSString *ID=@"LSSSZNCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"LSSSZNCell" bundle:nil] forCellReuseIdentifier:ID];
    self.navigationItem.title = @"诉讼指南";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

#pragma mark - Table view  delegate

- (LSSSZNCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSSSZNCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[LSSSZNCell alloc]init];
    }
    cell.guidanceLabel.font = [UIFont systemFontOfSize:14];
    if (indexPath.row == 0) {
        cell.guidanceLabel.text = @"民事诉讼风险提示书";
    } else if (indexPath.row == 1) {
        cell.guidanceLabel.text = @"当事人诉讼权利与义务须知";
    } else if (indexPath.row == 2) {
        cell.guidanceLabel.text = @"登记立案须知";
    } else if (indexPath.row == 3) {
        cell.guidanceLabel.text = @"民事案件起诉须知";
    } else if (indexPath.row == 4) {
        cell.guidanceLabel.text = @"小额诉讼须知";
    } else if (indexPath.row == 5) {
        cell.guidanceLabel.text = @"行政案件起诉须知";
    } else if (indexPath.row == 6) {
        cell.guidanceLabel.text = @"刑事自诉案件起诉须知";
    } else if (indexPath.row == 7) {
        cell.guidanceLabel.text = @"刑事附带民事案件起诉须知";
    } else if (indexPath.row == 8) {
        cell.guidanceLabel.text = @"申请保全须知";
    } else if (indexPath.row == 9) {
        cell.guidanceLabel.text = @"申请先予执行须知";
    } else if (indexPath.row == 10) {
        cell.guidanceLabel.text = @"上诉须知";
    } else if (indexPath.row == 11) {
        cell.guidanceLabel.text = @"申请执行须知";
    } else if (indexPath.row == 12) {
        cell.guidanceLabel.text = @"民事案件申请再审须知";
    } else if (indexPath.row == 13) {
        cell.guidanceLabel.text = @"行政案件申请再审须知";
    } else if (indexPath.row == 14) {
        cell.guidanceLabel.text = @"刑事案件申诉须知";
    } else if (indexPath.row == 15) {
        cell.guidanceLabel.text = @"诉前调解建议书";
    } else if (indexPath.row == 16) {
        cell.guidanceLabel.text = @"立案调解建议书";
    } else if (indexPath.row == 17) {
        cell.guidanceLabel.text = @"司法文书电子送达须知";
    } else if (indexPath.row == 18) {
        cell.guidanceLabel.text = @"诉讼收费";
    } else if (indexPath.row == 19) {
        cell.guidanceLabel.text = @"人民法院关于缓、减、免交诉讼费的规定";
    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSSSZNDetailViewController *ssznDetailVC = [LSSSZNDetailViewController new];
    ssznDetailVC.index = indexPath.row;
    [self.navigationController pushViewController:ssznDetailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

@end
