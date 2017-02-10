//
//  LSAddLitigantViewController.m
//  LSPT_SX
//
//  Created by 谢琰 on 16/2/25.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSAddLitigantViewController.h"
#import "SegmentTapView.h"
#import "FlipTableView.h"
#import "LSNaturalPersonViewController.h"
#import "LScorporateOrganizationViewController.h"
#import "LSIncorporateOrganizationViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"
#import "LSConst.h"
#import "IQKeyboardManager.h"
#define ScreeFrame [UIScreen mainScreen].bounds

@interface LSAddLitigantViewController ()<FJSlidingControllerDataSource,FJSlidingControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (nonatomic, strong)NSArray *titles;
@property (nonatomic, strong)NSArray *controllers;
@end

@implementation LSAddLitigantViewController
NSInteger VCindex;


- (void)viewDidLoad {
        
    [super viewDidLoad];
    self.datasouce = self;
    self.delegate = self;
    
    LScorporateOrganizationViewController *v1 = [[LScorporateOrganizationViewController alloc]init];
    v1.parentController = self;
    LSIncorporateOrganizationViewController *v2 = [[LSIncorporateOrganizationViewController alloc]init];
    v2.parentController = self;
    LSNaturalPersonViewController *v3 = [[LSNaturalPersonViewController alloc]init];
    v3.parentController = self;
    
    self.titles      = @[@"自然人",@"法人组织",@"非法人组织"];
    self.controllers = @[v3,v2,v1];
    [self addChildViewController:v1];
    [self addChildViewController:v2];
    [self addChildViewController:v3];
    //self.title = self.titles[0];
    
    [self reloadData];
    self.addBtn.layer.cornerRadius = 5;
    VCindex = 0;
    //[LSNotificationCenter addObserver:self selector:@selector(removeKeyboard) name:@"keyboard" object:nil];
    [LSNotificationCenter addObserver:self selector:@selector(saveDsrSuccess) name:@"SaveDsrSuccessNotification" object:nil];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
    self.navigationItem.title = @"添加当事人";
    }
- (void)saveDsrSuccess
{
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"saveDsrSuccesssaveDsrSuccesssaveDsrSuccess");
}


#pragma mark dataSouce
- (NSInteger)numberOfPageInFJSlidingController:(FJSlidingController *)fjSlidingController{
    return self.titles.count;
}
- (UIViewController *)fjSlidingController:(FJSlidingController *)fjSlidingController controllerAtIndex:(NSInteger)index{
    return self.controllers[index];
}
- (NSString *)fjSlidingController:(FJSlidingController *)fjSlidingController titleAtIndex:(NSInteger)index{
    return self.titles[index];
}
/*
 - (UIColor *)titleNomalColorInFJSlidingController:(FJSlidingController *)fjSlidingController;
 - (UIColor *)titleSelectedColorInFJSlidingController:(FJSlidingController *)fjSlidingController;
 - (UIColor *)lineColorInFJSlidingController:(FJSlidingController *)fjSlidingController;
 - (CGFloat)titleFontInFJSlidingController:(FJSlidingController *)fjSlidingController;
 */

#pragma mark delegate
- (void)fjSlidingController:(FJSlidingController *)fjSlidingController selectedIndex:(NSInteger)index{
    // presentIndex
    NSLog(@"%ld",index);
    self.title = [self.titles objectAtIndex:index];
}
- (void)fjSlidingController:(FJSlidingController *)fjSlidingController selectedController:(UIViewController *)controller{
    // presentController
}
- (void)fjSlidingController:(FJSlidingController *)fjSlidingController selectedTitle:(NSString *)title{
    // presentTitle
}
-(void)dealloc{
    NSLog(@"!dealloc!");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveClick:(id)sender {
    [LSNotificationCenter postNotificationName:LsLitigantSaveButtonDidClickNotification object:nil];
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
