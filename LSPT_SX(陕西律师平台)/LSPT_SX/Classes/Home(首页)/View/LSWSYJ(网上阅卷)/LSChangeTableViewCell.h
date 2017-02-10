//
//  LSChangeTableViewCell.h
//  LSPT_SX
//
//  Created by 何键键 on 16/2/25.
//  Copyright © 2016年 LS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSYJNRModel;
@interface LSChangeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (nonatomic, strong) LSYJNRModel *YJNR;
@property (nonatomic, strong) LSYJNRModel *YJNRsecond;

@end
