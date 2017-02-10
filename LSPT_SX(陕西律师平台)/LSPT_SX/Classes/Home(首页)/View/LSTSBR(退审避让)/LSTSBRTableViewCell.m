//
//  LSTSBRTableViewCell.m
//  LSPT_SX
//
//  Created by 何键键 on 16/2/24.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSTSBRTableViewCell.h"
#import "LSTSBRModel.h"
@interface LSTSBRTableViewCell () 
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *ahqcLabel;
@property (weak, nonatomic) IBOutlet UILabel *fymcLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *statuslabel;

@end

@implementation LSTSBRTableViewCell

- (void)awakeFromNib {
    self.detailView.layer.cornerRadius = 5;
    self.detailView.layer.borderWidth = 1;
    self.detailView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    // Initialization code
}

- (void)setTSBR:(LSTSBRModel *)TSBR {
    self.ahqcLabel.text = TSBR.ahqc;
    self.fymcLabel.text = TSBR.fymc;
    self.dateLabel.text = [self covertToDateStringFromString:TSBR.sqsj];
    if ([TSBR.zt isEqualToString:@"1"]) {
        self.statuslabel.text = @"暂存";
    } else if ([TSBR.zt isEqualToString:@"2"]) {
        self.statuslabel.text = @"已提交";
    } else if ([TSBR.zt isEqualToString:@"3"]) {
        self.statuslabel.text = @"已通过审核";
    } else if ([TSBR.zt isEqualToString:@"4"]) {
        self.statuslabel.text = @"未通过审核";
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
