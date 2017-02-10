//
//  LSWDAJTableViewCell.m
//  LSPT_SX
//
//  Created by 何键键 on 16/2/26.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSWDAJTableViewCell.h"
#import "LSWDAJModel.h"
@interface LSWDAJTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *ahqcLabel;
@property (weak, nonatomic) IBOutlet UILabel *fymcLabel;
@property (weak, nonatomic) IBOutlet UILabel *sqsjLabel;
@property (weak, nonatomic) IBOutlet UILabel *ajlxLabel;
@property (weak, nonatomic) IBOutlet UILabel *ztLabel;




@end

@implementation LSWDAJTableViewCell

- (void)awakeFromNib {
    self.detailView.layer.cornerRadius = 5;
    self.detailView.layer.borderWidth = 1;
    self.detailView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    // Initialization code
}

- (void)setWDAJ:(LSWDAJModel *)WDAJ {
    _ahqcLabel.text = WDAJ.ahqc;
    _fymcLabel.text = WDAJ.jarq;
    _ajlxLabel.text = WDAJ.ajlbmc;
    _sqsjLabel.text = WDAJ.fymc;
    _ztLabel.text = WDAJ.lcztmc;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
