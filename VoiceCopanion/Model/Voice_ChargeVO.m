//
//  Voice_ChargeVO.m
//  VoiceCopanion
//
//  Created by 米翊米 on 15/6/14.
//  Copyright (c) 2015年 米翊米. All rights reserved.
//

#import "Voice_ChargeVO.h"

@implementation Voice_ChargeVO

@synthesize cid;
@synthesize money;
@synthesize dxnum;

+ (NSArray *)Voice_ChargeVO:(NSArray *)array{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[Voice_ChargeVO Voice_ChargeVOWithDictionary:entry]];
    }
    
    return resultsArray;
}

+ (Voice_ChargeVO *)Voice_ChargeVOWithDictionary:(NSDictionary *)dict{
    Voice_ChargeVO *instance = [[Voice_ChargeVO alloc] initWithDictionary:dict];
    
    return instance;
}

- (id)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        if (dict[@"id"] && ![dict[@"id"] isEqual:[NSNull null]] && [dict[@"id"] isKindOfClass:[NSNumber class]]) {
            self.cid = dict[@"id"];
        }
        
        if (dict[@"money"] && ![dict[@"money"] isEqual:[NSNull null]] && [dict[@"money"] isKindOfClass:[NSNumber class]]) {
            self.money = dict[@"money"];
        }
        
        if (dict[@"dxnum"] && ![dict[@"dxnum"] isEqual:[NSNull null]] && [dict[@"dxnum"] isKindOfClass:[NSNumber class]]) {
            self.dxnum = dict[@"dxnum"];
        }
    }
    
    return self;
}

@end
