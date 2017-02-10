//
//  LSTJYJViewController.m
//  LSPT_SX
//
//  Created by 何键键 on 16/3/2.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSTJYJViewController.h"
#import "NIDropDown.h"
#import "LSPT.h"
#import "takePhoto.h"
#import "AFNetworking.h"
#import "LSUploadModel.h"
#import "UIViewController+KeyboardCorver.h"

@interface LSTJYJViewController ()<NIDropDownDelegate>
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UITextField *btTextField;
@property (weak, nonatomic) IBOutlet UITextField *fileNameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *showImg;
@property (weak, nonatomic) IBOutlet UITextView *yjjyTextView;
@property (nonatomic, strong) NIDropDown *dropDown;
@property (nonatomic, strong) LSUploadModel *uploadModel;

@property (weak, nonatomic) IBOutlet UIButton *btnTitle;

@end

@implementation LSTJYJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.detailView.layer.cornerRadius = 5;
    self.detailView.layer.borderColor = LSGrayColor.CGColor;
    self.detailView.layer.borderWidth = 1;
    self.navigationItem.title = @"添加意见";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
   // [self addNotification];
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
    // Do any additional setup after loading the view from its nib.
}



//- (void)keyBoardChange:(NSNotification *)notification{
//    
//    NSDictionary *dict = notification.userInfo;
//    NSValue *aValue = [dict objectForKey:UIKeyboardFrameEndUserInfoKey];
//    NSNumber *animationTime = [dict objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"];
//    
//    CGRect keyboardRect = [aValue CGRectValue];
//    CGFloat keyHeight = (HEIGHT(self.view)-Y(searBar)-HEIGHT(searBar))-keyboardRect.size.height;
//    if(keyHeight<=0){
//        [UIView animateWithDuration:[animationTime doubleValue] animations:^{
//            self.view.frame =CGRectMake(0, keyHeight, WIDTH(self.view), HEIGHT(self.view));
//        } completion:^(BOOL finished) {
//        }];
//    }
//    
//}



//- (void)keyBoardDidHide:(NSNotification *)notification{
//    self.view.frame = CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view)); 
//}




- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnClick:(id)sender {
    //[self clearNotificationAndGesture];
    NSArray *arr = @[@"建议",@"表扬"];
    if(self.dropDown == nil) {
            CGFloat f = 80;
            self.dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :nil :@"down"];
            self.dropDown.delegate = self;
    }
    else {
        [self.dropDown hideDropDown:sender];
        [self rel];
    }
}
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    //[self addNotification];
    [self rel];
}

-(void)rel{
    self.dropDown = nil;
}



- (IBAction)xuanzeBtn:(id)sender {
    [takePhoto sharePicture:^(UIImage *image) {
        self.showImg.image = image;
    }];
}
- (IBAction)shangchuanBtn:(id)sender {
    
    if (!_showImg.image) {
        [MBProgressHUD showError:@"请选择文件"];
    }  else if (_fileNameTextField.text.length == 0) {
        [MBProgressHUD showError:@"请输入文件名"];
    } else {
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",self.fileNameTextField.text];
    params[@"type"] = @"pj";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json", @"text/html", @"text/json",@"text/javascript",@"text/plain",nil];
    [manager POST:fileUploadUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(self.showImg.image, 0) name:@"file" fileName:fileName mimeType:@"image/jpg"];
        NSLog(@"%@",self.showImg.image);
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSError *error = nil;
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&error];
        
        self.uploadModel = [LSUploadModel mj_objectWithKeyValues:responseData];
        
        NSLog(@"%@==%@",responseData,_uploadModel.path);
        [MBProgressHUD showSuccess:@"上传成功"];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络连接错误"];
        NSLog(@"Error: %@", error);
    }];
    }
}
- (IBAction)zancunBtn:(id)sender {
    if (self.btTextField.text.length == 0) {
        [MBProgressHUD showError:@"标题不能为空"];
    } else if ( [self.btnTitle.titleLabel.text isEqualToString:@"请选择意见类型"]) {
        [MBProgressHUD showError:@"请选择意见类型"];
    }else if (self.yjjyTextView.text.length == 0){
        [MBProgressHUD showError:@"内容不能为空"];
    }else {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"xsmc"] = self.fileNameTextField.text;
    params[@"bt"] = self.btTextField.text;
    params[@"nr"] = self.yjjyTextView.text;
        if ([self.btnTitle.titleLabel.text isEqualToString:@"表扬"]) {
            params[@"lx"] = @"1";
        } else if ([self.btnTitle.titleLabel.text isEqualToString:@"建议"]) {
            params[@"lx"] = @"2";
        }
    params[@"zt"] = @"1";
    NSString *lsid = [[NSUserDefaults standardUserDefaults]objectForKey:@"lsid"];
    params[@"lsid"] = lsid;
    params[@"wjmc"] = self.uploadModel.newname;
    params[@"path"] = self.uploadModel.path;
        NSLog(@"%@==",params);
    [LSHttpTool get:byjySaveUrl params:params success:^(id json) {
        NSLog(@"%@==%@",json,params);
            [MBProgressHUD showSuccess:@"暂存成功"];
            [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络连接失败"];
    }];
    }
}
- (IBAction)tijiaoBtn:(id)sender {
    if (self.btTextField.text.length == 0) {
        [MBProgressHUD showError:@"标题不能为空"];
    } else if ( [self.btnTitle.titleLabel.text isEqualToString:@"请选择意见类型"]) {
        [MBProgressHUD showError:@"请选择意见类型"];
    }else if (self.yjjyTextView.text.length == 0){
        [MBProgressHUD showError:@"内容不能为空"];
    }else {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"xsmc"] = self.fileNameTextField.text;
    params[@"bt"] = self.btTextField.text;
    params[@"nr"] = self.yjjyTextView.text;
        if ([self.btnTitle.titleLabel.text isEqualToString:@"表扬"]) {
            params[@"lx"] = @"1";
        } else if ([self.btnTitle.titleLabel.text isEqualToString:@"建议"]) {
            params[@"lx"] = @"2";
        }
    params[@"zt"] = @"2";
    NSString *lsid = [[NSUserDefaults standardUserDefaults]objectForKey:@"lsid"];
    params[@"lsid"] = lsid;
    params[@"wjmc"] = self.uploadModel.newname;
    params[@"path"] = self.uploadModel.path;
    [LSHttpTool get:byjySaveUrl params:params success:^(id json) {
        NSLog(@"%@",json);
            [MBProgressHUD showSuccess:@"提交成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
                 [MBProgressHUD showError:@"网络连接失败"];
    }];
    }
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
