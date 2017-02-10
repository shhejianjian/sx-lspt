//
//  LSLXFGTableViewCell.m
//  LSPT_SX
//
//  Created by 何键键 on 16/2/24.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSLXFGTableViewCell.h"
#import "LSLXFGModel.h"
@interface LSLXFGTableViewCell () 
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *ahqcLabel;
@property (weak, nonatomic) IBOutlet UILabel *fqlsmcLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *btLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation LSLXFGTableViewCell

- (void)awakeFromNib {
    self.detailView.layer.cornerRadius = 5;
    self.detailView.layer.borderWidth = 1;
    self.detailView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    // Initialization code
}

- (void)setLXFG:(LSLXFGModel *)LXFG {
    self.ahqcLabel.text = LXFG.ahqc;
    self.fqlsmcLabel.text = LXFG.fgdm;
    self.dateLabel.text = [self covertToDateStringFromString:LXFG.cjsj];
    self.btLabel.text = LXFG.bt;
    if ([LXFG.zt isEqualToString:@"1"]) {
        self.statusLabel.text = @"暂存";
    } else if ([LXFG.zt isEqualToString:@"2"]) {
        self.statusLabel.text = @"已提交";
    } else if ([LXFG.zt isEqualToString:@"3"]) {
        self.statusLabel.text = @"已通过审核";
    } else if ([LXFG.zt isEqualToString:@"4"]) {
        self.statusLabel.text = @"未通过审核";
    }
}
- (NSString *)covertToDateStringFromString:(NSString *)Str
{
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:[Str longLongValue]/1000.0];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter stringFromDate:date];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
