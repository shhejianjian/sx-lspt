//
//  LSWSLACell.m
//  LSPT_SX
//
//  Created by 谢琰 on 16/2/24.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSWSLACell.h"
#import "LSWSLA.h"
@interface LSWSLACell ()
@property (weak, nonatomic) IBOutlet UIView *WSLAView;
@property (weak, nonatomic) IBOutlet UILabel *ajbhqcLabel;
@property (weak, nonatomic) IBOutlet UILabel *fymcLabel;
@property (weak, nonatomic) IBOutlet UILabel *creattimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ajxzdmLabel;
@property (weak, nonatomic) IBOutlet UILabel *ztLabel;

@end
@implementation LSWSLACell

- (void)awakeFromNib {
    self.WSLAView.layer.cornerRadius = 5.0f;
    self.WSLAView.layer.borderWidth = 1.0f;
    self.WSLAView.layer.borderColor = [UIColor lightGrayColor].CGColor;
}
- (void)setWsla:(LSWSLA *)wsla
{
    self.ajbhqcLabel.text = wsla.ajbhqc;
    self.creattimeLabel.text = wsla.creattime;
    self.fymcLabel.text = wsla.fymc;
    if ([wsla.ajxzdm isEqualToString:@"2"]) {
        self.ajxzdmLabel.text = @"民事";
    }else if([wsla.ajxzdm isEqualToString:@"6"]){
        self.ajxzdmLabel.text = @"行政";
    }else if([wsla.ajxzdm isEqualToString:@"8"]){
        self.ajxzdmLabel.text = @"执行";
    }
    if ([wsla.zt isEqualToString:@"1"]) {
        self.ztLabel.text = @"暂存";
    } else if ([wsla.zt isEqualToString:@"2"]) {
        self.ztLabel.text = @"已提交";
    } else if ([wsla.zt isEqualToString:@"3"]) {
        self.ztLabel.text = @"已通过审核";
    } else if ([wsla.zt isEqualToString:@"4"]) {
        self.ztLabel.text = @"未通过审核";
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
