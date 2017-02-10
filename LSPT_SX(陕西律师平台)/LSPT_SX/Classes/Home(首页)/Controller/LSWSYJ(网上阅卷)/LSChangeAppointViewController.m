//
//  LSChangeAppointViewController.m
//  LSPT_SX
//
//  Created by 何键键 on 16/2/25.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSChangeAppointViewController.h"
#import "NIDropDown.h"
#import "LSChangeTableViewCell.h"
#import "YTDatePick.h"
#import "LSFgAhInfo.h"
#import "LSYJNRModel.h"
#import "LSPT.h"
#import "LSWSYJViewController.h"
static NSString *ID=@"yjChangeCell";
@interface LSChangeAppointViewController ()<NIDropDownDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (nonatomic, strong) NIDropDown *dropDown;
@property (weak, nonatomic) IBOutlet UITextField *aimTextField;
@property (weak, nonatomic) IBOutlet UITableView *changeTableView;

@property (nonatomic, copy) UIView *bgView;
@property (nonatomic, copy) NSString *deliver_timesString;
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;

@property (nonatomic, strong) NSMutableArray *yjnrArr;
@property (nonatomic, strong) NSMutableArray *ahInfoArr;
@property (nonatomic, strong) NSMutableArray *ahAllArr;
@property (nonatomic, strong) NSMutableArray *jynrArr;
@property (weak, nonatomic) IBOutlet UIButton *ahBtnTitle;
@property (weak, nonatomic) IBOutlet UIButton *xzrqBtnTitle;

@property (nonatomic, copy) NSString *ahqcStr;
@property (nonatomic, copy) NSString *ajbsStr;
@property (nonatomic, copy) NSString *nrStr;
@end
extern NSString *wsyjAhqcStr;
extern NSString *wsyjIdStr;
extern NSString *wsyjjymdStr;
extern NSString *wsyjjysjStr;
extern NSString *wsyjajbsStr;
extern NSString *wsyjjynrStr;

@implementation LSChangeAppointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改预约";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
    self.detailView.layer.cornerRadius = 5;
    self.detailView.layer.masksToBounds = YES;
    self.detailView.layer.borderWidth = 1;
    self.detailView.layer.borderColor = LSGrayColor.CGColor;
    [self.changeTableView registerNib:[UINib nibWithNibName:@"LSChangeTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
    
    [self.ahBtnTitle setTitle:wsyjAhqcStr forState:UIControlStateNormal];
    self.aimTextField.text = wsyjjymdStr;
    [self.xzrqBtnTitle setTitle:wsyjjysjStr forState:UIControlStateNormal];
    
    NSArray *arr = [wsyjjynrStr componentsSeparatedByString:@","];
    for (int i = 0; i < arr.count; i++) {
        [self.jynrArr addObject:arr[i]];
    }
    [self createCancleNotifation];
    [self createNotifation];
    [self loadAhInfo];
    [self loadcl];
    NSLog(@"====%@===",self.jynrArr);

    // Do any additional setup after loading the view from its nib.
}

- (void)loadcl {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (self.ajbsStr) {
        param[@"ajbs"] = self.ajbsStr;
    } else {
        param[@"ajbs"] = wsyjajbsStr;
    }
    [LSHttpTool get:querySSCLUrl params:param success:^(id json) {
        self.yjnrArr = [LSYJNRModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
        LSBaseModel *baseModel=[LSBaseModel mj_objectWithKeyValues:json];
        if ([baseModel.status isEqualToString:@"fail"]) {
            [MBProgressHUD showError:@"此案号下无借阅内容"];
        }
        [self.changeTableView reloadData];
        NSLog(@"===%@===%@",json,param);
    } failure:^(NSError *error) {
        
    }];
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
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)zancunBtn:(id)sender {
    
        NSString *ns=[self.jynrArr componentsJoinedByString:@","];
        NSLog(@"%@===",ns);
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"id"] = wsyjIdStr;
    if (self.ajbsStr) {
        params[@"ajbs"] = self.ajbsStr;
    } else {
        params[@"ajbs"] = wsyjajbsStr;
    }
    if (self.ahqcStr) {
        params[@"ahqc"] = self.ahqcStr;
    } else {
        params[@"ahqc"] = wsyjAhqcStr;
    }
    
        //借阅内容
        params[@"jynr"] = ns;
        params[@"jymd"] = self.aimTextField.text;
        params[@"zt"] = @"1";
        NSString *lsid = [[NSUserDefaults standardUserDefaults]objectForKey:@"lsid"];
        params[@"lsid"] = lsid;
        params[@"jyrq"] = self.dateBtn.titleLabel.text;
        NSLog(@"%@<>",params);
        [LSHttpTool get:WSYJSaveOrUpdateUrl params:params success:^(id json) {
            NSLog(@"%@",json);
            LSBaseModel *baseModel=[LSBaseModel mj_objectWithKeyValues:json];
            if ([baseModel.status isEqualToString:@"success"]) {
                [MBProgressHUD showSuccess:@"暂存成功"];
                [self jumpToVC];
            } else {
                [MBProgressHUD showError:@"暂存失败"];
            }
        } failure:^(NSError *error) {
        }];
    
}

- (IBAction)tijiaoBtn:(id)sender {
    
        NSString *ns=[self.jynrArr componentsJoinedByString:@","];
        NSLog(@"%@===",ns);
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"id"] = wsyjIdStr;
    if (self.ajbsStr) {
        params[@"ajbs"] = self.ajbsStr;
    } else {
        params[@"ajbs"] = wsyjajbsStr;
    }
    if (self.ahqcStr) {
        params[@"ahqc"] = self.ahqcStr;
    } else {
        params[@"ahqc"] = wsyjAhqcStr;
    }
        //借阅内容
        params[@"jynr"] = ns;
        params[@"jymd"] = self.aimTextField.text;
        params[@"zt"] = @"2";
        NSString *lsid = [[NSUserDefaults standardUserDefaults]objectForKey:@"lsid"];
        params[@"lsid"] = lsid;
    params[@"jyrq"] = self.dateBtn.titleLabel.text;
        NSLog(@"%@===",params);
        [LSHttpTool get:WSYJSaveOrUpdateUrl params:params success:^(id json) {
            NSLog(@"%@",json);
            LSBaseModel *baseModel=[LSBaseModel mj_objectWithKeyValues:json];
            if ([baseModel.status isEqualToString:@"success"]) {
                [MBProgressHUD showSuccess:@"提交成功"];
                [self jumpToVC];
            } else {
                [MBProgressHUD showError:@"提交失败"];
            }
        } failure:^(NSError *error) {
        }];
    
}


- (void)jumpToVC {
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[LSWSYJViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
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
    cell.YJNR = self.yjnrArr[indexPath.row];
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
}


#pragma mark -- 下拉列表
- (IBAction)SelectClick:(id)sender {
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- 时间选择器
- (IBAction)addDatePopView:(id)sender {
    [self.view endEditing:YES];
    [self createBackgroundView];
    [YTDatePick showPickWithMakeSure:^(id year, id month, id day) {
        [self.dateBtn setTitle:[NSString stringWithFormat:@"%@-%@-%@",year,month,day] forState:UIControlStateNormal];
        [self.dateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //        self.delivery_time.text =[NSString stringWithFormat:@"%@年%@月%@日",year,month,day];
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
