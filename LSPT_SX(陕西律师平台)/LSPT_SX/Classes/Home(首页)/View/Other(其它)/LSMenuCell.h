//
//  LSMenuCell.h
//  LSPT_SX
//
//  Created by 谢琰 on 16/2/25.
//  Copyright © 2016年 LS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSMenuCell : UITableViewCell
@property (nonatomic, assign) NSInteger index;

@property (weak, nonatomic) IBOutlet UIImageView *menuImageView;
@property (weak, nonatomic) IBOutlet UILabel *menuLabel;

@end
