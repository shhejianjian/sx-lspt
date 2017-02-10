//
//  LSyjCreateViewController.m
//  LSPT_SX
//
//  Created by 何键键 on 16/3/3.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSyjCreateViewController.h"
#import "NIDropDown.h"
#import "LSChangeTableViewCell.h"
#import "YTDatePick.h"
#import "LSFgAhInfo.h"
#import "LSYJNRModel.h"
#import "takePhoto.h"
#import "AFNetworking.h"
#import "LSUploadModel.h"
#import "LSPT.h"
#import "UIViewController+KeyboardCorver.h"

static NSString *ID=@"yjChangeCell";

@interface LSyjCreateViewController ()<NIDropDownDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UITableView *yjNewTableView;
@property (weak, nonatomic) IBOutlet UITextField *aimTextField;
@property (nonatomic, strong) NIDropDown *dropDown;
@property (nonatomic, copy) UIView *bgView;
@property (nonatomic, copy) NSString *deliver_timesString;
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;
@property (nonatomic, strong) NSMutableArray *ahInfoArr;
@property (nonatomic, strong) NSMutableArray *ahAllArr;
@property (nonatomic, strong) NSMutableArray *yjnrArr;
@property (nonatomic, strong) NSMutableArray *jynrArr;
@property (weak, nonatomic) IBOutlet UIImageView *showImg;
@property (nonatomic, strong) LSUploadModel *uploadModel;
@property (weak, nonatomic) IBOutlet UITextField *fileNameTextFiled;

@property (nonatomic, copy) NSString *ahqcStr;
@property (nonatomic, copy) NSString *ajbsStr;

@end

extern NSString *wsyjIdStr;

@implementation LSyjCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"新增预约";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
    self.detailView.layer.cornerRadius = 5;
    self.detailView.layer.masksToBounds = YES;
    self.detailView.layer.borderWidth = 1;
    self.detailView.layer.borderColor = LSGrayColor.CGColor;
    [self.yjNewTableView registerNib:[UINib nibWithNibName:@"LSChangeTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
    [self loadcl];
    [self loadAhInfo];
    [self createCancleNotifation];
    [self createNotifation];
    // Do any additional setup after loading the view from its nib.
}
- (void)loadcl {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"ajbs"] = self.ajbsStr;
    [LSHttpTool get:querySSCLUrl params:param success:^(id json) {
        self.yjnrArr = [LSYJNRModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
        LSBaseModel *baseModel=[LSBaseModel mj_objectWithKeyValues:json];
        if ([baseModel.status isEqualToString:@"fail"]) {
            [MBProgressHUD showError:@"此案没有借阅内容，不能借阅"];
        }
        [self.yjNewTableView reloadData];
        NSLog(@"===%@===%@",json,param);
    } failure:^(NSError *error) {
        
    }];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.yjnrArr.count;
}

- (LSChangeTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSChangeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[LSChangeTableViewCell alloc] init];
    }
    cell.YJNRsecond = self.yjnrArr[indexPath.row];
    [cell.selectBtn setImage:[UIImage imageNamed:@"gou"] forState:UIControlStateSelected];
    [cell.selectBtn addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectBtn.tag = indexPath.row;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)touchBtn: (UIButton *)sender  {
    LSYJNRModel *new = self.yjnrArr[sender.tag];
    sender.selected = !sender.selected;
    if (sender.selected) {
        new.isNew = YES;
        [self.jynrArr addObject:new.bt];
        NSLog(@"%@",self.jynrArr);
    } else {
        [self.jynrArr removeObject:new.bt];
        new.isNew = NO;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.aimTextField resignFirstResponder];
    [self.fileNameTextFiled resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)xuanzeRQ:(id)sender {
    [self.view endEditing:YES];
    [self createBackgroundView];
    [YTDatePick showPickWithMakeSure:^(id year, id month, id day) {
        [self.dateBtn setTitle:[NSString stringWithFormat:@"%@-%@-%@",year,month,day] forState:UIControlStateNormal];
        [self.dateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.deliver_timesString = [NSString stringWithFormat:@"%@%@%@",year,month,day];
    }];
}
/**
 *  选择器背景阴影
 */
-(void)createBackgroundView{
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.alpha = 0.3;
    _bgView.userInteractionEnabled = YES;
    [self.view addSubview:_bgView];
}
-(void)createCancleNotifation{
    if([self respondsToSelector:@selector(setCancleValueChanges)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setCancleValueChanges) name:@"setCancleValueChanges" object:nil];
    }
}
-(void)createNotifation{
    if([self respondsToSelector:@selector(setCancleValueChanges)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setCancleValueChanges) name:@"setInfor" object:nil];
    }
}
-(void)setCancleValueChanges {
    [_bgView removeFromSuperview];
}

- (IBAction)xuanzeAH:(id)sender {
    if(self.dropDown == nil) {
        CGFloat f = 120;
        self.dropDown = [[NIDropDown alloc]showDropDown:sender :&f :self.ahInfoArr :nil :@"down"];
        self.dropDown.delegate = self;
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
    [self loadcl];
    [self rel];
}

-(void)rel{
    self.dropDown = nil;
}
- (IBAction)chooseFile:(id)sender {
    [takePhoto sharePicture:^(UIImage *image) {
        self.showImg.image = image;
    }];
}
- (IBAction)shangchuanBtn:(id)sender {
    if (!_showImg.image || !_fileNameTextFiled.text ) {
        [MBProgressHUD showError:@"请选择文件并输入文件名"];
    }  else {
        NSMutableDictionary *params=[NSMutableDictionary dictionary];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg",self.fileNameTextFiled.text];
        params[@"type"] = @"wsyj";
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
    NSString *ns=[self.jynrArr componentsJoinedByString:@","];
    if (!_ajbsStr || _dateBtn.titleLabel.text.length == 0 || self.aimTextField.text.length == 0 || !ns) {
        [MBProgressHUD showError:@"请选择案号并补全信息"];
    } else {
    NSLog(@"%@===",ns);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = wsyjIdStr;
    params[@"ajbs"] = self.ajbsStr;
    params[@"ahqc"] = self.ahqcStr;
    //借阅内容
    params[@"jynr"] = ns;
    params[@"jymd"] = self.aimTextField.text;
    params[@"zt"] = @"1";
    NSString *lsid = [[NSUserDefaults standardUserDefaults]objectForKey:@"lsid"];
    params[@"lsid"] = lsid;
        params[@"jyrq"] = self.dateBtn.titleLabel.text;
    params[@"wjmc"] = self.uploadModel.newname;
    params[@"path"] = self.uploadModel.path;
    [LSHttpTool get:WSYJSaveOrUpdateUrl params:params success:^(id json) {
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
    NSString *ns=[self.jynrArr componentsJoinedByString:@","];
    if (!_ajbsStr || _dateBtn.titleLabel.text.length == 0 || self.aimTextField.text.length == 0 || !ns) {
        [MBProgressHUD showError:@"请选择案号并补全信息"];
    } else {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = wsyjIdStr;
    params[@"ajbs"] = self.ajbsStr;
    params[@"ahqc"] = self.ahqcStr;
    //借阅内容
    params[@"jynr"] = ns;
    params[@"jymd"] = self.aimTextField.text;
    params[@"zt"] = @"2";
    NSString *lsid = [[NSUserDefaults standardUserDefaults]objectForKey:@"lsid"];
    params[@"lsid"] = lsid;
        params[@"jyrq"] = self.dateBtn.titleLabel.text;
    params[@"wjmc"] = self.uploadModel.newname;
    params[@"path"] = self.uploadModel.path;
    [LSHttpTool get:WSYJSaveOrUpdateUrl params:params success:^(id json) {
        NSLog(@"%@",json);
        LSBaseModel *baseModel=[LSBaseModel mj_objectWithKeyValues:json];
        if ([baseModel.status isEqualToString:@"success"]) {
            [MBProgressHUD showSuccess:@"提交成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showError:@"提交失败"];
        }
        
    } failure:^(NSError *error) {
        
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

- (NSMutableArray *)ahInfoArr {
	if(_ahInfoArr == nil) {
		_ahInfoArr = [[NSMutableArray alloc] init];
	}
	return _ahInfoArr;
}

- (NSMutableArray *)ahAllArr {
	if(_ahAllArr == nil) {
		_ahAllArr = [[NSMutableArray alloc] init];
	}
	return _ahAllArr;
}

- (NSMutableArray *)yjnrArr {
	if(_yjnrArr == nil) {
		_yjnrArr = [[NSMutableArray alloc] init];
	}
	return _yjnrArr;
}

- (NSMutableArray *)jynrArr {
	if(_jynrArr == nil) {
		_jynrArr = [[NSMutableArray alloc] init];
	}
	return _jynrArr;
}

@end
