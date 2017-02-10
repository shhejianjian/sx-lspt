//
//  LSDropdownMenu.h
//  LSPT_SX
//
//  Created by 谢琰 on 16/2/24.
//  Copyright © 2016年 LS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSDropdownMenu;
@protocol LSDropdownMenuDelegate <NSObject>
@optional
- (void)dropdownMenuDidDismiss:(LSDropdownMenu *)menu;
- (void)dropdownMenuDidShow:(LSDropdownMenu *)menu;

@end

@interface LSDropdownMenu : UIView
@property (nonatomic,weak) id<LSDropdownMenuDelegate> delegate;
+ (instancetype)menu;

/**
 *  显示
 */
- (void)showFrom:(UIView *)from;
/**
 *  销毁
 */
- (void)dismiss;

/**
 *  内容
 */
@property (nonatomic, strong) UIView *content;
/**
 *  内容控制器
 */
@property (nonatomic, strong) UIViewController *contentController;
@end
