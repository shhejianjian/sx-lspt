//
//  LSHomeViewController.m
//  LSPT_SX
//
//  Created by 谢琰 on 16/2/24.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSHomeViewController.h"
#import "LSSSZNViewController.h"
#import "LSWSLAMainViewController.h"
#import "LSWSYJViewController.h"
#import "LSWDAJViewController.h"
#import "LSYJJYViewController.h"
#import "LSTSBRViewController.h"
#import "LSLXFGViewController.h"
#import "LSDSWSViewController.h"
#import "LSCLTJViewController.h"
#import "LSSSBQViewController.h"
#import "LSYQKTViewController.h"
#import "LSDCLViewController.h"
#import "LSPT.h"

@interface LSHomeViewController ()

@end

@implementation LSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"律师平台";
    self.tabBarController.tabBar.tintColor = [UIColor grayColor];
    
    //self.tabBarController.tabBar.tintColor = [UIColor whiteColor];
    //[self loadAy];
}









- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)ssznBtn:(id)sender {
    LSSSZNViewController *SSZNVC = [[LSSSZNViewController alloc]init];
    [self.navigationController pushViewController:SSZNVC animated:YES];
    
}
- (IBAction)wslaBtn:(id)sender {
    LSWSLAMainViewController *WSLAVC = [[LSWSLAMainViewController alloc]init];
    [self.navigationController pushViewController:WSLAVC animated:YES];
}
- (IBAction)ssbqBtn:(id)sender {
    LSSSBQViewController *SSBQVC = [[LSSSBQViewController alloc]init];
    [self.navigationController pushViewController:SSBQVC animated:YES];
}
- (IBAction)yqktBtn:(id)sender {
    LSYQKTViewController *YQKTVC = [[LSYQKTViewController alloc]init];
    [self.navigationController pushViewController:YQKTVC animated:YES];
}
- (IBAction)dclBtn:(id)sender {
    LSDCLViewController *DCLVC = [[LSDCLViewController alloc]init];
    [self.navigationController pushViewController:DCLVC animated:YES];
}
- (IBAction)wdajBtn:(id)sender {
    LSWDAJViewController *WDANVC = [[LSWDAJViewController alloc]init];
    [self.navigationController pushViewController:WDANVC animated:YES];
}
- (IBAction)wsyjBtn:(id)sender {
    LSWSYJViewController *WSYJVC = [[LSWSYJViewController alloc]init];
    [self.navigationController pushViewController:WSYJVC animated:YES];
}
- (IBAction)tsbrBtn:(id)sender {
    LSTSBRViewController *TSBRVC = [[LSTSBRViewController alloc]init];
    [self.navigationController pushViewController:TSBRVC animated:YES];
}
- (IBAction)lxfgBtn:(id)sender {
    LSLXFGViewController *LXFGVC = [[LSLXFGViewController alloc]init];
    [self.navigationController pushViewController:LXFGVC animated:YES];
}
- (IBAction)dswjBtn:(id)sender {
    LSDSWSViewController *DSWSVC = [[LSDSWSViewController alloc]init];
    [self.navigationController pushViewController:DSWSVC animated:YES];
}
- (IBAction)cltjBtn:(id)sender {
    LSCLTJViewController *CLTJVC = [[LSCLTJViewController alloc]init];
    [self.navigationController pushViewController:CLTJVC animated:YES];
}
- (IBAction)yjjyBtn:(id)sender {
    LSYJJYViewController *YJJYVC = [[LSYJJYViewController alloc]init];
    [self.navigationController pushViewController:YJJYVC animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
