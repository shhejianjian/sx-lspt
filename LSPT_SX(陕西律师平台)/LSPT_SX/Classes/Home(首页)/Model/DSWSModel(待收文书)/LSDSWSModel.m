//
//  LSDSWSModel.m
//  LSPT_SX
//
//  Created by 何键键 on 16/2/29.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSDSWSModel.h"
#import "MJExtension.h"
@implementation LSDSWSModel
+ (void)load
{
#pragma mark 如果使用NSObject来调用这些方法，代表所有继承自NSObject的类都会生效
#pragma mark NSObject中的ID属性对应着字典中的id
    [NSObject mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id"
                 };
    }];
}
@end
