
//
//  LSAjSegAViewController.m
//  LSPT_SX
//
//  Created by 何键键 on 16/2/26.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSAjSegAViewController.h"
#import "LSConst.h"

@interface LSAjSegAViewController ()
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *ajzhLabel;
@property (weak, nonatomic) IBOutlet UILabel *ajlyLabel;
@property (weak, nonatomic) IBOutlet UILabel *larLabel;
@property (weak, nonatomic) IBOutlet UILabel *sarqLabel;
@property (weak, nonatomic) IBOutlet UILabel *larqLabel;
@property (weak, nonatomic) IBOutlet UILabel *lalyLabel;
@property (weak, nonatomic) IBOutlet UILabel *labmLabel;
@property (weak, nonatomic) IBOutlet UILabel *lbLabel;
@property (weak, nonatomic) IBOutlet UILabel *yjfLabel;
@property (weak, nonatomic) IBOutlet UILabel *bdeLabel;


@end


extern NSString *ajzhstr;
extern NSString *ajlystr;
extern NSString *larstr;
extern NSString *sarqstr;
extern NSString *larqstr;
extern NSString *lalystr;
extern NSString *labmstr;
extern NSString *lbstr;
extern NSString *yjfstr;
extern NSString *bdestr;
@implementation LSAjSegAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.detailView.layer.cornerRadius = 5;
    self.detailView.layer.borderWidth = 2;
    self.detailView.layer.borderColor = LSGlobalColor.CGColor;
    self.ajzhLabel.text = ajzhstr;
    self.ajlyLabel.text = ajlystr;
    self.larLabel.text = larstr;
    self.sarqLabel.text = sarqstr;
    self.larqLabel.text = larqstr;
    self.lalyLabel.text = lalystr;
    self.labmLabel.text = labmstr;
    self.lbLabel.text = lbstr;
    self.yjfLabel.text = yjfstr;
    self.bdeLabel.text = bdestr;
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
