//
//  LSNavViewController.m
//  LSPT_SX
//
//  Created by 谢琰 on 16/2/24.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSNavViewController.h"
#import "LSConst.h"
#import "UIBarButtonItem+Extension.h"

@interface LSNavViewController ()

@end

@implementation LSNavViewController

+ (void)initialize
{
    UINavigationBar *bar = [UINavigationBar appearance];
    NSMutableDictionary *textAttr = [NSMutableDictionary dictionary];
    textAttr[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    textAttr[NSForegroundColorAttributeName] = [UIColor whiteColor];
    bar.titleTextAttributes = textAttr;
    [bar setBarTintColor:LSGlobalColor];
    [bar setShadowImage:[UIImage new]];
    
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count >0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
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
