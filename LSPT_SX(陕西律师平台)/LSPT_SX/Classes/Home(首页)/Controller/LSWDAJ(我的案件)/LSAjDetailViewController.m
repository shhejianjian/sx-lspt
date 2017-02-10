//
//  LSAjDetailViewController.m
//  LSPT_SX
//
//  Created by 何键键 on 16/2/26.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSAjDetailViewController.h"
#import "LSAjSegAViewController.h"
#import "LSAjSegBViewController.h"
#import "LSAjSegCViewController.h"
#import "SegmentTapV.h"
#import "FlipTableView.h"
#import "LSWDAJModel.h"
#import "LSAjDetail.h"
#import "LSPT.h"

#define ScreeFrame [UIScreen mainScreen].bounds

@interface LSAjDetailViewController ()<SegmentTapViewDelegate,FlipTableViewDelegate>
@property (nonatomic, strong)SegmentTapV *segment;
@property (nonatomic, strong)FlipTableView *flipView;
@property (strong, nonatomic) NSMutableArray *controllsArray;
@property (nonatomic, strong) NSMutableArray *ajDetailArr;


@end



NSString *ajzhstr;
NSString *ajlystr;
NSString *larstr;
NSString *sarqstr;
NSString *larqstr;
NSString *lalystr;
NSString *labmstr;
NSString *lbstr;
NSString *yjfstr;
NSString *bdestr;

NSString *dwStr;
NSString *mcStr;

@implementation LSAjDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"案件列表";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"titile_back" highImage:@"titile_press_back" title:@"返回"];
    [self initSegment];
    [self initFlipTableView];

    ajzhstr = _wdajDetail.ahqc;
    ajlystr = _wdajDetail.ajlymc;
    larstr = _wdajDetail.larmc;
    sarqstr = _wdajDetail.szrq;
    larqstr = _wdajDetail.larq;
    lalystr = _wdajDetail.laaymc;
    lbstr = _wdajDetail.ajlbmc;
    yjfstr = _wdajDetail.gsbd;
    bdestr = _wdajDetail.gsbd;
    
    [self loadDetail];
    // Do any additional setup after loading the view from its nib.
}


- (void)loadDetail {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"ajbs"] = _wdajDetail.ajbs;
    [LSHttpTool get:WDAJDetailUrl params:param success:^(id json) {
        self.ajDetailArr = [LSAjDetail mj_objectArrayWithKeyValuesArray:json[@"data"][@"dsrList"]];
        for (LSAjDetail *ajDetail in self.ajDetailArr) {
            dwStr = ajDetail.ssdwmc;
            mcStr = ajDetail.mc;
        }
        NSLog(@"==%@==",json);
    } failure:^(NSError *error) {
        
    }];
}


- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)initSegment{
    self.segment = [[SegmentTapV alloc] initWithFrame:CGRectMake(0, 64, ScreeFrame.size.width, 40) withDataArray:[NSArray arrayWithObjects:@"基本信息",@"当事人",@"诉讼材料", nil] withFont:15];
    self.segment.delegate = self;
    [self.view addSubview:self.segment];
}
-(void)initFlipTableView{
    if (!self.controllsArray) {
        self.controllsArray = [[NSMutableArray alloc] init];
    }
    
    LSAjSegAViewController *v1 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"first"];
    LSAjSegBViewController *v2 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"second"];
    LSAjSegCViewController *v3 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"third"];
    
    
    [self.controllsArray addObject:v1];
    [self.controllsArray addObject:v2];
    [self.controllsArray addObject:v3];
    
    self.flipView = [[FlipTableView alloc] initWithFrame:CGRectMake(0, 104, ScreeFrame.size.width, ScreeFrame.size.height- 104) withArray:_controllsArray];
    self.flipView.delegate = self;
    [self.view addSubview:self.flipView];
}
#pragma mark -------- select Index
-(void)selectedIndex:(NSInteger)index
{
    NSLog(@"%ld",(long)index);
    [self.flipView selectIndex:index];
    
}
-(void)scrollChangeToIndex:(NSInteger)index
{
    NSLog(@"%ld",(long)index);
    [self.segment selectIndex:index];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSMutableArray *)ajDetailArr {
	if(_ajDetailArr == nil) {
		_ajDetailArr = [[NSMutableArray alloc] init];
	}
	return _ajDetailArr;
}


@end
