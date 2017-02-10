
//
//  LSLitigantDetailViewController.m
//  LSPT_SX
//
//  Created by 谢琰 on 16/2/25.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSLitigantDetailViewController.h"
#import "LSWSLADetailCell.h"
#import "LSLitigantListViewControlle.h"
#import "LSLitigant.h"
#import "LSWSLA.h"
#import "LSSsdwInfo.h"
#import "LSGjInfo.h"
#import "LSWhcdInfo.h"
#import "LSZzmmInfo.h"
#import "LSMzInfo.h"
#import "LSPT.h"
@interface LSLitigantDetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (nonatomic, strong) NSMutableArray *SSDWs;
@property (nonatomic, strong) NSMutableArray *GJs;
@property (nonatomic, strong) NSMutableArray *WHCDs;
@property (nonatomic, strong) NSMutableArray *ZZMMs;
@property (nonatomic, strong) NSMutableArray *MZs;
@property (nonatomic, copy) NSString *SsdwStr;
@property (nonatomic, copy) NSString *GjStr;
@property (nonatomic, copy) NSString *WhcdStr;
@property (nonatomic, copy) NSString *ZzmmStr;
@property (nonatomic, copy) NSString *MzStr;

@end

@implementation LSLitigantDetailViewController
extern LSWSLA *mWsla;
static NSString *ID = @"LSWSLADetailCell";

- (NSMutableArray *)GJs
{
    if (!_GJs) {
        _GJs = [NSMutableArray array];
    }
    return _GJs;
}
- (NSMutableArray *)WHCDs
{
    if (!_WHCDs) {
        _WHCDs = [NSMutableArray array];
    }
    return _WHCDs;
}

- (NSMutableArray *)SSDWs
{
    if (!_SSDWs) {
        _SSDWs = [NSMutableArray array];
    }
    return _SSDWs;
}


- (NSMutableArray *)MZs
{
    if (!_MZs) {
        _MZs = [NSMutableArray array];
    }
    return _MZs;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"当事人详情";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(delete) image:@"btn_login" highImage:@"btn_press_login" title:@"删除"];
    [self.detailTableView registerNib:[UINib nibWithNibName:@"LSWSLADetailCell" bundle:nil] forCellReuseIdentifier:ID];
    self.detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.detailTableView.bounces = NO;
    [self loadData];
    [self.detailTableView reloadData];
}
- (void)viewWillAppear:(BOOL)animated {
    [self.detailTableView reloadData];
}
- (void)loadData
{
    //诉讼地位
    NSMutableDictionary *ssdwParams = [NSMutableDictionary dictionary];
    ssdwParams[@"ajbs"] = mWsla.ajbs;
    [LSHttpTool get:GetSsdwInfoUrl params:ssdwParams success:^(id json) {
        self.SSDWs = [LSSsdwInfo mj_objectArrayWithKeyValuesArray:json[@"data"][@"result"]];
        for (LSSsdwInfo *ssdw in self.SSDWs) {
            if ([ssdw.dm isEqualToString:self.litigiant.ssdw]) {
                self.SsdwStr = ssdw.dmms;
                [self.detailTableView reloadData];
            }
        }
        NSLog(@"GetSsdwInfoUrl %@--%@",ssdwParams,json);
    } failure:^(NSError *error) {
        NSLog(@"GetSsdwInfoUrl --%@",ssdwParams);
        [MBProgressHUD showError:@"xxxx网络不稳定,请稍后再试"];
    }];
    //国籍
    [LSHttpTool get:GetWhcdInfoUrl params:nil success:^(id json) {
        self.WHCDs = [LSWhcdInfo mj_objectArrayWithKeyValuesArray:json[@"data"][@"result"]];
        for (LSGjInfo *Gj in self.GJs) {
            if ([Gj.dm isEqualToString:self.litigiant.gj]) {
                self.GjStr = Gj.dmms;
                [self.detailTableView reloadData];
            }
        }
        NSLog(@"GetWhcdInfoUrl --%@",json);
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showError:@"网络不稳定,请稍后再试"];
    }];
 //文化程度
    [LSHttpTool get:GetGjInfoUrl params:nil success:^(id json) {
        self.GJs = [LSGjInfo mj_objectArrayWithKeyValuesArray:json[@"data"][@"result"]];
        
        for (LSWhcdInfo *Whcd in self.WHCDs) {
            if ([Whcd.dm isEqualToString:_litigiant.whcd]) {
                self.WhcdStr = Whcd.dmms;
                [self.detailTableView reloadData];
            }
            
        }
        NSLog(@"GetGjInfoUrl --%@",json);
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不稳定,请稍后再试"];
    }];
//民族
    [LSHttpTool get:GetMzInfoUrl params:nil success:^(id json) {
        self.MZs = [LSMzInfo mj_objectArrayWithKeyValuesArray:json[@"data"][@"result"]];
        for (LSMzInfo *Mz in self.MZs) {
            if ([Mz.dm isEqualToString:self.litigiant.mz]) {
                self.MzStr = Mz.dmms;
                [self.detailTableView reloadData];

            }
        }

        NSLog(@"GetMzInfoUrl --%@",json);
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showError:@"网络不稳定,请稍后再试"];
    }];
//政治面貌
    [LSHttpTool get:GetZzmmInfoUrl params:nil success:^(id json) {
        self.ZZMMs = [LSWhcdInfo mj_objectArrayWithKeyValuesArray:json[@"data"][@"result"]];
        
        for (LSZzmmInfo *Zzmm in self.ZZMMs) {
            if ([Zzmm.dm isEqualToString:self.litigiant.zzmm]) {
                self.ZzmmStr = Zzmm.dmms;
                [self.detailTableView reloadData];
            }
        }
        NSLog(@"GetZzmmInfoUrl --%@",json);
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不稳定,请稍后再试"];
    }];

}
- (void)delete
{
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"您确定要删除当事人吗？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self deleteLitigant];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)deleteLitigant
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
#warning id 后面要换
        params[@"id"] = self.litigiant.ID;
    [LSHttpTool get:DelDsrUrl params:params success:^(id json) {
        
        LSBaseModel *baseModel=[LSBaseModel mj_objectWithKeyValues:json];
        if ([baseModel.status isEqualToString:@"success"]) {
            [MBProgressHUD showSuccess:@"删除成功"];
            [self jumpToVC];
        } else {
            [MBProgressHUD showError:@"删除失败"];
        }

    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不稳定,请稍后再试"];
    }];
    
}
- (void)jumpToVC {
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[LSLitigantListViewControlle class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
}

#pragma mark - Table view  delegate

- (LSWSLADetailCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSWSLADetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[LSWSLADetailCell alloc]init];
    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.categoryLabel.backgroundColor = LSBlueColor;
    cell.categoryLabel.font = [UIFont systemFontOfSize:15];
    cell.categoryDetailLabel.font = [UIFont systemFontOfSize:15];
    if (indexPath.row == 0) {
        cell.categoryLabel.text = @"诉讼地位";
        cell.categoryDetailLabel.text = self.SsdwStr;
           }
    else if (indexPath.row == 1) {
        cell.categoryLabel.text = @"当事人类型";
        if ([self.litigiant.lxbm isEqualToString:@"1"]) {
            cell.categoryDetailLabel.text = @"自然人";
        }else if([self.litigiant.lxbm isEqualToString:@"2"]){
            cell.categoryDetailLabel.text = @"法人组织";
        }else if([self.litigiant.lxbm isEqualToString:@"3"]){
            cell.categoryDetailLabel.text = @"非法人组织";
        }

    }
    else if (indexPath.row == 2) {
        
        cell.categoryLabel.text = @"当事人名称";
        cell.categoryDetailLabel.text = self.litigiant.mc;
        
    }
    else if (indexPath.row == 3) {
        
        cell.categoryLabel.text = @"单位名称";
        cell.categoryDetailLabel.text = self.litigiant.dwmc;
        
    }
    else if (indexPath.row == 4) {
        
        cell.categoryLabel.text = @"组织机构代码";
        cell.categoryDetailLabel.text = self.litigiant.zzjgdm;
        
    } else if (indexPath.row == 5) {
        
        cell.categoryLabel.text = @"联系电话";
        cell.categoryDetailLabel.text = self.litigiant.dhhm;
        
    }
    else if (indexPath.row == 6) {
        
        cell.categoryLabel.text = @"国籍";
        cell.categoryDetailLabel.text = self.GjStr;
            }
    else if (indexPath.row == 7) {
        
        cell.categoryLabel.text = @"证件号码";
        cell.categoryDetailLabel.text = self.litigiant.sfzhm;
    }
    else if (indexPath.row == 8) {
        
        cell.categoryLabel.text = @"民族";
        cell.categoryDetailLabel.text = self.MzStr;

           }
    else if (indexPath.row == 9) {
        
        cell.categoryLabel.text = @"文化程度";
        cell.categoryDetailLabel.text = self.WhcdStr;

        
    }
    else if (indexPath.row == 10) {
        
        cell.categoryLabel.text = @"法人姓名";
        cell.categoryDetailLabel.text = self.litigiant.frxm;
        
    }
    else if (indexPath.row == 11) {
        
        cell.categoryLabel.text = @"政治面貌";
        cell.categoryDetailLabel.text = self.ZzmmStr;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        return 40.0f;
}

@end
