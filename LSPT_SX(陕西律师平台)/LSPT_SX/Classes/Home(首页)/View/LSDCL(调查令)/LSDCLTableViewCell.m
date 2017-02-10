//
//  LSDCLTableViewCell.m
//  LSPT_SX
//
//  Created by 何键键 on 16/2/25.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSDCLTableViewCell.h"
#import "LSDCLModel.h"
@interface LSDCLTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *ahqcLabel;
@property (weak, nonatomic) IBOutlet UILabel *fymcLabel;
@property (weak, nonatomic) IBOutlet UILabel *cjsjLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation LSDCLTableViewCell

- (void)awakeFromNib {
    self.detailView.layer.cornerRadius = 5;
    self.detailView.layer.borderWidth = 1;
    self.detailView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    // Initialization code
}

- (void)setDCL:(LSDCLModel *)DCL {
    self.ahqcLabel.text = DCL.ahqc;
    self.fymcLabel.text = DCL.fymc;
    self.cjsjLabel.text = [self covertToDateStringFromString:DCL.cjsj];
    if ([DCL.zt isEqualToString:@"1"]) {
        self.statusLabel.text = @"暂存";
    } else if ([DCL.zt isEqualToString:@"2"]) {
        self.statusLabel.text = @"已提交";
    } else if ([DCL.zt isEqualToString:@"3"]) {
        self.statusLabel.text = @"已通过审核";
    } else if ([DCL.zt isEqualToString:@"4"]) {
        self.statusLabel.text = @"未通过审核";
    }
}
//- (NSString *) encodeNSString:(NSString*)str {
//    const char *c = [str cStringUsingEncoding:NSISOLatin1StringEncoding];
//    NSString *newString = [[NSString alloc]initWithCString:c encoding:NSUTF8StringEncoding];
//    return newString;
//}
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
