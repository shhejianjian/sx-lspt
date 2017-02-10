//
//  LSTabBarViewController.m
//  LSPT_SX
//
//  Created by 谢琰 on 16/2/24.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSTabBarViewController.h"
#import "LSHomeViewController.h"
#import "LSMyCenterViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "LSNavViewController.h"
@interface LSTabBarViewController ()

@end

@implementation LSTabBarViewController
+ (void)initialize{
    UITabBar *bar = [UITabBar appearance];
    [bar setBackgroundColor:[UIColor blackColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LSHomeViewController *homeVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"login"];
    [self addVc:homeVC title:@"首页" Image:@"button_main" SelectedImage:nil];
    LSMyCenterViewController *myCenterVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"center"];
    [self addVc:myCenterVC title:@"个人中心" Image:@"button_myself" SelectedImage:nil];
}

- (void)addVc:(UIViewController *)childVC title:(NSString *)title Image:(NSString *)image SelectedImage:(NSString *)selectedImage;
{
    childVC.title = title;
    childVC.tabBarItem.image=[UIImage imageNamed:image];
    childVC.tabBarItem.selectedImage=[[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    LSNavViewController *nav=[[LSNavViewController alloc]initWithRootViewController:childVC];
    [self addChildViewController:nav];
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
