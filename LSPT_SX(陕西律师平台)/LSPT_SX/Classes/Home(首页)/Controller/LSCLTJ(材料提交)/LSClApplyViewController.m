//
//  LSClApplyViewController.m
//  LSPT_SX
//
//  Created by 何键键 on 16/2/24.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSClApplyViewController.h"
#import "NIDropDown.h"
#import "LSPT.h"
#import "LSFgAhInfo.h"
#import "LSCLType.h"
#import "takePhoto.h"
#import "AFNetworking.h"
#import "LSUploadModel.h"
#import "UIViewController+KeyboardCorver.h"

@interface LSClApplyViewController ()<NIDropDownDelegate>
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (nonatomic, strong) NIDropDown *dropDown;

@property (nonatomic, strong) NSMutableArray *ahInfoArr;
@property (nonatomic, strong) NSMutableArray *ahAllArr;
@property (nonatomic, strong) NSMutableArray *typeAllArr;
@property (weak, nonatomic) IBOutlet UITextField *fileTextField;
@property (weak, nonatomic) IBOutlet UIButton *anBtn;
@property (weak, nonatomic) IBOutlet UIButton *cailiaoBtn;

@property (nonatomic, strong) NSMutableArray *typeArr;
@property (weak, nonatomic) IBOutlet UIButton *shangchuanBtn;

@property (weak, nonatomic) IBOutlet UIImageView *showImg;
@property (nonatomic, strong) LSUploadModel *uploadModel;

@property (nonatomic, copy) NSString *ajbsStr;
@property (nonatomic, copy) NSString *ahqcStr;
@property (nonatomic, copy) NSString *mlidStr;
@property (nonatomic, copy) NSString *mlmcStr;
@end

@implementation LSClApplyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"新增证据";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
    self.detailView.layer.cornerRadius = 5;
    self.detailView.layer.masksToBounds = YES;
    self.detailView.layer.borderWidth = 1;
    self.detailView.layer.borderColor = LSGrayColor.CGColor;
    NSLog(@"self%@==%@",self.ahqcStr,self.mlidStr);
    [self loadAhInfo];
    [self loadType];
    NSLog(@"self%@==%@",self.ahqcStr,self.mlidStr);
    //    self.zancunBtn.userInteractionEnabled = NO;
    //    self.tijiaoBtn.userInteractionEnabled = NO;
    // Do any additional setup after loading the view from its nib.
}

- (void)loadAhInfo {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *sfzjhm = [[NSUserDefaults standardUserDefaults]objectForKey:@"sfzjhm"];
    params[@"sfzjhm"] = sfzjhm;
    [LSHttpTool get:GetAhInfoUrl params:params success:^(id json) {
        NSArray *arr = [LSFgAhInfo mj_objectArrayWithKeyValuesArray:json[@"data"][@"result"]];
        for (LSFgAhInfo *ah in arr) {
            [self.ahInfoArr addObject:ah.ahqc];
            [self.ahAllArr addObject:ah];
        }
        NSLog(@"%@==",json);
    } failure:^(NSError *error) {
        
    }];
}

- (void)loadType {
    [LSHttpTool get:GetClmcInfoUrl params:nil success:^(id json) {
        NSArray *arr = [LSCLType mj_objectArrayWithKeyValuesArray:json[@"data"][@"result"]];
        for (LSCLType *cltype in arr) {
            [self.typeArr addObject:cltype.dmms];
            [self.typeAllArr addObject:cltype];
        }
        NSLog(@"%@==",json);
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)xuanzeBtn:(id)sender {
    [takePhoto sharePicture:^(UIImage *image) {
        self.showImg.image = image;
    }];
    
}
- (IBAction)shangchuanBtn:(id)sender {
    if (!_showImg.image || _fileTextField.text.length == 0 ) {
        [MBProgressHUD showError:@"请选择文件并输入文件名"];
    }  else {
        NSMutableDictionary *params=[NSMutableDictionary dictionary];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg",self.fileTextField.text];
        params[@"type"] = @"xxtj";
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
            
            NSLog(@"上传成功=%@==%@",responseData,_uploadModel.path);
            [MBProgressHUD showSuccess:@"上传成功"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD showError:@"网络连接错误"];
            NSLog(@"Error: %@", error);
        }];
    }
}

- (IBAction)zancunBtn:(id)sender {
    
    if ([self.anBtn.titleLabel.text isEqualToString:@"请选择案号"]) {
        [MBProgressHUD showError:@"请选择案号"];
    } else if (!self.uploadModel.path || self.fileTextField.text.length == 0) {
        [MBProgressHUD showError:@"请选择文件并输入文件名并上传"];
    } else if ([self.cailiaoBtn.titleLabel.text isEqualToString:@"请选择材料类型"]) {
        [MBProgressHUD showError:@"请选择材料类型"];
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"ajbs"] = self.ajbsStr;
        params[@"ahqc"] = self.ahqcStr;
        params[@"xsmc"] = self.uploadModel.originalfileName;
        params[@"wjmc"] = self.uploadModel.newname;
        params[@"wjlj"] = self.uploadModel.path;
        NSString *lsid = [[NSUserDefaults standardUserDefaults]objectForKey:@"lsid"];
        params[@"lsid"] = lsid;
        params[@"mlid"] = self.mlidStr;
        params[@"mlmc"] = self.mlmcStr;
        params[@"zt"] = @"1";
        [LSHttpTool get:SaveCLTJUrl params:params success:^(id json) {
            NSLog(@"%@",json);
            LSBaseModel *baseModel=[LSBaseModel mj_objectWithKeyValues:json];
            if ([baseModel.status isEqualToString:@"success"]) {
                [MBProgressHUD showSuccess:@"暂存成功"];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [MBProgressHUD showError:@"暂存失败"];
            }
            
        } failure:^(NSError *error) {
            
        }];
    }
    
}
- (IBAction)tijiaoBtn:(id)sender {
    if ([self.anBtn.titleLabel.text isEqualToString:@"请选择案号"]) {
        [MBProgressHUD showError:@"请选择案号"];
    } else if (!self.uploadModel.path || self.fileTextField.text.length == 0) {
        [MBProgressHUD showError:@"请选择文件并输入文件名并上传"];
    } else if ([self.cailiaoBtn.titleLabel.text isEqualToString:@"请选择材料类型"]) {
        [MBProgressHUD showError:@"请选择材料类型"];
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"ajbs"] = self.ajbsStr;
        params[@"ahqc"] = self.ahqcStr;
        params[@"xsmc"] = self.uploadModel.originalfileName;
        params[@"wjmc"] = self.uploadModel.newname;
        params[@"wjlj"] = self.uploadModel.path;
        NSString *lsid = [[NSUserDefaults standardUserDefaults]objectForKey:@"lsid"];
        params[@"lsid"] = lsid;
        params[@"mlid"] = self.mlidStr;
        params[@"mlmc"] = self.mlmcStr;
        params[@"zt"] = @"2";
        [LSHttpTool get:SaveCLTJUrl params:params success:^(id json) {
            NSLog(@"%@",json);
            LSBaseModel *baseModel=[LSBaseModel mj_objectWithKeyValues:json];
            if ([baseModel.status isEqualToString:@"success"]) {
                [MBProgressHUD showSuccess:@"提交成功"];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [MBProgressHUD showError:@"提交失败"];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"网络连接失败"];
        }];
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.fileTextField  resignFirstResponder];
}


- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
#pragma mark -- NIDropDownDelegate


- (IBAction)anHaoSelcetClick:(id)sender {
    if(self.dropDown == nil) {
        CGFloat f = 160;
        self.dropDown = [[NIDropDown alloc]showDropDown:sender :&f :self.ahInfoArr :nil :@"down"];
        self.dropDown.delegate = self;
    }
    else {
        [self.dropDown hideDropDown:sender];
        [self rel];
    }
    
}

- (IBAction)typeSelectClick:(id)sender {
    if(self.dropDown == nil) {
        if (self.ahAllArr != nil || self.typeAllArr != nil) {
            CGFloat f = 120;
            self.dropDown = [[NIDropDown alloc]showDropDown:sender :&f :self.typeArr :nil :@"down"];
            self.dropDown.delegate = self;
        }
    }
    else {
        [self.dropDown hideDropDown:sender];
        [self rel];
    }
    
}
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    LSFgAhInfo *ahInfo = self.ahAllArr[self.dropDown.index];
    self.ahqcStr = ahInfo.ahqc;
    self.ajbsStr = ahInfo.ajbs;
    LSCLType *type = self.typeAllArr[self.dropDown.index];
    self.mlidStr = type.dm;
    self.mlmcStr = type.dmms;
    NSLog(@"self%@==%@",self.ahqcStr,self.mlidStr);
    
    [self rel];
}

-(void)rel{
    self.dropDown = nil;
}

- (NSMutableArray *)ahInfoArr {
    if(_ahInfoArr == nil) {
        _ahInfoArr = [[NSMutableArray alloc] init];
    }
    return _ahInfoArr;
}

- (NSMutableArray *)typeArr {
    if(_typeArr == nil) {
        _typeArr = [[NSMutableArray alloc] init];
    }
    return _typeArr;
}

- (NSMutableArray *)ahAllArr {
    if(_ahAllArr == nil) {
        _ahAllArr = [[NSMutableArray alloc] init];
    }
    return _ahAllArr;
}

- (NSMutableArray *)typeAllArr {
    if(_typeAllArr == nil) {
        _typeAllArr = [[NSMutableArray alloc] init];
    }
    return _typeAllArr;
}

@end
