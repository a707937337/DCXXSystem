//
//  PeopleObject.h
//  DCXXSystem
//
//  Created by teddy on 15/7/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PeopleObject : NSObject

+ (BOOL)fetch:(NSString *)result withLevel:(NSString *)level;

+ (NSArray *)requestData;

+ (void)cancelRequest;

@end
