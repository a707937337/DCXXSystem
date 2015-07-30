//
//  RestaurantObject.h
//  DCXXSystem
//
//  Created by teddy on 15/7/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestaurantObject : NSObject

+ (BOOL)fetch;

+ (NSArray *)requestData;

+ (void)cancelRequest;
@end
