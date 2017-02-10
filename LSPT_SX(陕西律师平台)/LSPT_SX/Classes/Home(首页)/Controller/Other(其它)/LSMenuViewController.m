//
//  LSMenuViewController.m
//  LSPT_SX
//
//  Created by 谢琰 on 16/2/24.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSMenuViewController.h"
#import "LSMenuCell.h"
#import "LSConst.h"
#import "LSWSLAFirstViewController.h"
#import "LSWSLADetailViewController.h"

@interface LSMenuViewController ()
@property (nonatomic,strong) LSWSLADetailViewController *detailVC;
@end

@implementation LSMenuViewController
static NSString *ID=@"LSMenuCell";
- (LSWSLADetailViewController *)detailVC
{
    if (!_detailVC) {
        _detailVC = [[LSWSLADetailViewController alloc]init];
    }
    return _detailVC;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = LSColor(43, 50, 53);
    [self.tableView registerNib:[UINib nibWithNibName:@"LSMenuCell" bundle:nil] forCellReuseIdentifier:ID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (LSMenuCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[LSMenuCell alloc]init];
    }
    cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mm_title_functionframe_pressed.9"]];
    cell.index = indexPath.row;
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    if (indexPath.row == 0) {
        
        cell.menuImageView.image = [UIImage imageNamed:@"iv_update"];
        cell.menuLabel.text = @"修改";
    }
    else if (indexPath.row == 1) {
        
        cell.menuImageView.image = [UIImage imageNamed:@"iv_delete"];
        cell.menuLabel.text = @"删除";
    }
    else if (indexPath.row == 2) {
        
        cell.menuImageView.image = [UIImage imageNamed:@"iv_dsr"];
        cell.menuLabel.text = @"当事人";
    }
    else if (indexPath.row == 3) {
        
        cell.menuImageView.image = [UIImage imageNamed:@"iv_upload"];
        cell.menuLabel.text = @"诉讼材料";
    }
    else if (indexPath.row == 4) {
        
        cell.menuImageView.image = [UIImage imageNamed:@"iv_submit"];
        cell.menuLabel.text = @"提交";
    }
    return cell;
}
#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        NSLog(@"didSelectRowAtIndexPath");
        [LSNotificationCenter postNotificationName:LSModifyDidClickNotification object:nil];
    }
    else if (indexPath.row == 1) {
        
        [LSNotificationCenter postNotificationName:LSDeleteDidClickNotification object:nil];
        
    }
    else if (indexPath.row == 2) {
        
        [LSNotificationCenter postNotificationName:LSLitigantDidClickNotification object:nil];
        
    }
    else if (indexPath.row == 3) {
        
        [LSNotificationCenter postNotificationName:LSMaterialDidClickNotification object:nil];
    }
    else if (indexPath.row == 4) {
        
        [LSNotificationCenter postNotificationName:LSSubmitDidClickNotification object:nil];
    }
    
}

@end
