//
//  LSDSWSTableViewCell.m
//  LSPT_SX
//
//  Created by 何键键 on 16/2/24.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSDSWSTableViewCell.h"
#import "LSDSWSModel.h"

@interface LSDSWSTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *peopleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *WSnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ahqcLabel;

@end

@implementation LSDSWSTableViewCell

- (void)awakeFromNib {
    self.detailView.layer.cornerRadius = 5;
    self.detailView.layer.borderWidth = 1;
    self.detailView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    // Initialization code
}

-(void)setDSWS:(LSDSWSModel *)DSWS {
    self.peopleLabel.text = DSWS.xm;
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat = @"yyyy-MM-dd";
//    NSDate *tjrq = [[NSDate alloc]initWithTimeIntervalSinceNow:DSWS.tjrq.intValue/1000];
//    NSString *tjrqStr = [dateFormatter stringFromDate:tjrq];
    self.dateLabel.text = [self covertToDateStringFromString:DSWS.tjrq];
    self.WSnameLabel.text = DSWS.xsmc;
    self.ahqcLabel.text = DSWS.ahqc;
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
