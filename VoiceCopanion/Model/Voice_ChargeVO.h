//
//  Voice_ChargeVO.h
//  VoiceCopanion
//
//  Created by 米翊米 on 15/6/14.
//  Copyright (c) 2015年 米翊米. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Voice_ChargeVO : NSObject

@property(nonatomic,strong)NSNumber *cid;
@property(nonatomic,strong)NSNumber *money;
@property(nonatomic,strong)NSNumber *dxnum;

+ (NSArray *)Voice_ChargeVO:(NSArray *)array;

+ (Voice_ChargeVO *)Voice_ChargeVOWithDictionary:(NSDictionary *)dict;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
