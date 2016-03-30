//
//  KTProxy.m
//  BaoTong
//
//  Created by 林程宇 on 14-3-5.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "KTProxy.h"

#define SERVER_HOST @"http://122.224.69.169:8082/yd/app/"

@implementation KTProxy

+ (KTProxy *)loadWithMethod:(NSString *)method andParams:(NSDictionary *)params
                   completed:(RequestCompletedHandleBlock)completeHandleBlock
                      failed:(RequestFailedHandleBlock)failedHandleBlock
{
    KTProxy *proxy = [[KTProxy alloc] init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置请求格式
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"JSESSIONID=%@",SESSIONID],@"Cookie", nil];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"JSESSIONID=%@",SESSIONID] forHTTPHeaderField:@"Cookie"];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30;
    proxy.oper = [manager POST:[NSString stringWithFormat:@"%@%@",SERVER_HOST,method] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completeHandleBlock) {
            completeHandleBlock([operation responseString], [operation responseStringEncoding]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"==================================================");
        NSLog(@"加载数据失败，Error: %@", [error localizedDescription]);
        NSLog(@"Class:::%@", NSStringFromClass([self class]));
        NSLog(@"==================================================");
        
        if (failedHandleBlock) {
            failedHandleBlock(error);
        }
    }];
    
    return proxy;
}

- (void)start
{
//    if (_oper && _oper.isReady) {
//        [_oper start];
//    }
}

- (BOOL)isLoading
{
    _loading = [_oper isExecuting];
    return _loading;
}

- (BOOL)isLoaded
{
    _loaded = [_oper isFinished];
    return _loaded;
}

@end
