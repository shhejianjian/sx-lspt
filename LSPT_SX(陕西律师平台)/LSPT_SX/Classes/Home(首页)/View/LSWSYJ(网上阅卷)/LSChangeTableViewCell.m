//
//  LSChangeTableViewCell.m
//  LSPT_SX
//
//  Created by 何键键 on 16/2/25.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSChangeTableViewCell.h"
#import "LSYJNRModel.h"
#import "LSChangeAppointViewController.h"
@interface LSChangeTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *yjnrLabel;



@end

extern NSString *wsyjjynrStr;
@implementation LSChangeTableViewCell

- (void)awakeFromNib {
    self.selectBtn.layer.borderWidth = 1;
    self.selectBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    // Initialization code
}

- (void)setYJNR:(LSYJNRModel *)YJNR {
    self.yjnrLabel.text = YJNR.bt;
    NSArray *array = [wsyjjynrStr componentsSeparatedByString:@","];
//    for (int i = 0 ;i < array.count;i++) {
//        if ([YJNR.bt isEqualToString:array[i]]) {
//            self.selectBtn.selected = YES;
//        } else {
//            self.selectBtn.selected = YJNR.isNew;
//        }
//    }
    if ([array containsObject:YJNR.bt]) {
        self.selectBtn.selected = YES;
    } else {
        self.selectBtn.selected = YJNR.isNew;
    }
}

- (void)setYJNRsecond:(LSYJNRModel *)YJNRsecond {
    _YJNRsecond = YJNRsecond;
    self.yjnrLabel.text = YJNRsecond.bt;
    self.selectBtn.selected = YJNRsecond.isNew;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
