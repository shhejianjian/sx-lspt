//
//  LSAjSegBViewController.m
//  LSPT_SX
//
//  Created by 何键键 on 16/2/26.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSAjSegBViewController.h"
#import "LSConst.h"

@interface LSAjSegBViewController ()
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *ssdwLabel;
@property (weak, nonatomic) IBOutlet UILabel *mcLabel;

@end

extern NSString *dwStr;
extern NSString *mcStr;
@implementation LSAjSegBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.detailView.layer.cornerRadius = 5;
    self.detailView.layer.borderWidth = 2;
    self.detailView.layer.borderColor = LSGlobalColor.CGColor;
    self.contentView.layer.cornerRadius = 5;
    _ssdwLabel.text = dwStr;
    _mcLabel.text = mcStr;
    // Do any additional setup after loading the view.
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
