//
//  ViewController.m
//  LSPT_SX
//
//  Created by 谢琰 on 16/2/24.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "ViewController.h"
#import "LSPT.h"
#import "LSTabBarViewController.h"
#import "UIView+Extension.h"
#import "LSLoginModel.h"
#import "LSUpSSCLViewController.h"
#import "LSAYTreeViewController.h"
#import "LSPJViewController.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIView *accountView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation ViewController
LSLoginModel *myLogin;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"用户登录";
    self.navigationController.navigationBar.hidden = YES;

    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    self.userNameTextField.text = username;
    self.passwordTextField.text = password;
    
    [self updateUI];
    
}

- (void)updateUI
{
    self.loginView.layer.cornerRadius = 10.0f;
    self.loginView.layer.borderWidth = 2.0f;
    self.loginView.layer.borderColor = LSGrayColor.CGColor;
    self.accountView.layer.borderWidth = 1.0f;
    self.passwordView.layer.borderWidth = 1.0f;
    self.accountView.layer.borderColor = LSGlobalColor.CGColor;
    self.passwordView.layer.borderColor = LSGlobalColor.CGColor;
    
}
- (IBAction)login:(id)sender {
    [self clickLogin];
//    LSPJViewController *upVC = [[LSPJViewController alloc]init];
//    [self.navigationController pushViewController:upVC animated:YES];
}

- (void)clickLogin {
    LSTabBarViewController *tabBarVC=[[LSTabBarViewController alloc]init];
    tabBarVC.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
    tabBarVC.navigationItem.title = @"律师平台";
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 49)];
    backView.backgroundColor = [UIColor blackColor];
    [tabBarVC.tabBar insertSubview:backView atIndex:0];
    tabBarVC.tabBar.opaque = YES;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //params[@"sfzjhm"] = self.userNameTextField.text;
    params[@"lszh"] = self.userNameTextField.text;
    params[@"password"] = self.passwordTextField.text;
    [[NSUserDefaults standardUserDefaults] setObject:self.userNameTextField.text forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:self.passwordTextField.text forKey:@"password"];
    [LSHttpTool get:LoginUrl params:params success:^(id json) {
        LSBaseModel *baseModel=[LSBaseModel mj_objectWithKeyValues:json];
        LSLoginModel *loginModel=[LSLoginModel mj_objectWithKeyValues:json[@"obj"]];
        myLogin = loginModel;
        if ([baseModel.status isEqualToString:@"success"]) {
            [[NSUserDefaults standardUserDefaults]setObject:loginModel.id forKey:@"lsid"];
            [[NSUserDefaults standardUserDefaults]setObject:loginModel.lszh forKey:@"lszh"];
            [[NSUserDefaults standardUserDefaults]setObject:loginModel.sfzjhm forKey:@"sfzjhm"];
            [[NSUserDefaults standardUserDefaults]setObject:loginModel.username forKey:@"usernameCN"];
            NSLog(@"-=-%@",loginModel.id);
            [MBProgressHUD showSuccess:@"登陆成功"];
            [self.navigationController pushViewController:tabBarVC animated:YES];
        } else
        {
            [MBProgressHUD showError:@"律师证号错误或密码错误"];
        }
        
        NSLog(@"====%@",json);
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络连接错误"];
        NSLog(@"----%@",error);
    }];
}


- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
