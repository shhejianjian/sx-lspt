//
//  LSFGMenuTableViewController.m
//  LSPT_SX
//
//  Created by 何键键 on 16/2/28.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSFGMenuTableViewController.h"
#import "LSMenuCell.h"
#import "LSConst.h"
#import "LSFgDetailViewController.h"
#import "LSFgChangeViewController.h"
@interface LSFGMenuTableViewController ()
@property (nonatomic, strong) LSFgDetailViewController *detailVC;
@end

@implementation LSFGMenuTableViewController
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
    return 2;
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
    return cell;
}
#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        NSLog(@"didSelectRowAtIndexPath");
        [LSNotificationCenter postNotificationName:LSFGModifyDidClickNotification object:nil];
    }
    else if (indexPath.row == 1) {
        
        [LSNotificationCenter postNotificationName:LSFGDeleteDidClickNotification object:nil];
        
    }
}

- (LSFgDetailViewController *)detailVC {
	if(_detailVC == nil) {
		_detailVC = [[LSFgDetailViewController alloc] init];
	}
	return _detailVC;
}

@end
