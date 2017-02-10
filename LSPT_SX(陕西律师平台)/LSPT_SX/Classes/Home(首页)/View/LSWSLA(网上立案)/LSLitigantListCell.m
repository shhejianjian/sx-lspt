//
//  LSLitigantListCell.m
//  LSPT_SX
//
//  Created by 谢琰 on 16/2/25.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSLitigantListCell.h"
@interface LSLitigantListCell()
@property (weak, nonatomic) IBOutlet UIView *edgeView;


@end
@implementation LSLitigantListCell

- (void)awakeFromNib {
    
    self.edgeView.layer.cornerRadius = 5.0f;
    self.edgeView.layer.borderWidth = 1.0f;
    self.edgeView.layer.borderColor = [UIColor lightGrayColor].CGColor;
 }



@end
