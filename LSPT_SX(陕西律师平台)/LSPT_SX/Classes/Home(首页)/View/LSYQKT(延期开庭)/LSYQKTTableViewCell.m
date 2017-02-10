//
//  LSYQKTTableViewCell.m
//  LSPT_SX
//
//  Created by 何键键 on 16/2/25.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSYQKTTableViewCell.h"
#import "LSYQKTModel.h"
@interface LSYQKTTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *ahqcLabel;
@property (weak, nonatomic) IBOutlet UILabel *fymcLabel;
@property (weak, nonatomic) IBOutlet UILabel *cjsjLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation LSYQKTTableViewCell

- (void)awakeFromNib {
    self.detailView.layer.cornerRadius = 5;
    self.detailView.layer.borderWidth = 1;
    self.detailView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    // Initialization code
}

- (void)setYQKT:(LSYQKTModel *)YQKT {
    self.ahqcLabel.text = YQKT.ahqc;
    self.fymcLabel.text = YQKT.fymc;
    self.cjsjLabel.text = [self covertToDateStringFromString:YQKT.cjsj];
    if ([YQKT.zt isEqualToString:@"1"]) {
        self.statusLabel.text = @"暂存";
    } else if ([YQKT.zt isEqualToString:@"2"]) {
        self.statusLabel.text = @"已提交";
    } else if ([YQKT.zt isEqualToString:@"3"]) {
        self.statusLabel.text = @"已通过审核";
    } else if ([YQKT.zt isEqualToString:@"4"]) {
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
