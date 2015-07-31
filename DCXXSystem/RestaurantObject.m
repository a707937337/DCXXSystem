//
//  RestaurantObject.m
//  DCXXSystem
//
//  Created by teddy on 15/7/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "RestaurantObject.h"
#import <AFNetworking.h>

static AFHTTPRequestOperation *_operation = nil;
@implementation RestaurantObject

+ (BOOL)fetchWithPersonID:(NSString *)personID
{
    BOOL ret = NO;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *par = @{@"t":@"GetRefectory",
                          @"results":personID,
                          @"returntype":@"json"};
    _operation = [manager POST:URL parameters:par success:nil failure:nil];
    [_operation waitUntilFinished];
    if (_operation.responseData != nil) {
        data = (NSArray *)[NSJSONSerialization JSONObjectWithData:_operation.responseData options:NSJSONReadingMutableContainers error:nil];
        ret = YES;
    }
    
    return ret;
    
}

static NSArray *data = nil;
+ (NSArray *)requestData
{
    return data;
}

+ (void)cancelRequest
{
    if (_operation != nil) {
        [_operation cancel];
    }
}

@end
