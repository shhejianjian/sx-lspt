//
//  LSYJJYTableViewCell.m
//  LSPT_SX
//
//  Created by 何键键 on 16/3/2.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSYJJYTableViewCell.h"
#import "LSYJJYModel.h"
@interface LSYJJYTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *wjmcLabel;
@property (weak, nonatomic) IBOutlet UILabel *yjlxLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *btLabel;

@end

@implementation LSYJJYTableViewCell

- (void)awakeFromNib {
    self.detailView.layer.cornerRadius = 5;
    self.detailView.layer.borderWidth = 1;
    self.detailView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    // Initialization code
}

- (void)setYJJY:(LSYJJYModel *)YJJY {
    self.btLabel.text = [NSString stringWithFormat:@"【标题】 %@",YJJY.bt];
    self.wjmcLabel.text = [NSString stringWithFormat:@"【文件名称】 %@",YJJY.xsmc];;
    if ([YJJY.lx isEqualToString:@"1"]) {
        self.yjlxLabel.text = [NSString stringWithFormat:@"【意见类型】 表扬"];
    } else {
        self.yjlxLabel.text = [NSString stringWithFormat:@"【意见类型】 建议"];
    }
    if ([YJJY.zt isEqualToString:@"1"]) {
        self.statusLabel.text = [NSString stringWithFormat:@"【状态】 暂存"];
    } else {
        self.statusLabel.text = [NSString stringWithFormat:@"【状态】 已提交"];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
