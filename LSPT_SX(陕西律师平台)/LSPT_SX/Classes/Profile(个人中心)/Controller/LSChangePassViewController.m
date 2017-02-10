//
//  LSChangePassViewController.m
//  LSPT_SX
//
//  Created by 何键键 on 16/2/26.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSChangePassViewController.h"
#import "LSPT.h"
@interface LSChangePassViewController ()
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UIView *oldPassView;
@property (weak, nonatomic) IBOutlet UIView *NewPasswordView;
@property (weak, nonatomic) IBOutlet UIView *againPassView;

@property (weak, nonatomic) IBOutlet UITextField *oldPassTextField;
@property (weak, nonatomic) IBOutlet UITextField *NewPassTextField;
@property (weak, nonatomic) IBOutlet UITextField *againTextField;


@end

@implementation LSChangePassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.oldPassView.layer.borderWidth = 1;
    self.oldPassView.layer.borderColor = LSGlobalColor.CGColor;
    self.NewPasswordView.layer.borderWidth = 1;
    self.NewPasswordView.layer.borderColor = LSGlobalColor.CGColor;
    self.againPassView.layer.borderWidth = 1;
    self.againPassView.layer.borderColor = LSGlobalColor.CGColor;
    
    self.detailView.layer.borderWidth = 1;
    self.detailView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.detailView.layer.cornerRadius = 5;
    self.navigationItem.title = @"密码重置";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
    // Do any additional setup after loading the view.
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)savePassword:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *lsid = [[NSUserDefaults standardUserDefaults]objectForKey:@"lsid"];
    params[@"id"] = lsid;
    params[@"oldPassword"] = self.oldPassTextField.text;
    if ([self.NewPassTextField.text isEqualToString:self.againTextField.text]) {
        params[@"newPassword"] = self.NewPassTextField.text;
    } else {
        [MBProgressHUD showError:@"新密码输入请保持一致"];
    }
    NSLog(@"<>%@",params);
    [LSHttpTool post:ModifyPasswordUrl params:params success:^(id json) {
        NSLog(@"%@",json);
        LSBaseModel *baseModel=[LSBaseModel mj_objectWithKeyValues:json];
        if ([baseModel.status isEqualToString:@"success"]) {
            [MBProgressHUD showSuccess:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            [MBProgressHUD showError:@"修改失败"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络连接错误,请稍后再试"];
    }];
    
    
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
