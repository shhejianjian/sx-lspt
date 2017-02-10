//
//  UITableView+Popover.h
//  SSTableViewPopover
//
//  Created by Mrss on 16/1/26.
//  Copyright © 2016年 expai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PopoverItem;

typedef void(^PopoverItemSelectHandler)(PopoverItem *item);

@interface PopoverItem : NSObject

@property (nonatomic,readonly,  copy) NSString *name;
@property (nonatomic,readonly,strong) UIImage *image;
@property (nonatomic,readonly,  copy) PopoverItemSelectHandler handler;

- (instancetype)initWithName:(NSString *)name
                       image:(UIImage *)image
             selectedHandler:(PopoverItemSelectHandler)handler;

@end

@interface UITableView (Popover)

- (void)showPopoverWithItems:(NSArray <PopoverItem *>*)items
                forIndexPath:(NSIndexPath *)indexPath;

@end