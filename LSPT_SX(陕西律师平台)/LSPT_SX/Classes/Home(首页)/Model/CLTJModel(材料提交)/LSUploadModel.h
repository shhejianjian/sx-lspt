//
//  LSUploadModel.h
//  LSPT_SX
//
//  Created by 何键键 on 16/3/2.
//  Copyright © 2016年 LS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSUploadModel : NSObject
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *originalfileName;
@property (nonatomic, copy) NSString *newname;
@property (nonatomic, copy) NSString *path;

@end
