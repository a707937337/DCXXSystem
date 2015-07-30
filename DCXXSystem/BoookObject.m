//
//  BoookObject.m
//  DCXXSystem
//
//  Created by teddy on 15/7/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "BoookObject.h"
#import <AFNetworking.h>

static AFHTTPRequestOperation *_operation = nil;
@implementation BoookObject

+ (BOOL)fetch:(NSString *)type withResult:(NSString *)result
{
    BOOL ret = NO;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *par = @{@"t":type,
                          @"results":result,
                          @"returntype":@"json"};
    _operation = [manager POST:URL parameters:par success:nil failure:nil];
    [_operation waitUntilFinished];
    if (_operation.responseData != nil) {
        resResult = (NSArray *)[NSJSONSerialization JSONObjectWithData:_operation.responseData options:NSJSONReadingMutableContainers error:nil];
        ret = YES;
    }
    
    return ret;
}

static NSArray *resResult = nil;
+ (NSArray *)requestDic
{
    return resResult;
}

+ (void)cancelRequest
{
    if (_operation != nil) {
        [_operation cancel];
    }
}

@end
