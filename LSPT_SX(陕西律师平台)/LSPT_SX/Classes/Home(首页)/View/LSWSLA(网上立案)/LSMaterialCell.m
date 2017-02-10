//
//  LSMaterialCell.m
//  LSPT_SX
//
//  Created by 谢琰 on 16/2/26.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSMaterialCell.h"
#import "LSMaterial.h"
@interface LSMaterialCell()
@property (weak, nonatomic) IBOutlet UIView *edgeView;
@property (weak, nonatomic) IBOutlet UILabel *mlmcLabel;
@property (weak, nonatomic) IBOutlet UILabel *xsmcLabel;

@end
@implementation LSMaterialCell

- (void)awakeFromNib {
    self.edgeView.layer.cornerRadius = 5.0f;
    self.edgeView.layer.borderWidth = 1.0f;
    self.edgeView.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)setMaterial:(LSMaterial *)material
{
    _material = material;
    self.mlmcLabel.text = material.mlmc;
    self.xsmcLabel.text = material.xsmc;
}
@end
