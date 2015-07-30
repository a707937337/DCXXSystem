//
//  BoookObject.h
//  DCXXSystem
//  ******订餐、取消订餐******
//  Created by teddy on 15/7/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BoookObject : NSObject

+ (BOOL)fetch:(NSString *)type withResult:(NSString *)result;

+ (NSArray *)requestDic;

+ (void)cancelRequest;

@end
