//
//  LSMyCenterViewController.m
//  LSPT_SX
//
//  Created by 何键键 on 16/2/24.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSMyCenterViewController.h"
#import "MBProgressHUD+MJ.h"
#import "ViewController.h"
@interface LSMyCenterViewController ()
@property (weak, nonatomic) IBOutlet UILabel *myNameLabel;

@end

@implementation LSMyCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    
    _myNameLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"usernameCN"];
    
}
- (IBAction)back:(id)sender {
    ViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"loginVC"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)bbgxBtn:(id)sender {
    [MBProgressHUD showSuccess:@"已经是最新版本"];
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationItem.hidesBackButton = YES;
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

@end
