//
//  CountObject.h
//  DCXXSystem
//
//  Created by teddy on 15/7/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CountObject : NSObject
+ (BOOL)fetchWithType:(NSString *)type withResult:(NSString *)result;

+ (NSArray *)requestCount;

+ (void)cancelRequest;

@end
