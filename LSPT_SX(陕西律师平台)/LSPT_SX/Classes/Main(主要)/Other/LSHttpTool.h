//
//  BSHttpTool.h
//  busale
//
//  Created by 谢琰 on 15/12/22.
//  Copyright © 2015年 busale. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSHttpTool : NSObject
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void(^)(id json))success failure:(void(^)(NSError *error)) failure;
+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void(^)(id json))success failure:(void(^)(NSError *error)) failure;

@end
