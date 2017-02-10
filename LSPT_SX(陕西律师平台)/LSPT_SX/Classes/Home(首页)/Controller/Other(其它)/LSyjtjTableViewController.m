//
//  LSyjtjTableViewController.m
//  LSPT_SX
//
//  Created by 何键键 on 16/3/2.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSyjtjTableViewController.h"
#import "LSMenuCell.h"
#import "LSConst.h"
@interface LSyjtjTableViewController ()

@end

@implementation LSyjtjTableViewController
static NSString *ID=@"LSMenuCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = LSColor(43, 50, 53);
    [self.tableView registerNib:[UINib nibWithNibName:@"LSMenuCell" bundle:nil] forCellReuseIdentifier:ID];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
        [LSNotificationCenter postNotificationName:LSPJModifyDidClickNotification object:nil];
    }
}
@end