//
//  BSHttpTool.m
//  busale
//
//  Created by 谢琰 on 15/12/22.
//  Copyright © 2015年 busale. All rights reserved.
//

#import "LSHttpTool.h"
#import "AFNetworking.h"
#import "LSConst.h"
@implementation LSHttpTool
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void(^)(id json))success failure:(void(^)(NSError *error)) failure
{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json",@"text/javascript",@"text/plain", nil];

    
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",BaseUrl,url];
    //NSString *UrlString = [urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:urlStr parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (success) {
            success(responseObject);
         }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    

}
+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void(^)(id json))success failure:(void(^)(NSError *error)) failure
{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json",@"text/javascript",@"text/plain", nil];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",BaseUrl,url];
    NSString *UrlString = [urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager POST:UrlString parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
     }];
 }
@end
