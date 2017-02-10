//
//  LSUpSSCLViewController.m
//  LSPT_SX
//
//  Created by 何键键 on 16/3/3.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSUpSSCLViewController.h"
#import "NIDropDown.h"
#import "LSPT.h"
#import "takePhoto.h"
#import "AFNetworking.h"
#import "LSUploadModel.h"
#import "LSCLType.h"
#import "LSWSLA.h"
@interface LSUpSSCLViewController ()<NIDropDownDelegate>

@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UIButton *ssclBtn;
@property (weak, nonatomic) IBOutlet UITextField *fileNameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *showImg;
@property (nonatomic, strong) NIDropDown *dropDown;
@property (nonatomic, strong) LSUploadModel *uploadModel;
@property (nonatomic, strong) NSMutableArray *typeArr;
@property (nonatomic, strong) NSMutableArray *typeAllArr;

@property (nonatomic, copy) NSString *mlidStr;
@property (nonatomic, copy) NSString *mlmcStr;
@end
extern LSWSLA *mWsla;
@implementation LSUpSSCLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"诉讼材料";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
    self.detailView.layer.cornerRadius = 5;
    self.detailView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.detailView.layer.borderWidth = 1;
    // Do any additional setup after loading the view from its nib.
    [self loadSSCL];
}

- (void)loadSSCL {
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

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.fileNameTextField  resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)ssclBtn:(id)sender {
    if(self.dropDown == nil) {
        
            CGFloat f = 250;
            self.dropDown = [[NIDropDown alloc]showDropDown:sender :&f :self.typeArr :nil :@"down"];
            self.dropDown.delegate = self;
        
    }
    else {
        [self.dropDown hideDropDown:sender];
        [self rel];
    }
    
}
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    LSCLType *type = self.typeAllArr[self.dropDown.index];
    self.mlidStr = type.dm;
    self.mlmcStr = type.dmms;
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
    if (!_showImg.image || _fileNameTextField.text.length == 0 ) {
        [MBProgressHUD showError:@"请选择文件并输入文件名"];
    }  else {
        NSMutableDictionary *params=[NSMutableDictionary dictionary];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg",self.fileNameTextField.text];
        params[@"type"] = @"saSscl";
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
- (IBAction)saveBtn:(id)sender {
    
    if (!self.mlidStr || self.fileNameTextField.text.length == 0 || !self.showImg.image) {
        [MBProgressHUD showError:@"请选择文件并上传"];
    } else {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"ajbs"] = mWsla.ajbs;
    params[@"xsmc"] = _fileNameTextField.text;
    params[@"wjmc"] = self.uploadModel.newname;
    params[@"wjlj"] = self.uploadModel.path;
    NSString *lsid = [[NSUserDefaults standardUserDefaults]objectForKey:@"lsid"];
    params[@"lsid"] = lsid;
    params[@"mlid"] = self.mlidStr;
    params[@"mlmc"] = self.mlmcStr;
    params[@"zt"] = @"1";
    NSLog(@"param%@",params);
    [LSHttpTool post:SaveSsclUrl params:params success:^(id json) {
        NSLog(@"json%@==%@",params,json);
        LSBaseModel *baseModel=[LSBaseModel mj_objectWithKeyValues:json];
        if ([baseModel.status isEqualToString:@"success"]) {
            [MBProgressHUD showSuccess:@"文件保存成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showError:@"文件保存失败"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络连接错误"];
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


- (NSMutableArray *)typeArr {
	if(_typeArr == nil) {
		_typeArr = [[NSMutableArray alloc] init];
	}
	return _typeArr;
}

- (NSMutableArray *)typeAllArr {
	if(_typeAllArr == nil) {
		_typeAllArr = [[NSMutableArray alloc] init];
	}
	return _typeAllArr;
}

@end
