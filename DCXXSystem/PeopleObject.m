//
//  PeopleObject.m
//  DCXXSystem
//
//  Created by teddy on 15/7/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "PeopleObject.h"
#import <AFNetworking.h>

static AFHTTPRequestOperation *_operation = nil;
@implementation PeopleObject

+ (BOOL)fetch:(NSString *)result withLevel:(NSString *)level
{
    BOOL ret;
    
    //http://115.236.2.245:38019/datadc.ashx?t=GetDept&results=0$&returntype=json
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *resluts = [NSString stringWithFormat:@"%@$%@",level,result];
    NSDictionary *parmater = @{@"t":@"GetDept",
                               @"results":resluts,
                               @"returntype":@"json"};
    _operation = [manager POST:URL parameters:parmater success:nil failure:nil];
    [_operation waitUntilFinished];
    if (_operation.responseData != nil) {
        ret = YES;
        datas = (NSArray *)[NSJSONSerialization JSONObjectWithData:_operation.responseData options:NSJSONReadingMutableContainers error:nil];
    }
    
    return  YES;
}


static NSArray *datas = nil;
+ (NSArray *)requestData
{
    return datas;
}


+ (void)cancelRequest
{
    if (_operation != nil) {
        [_operation cancel];
    }
}


@end
