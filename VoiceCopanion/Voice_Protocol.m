//
//  Voice_Protocol.m
//  VoiceCopanion
//
//  Created by wangzh on 16/3/9.
//  Copyright © 2016年 米翊米. All rights reserved.
//

#import "Voice_Protocol.h"

@implementation Voice_Protocol

- (id)init
{
    if ( self = [super init] ) {
        self.userDef = [NSUserDefaults standardUserDefaults];
        self.tempArray = [NSMutableArray arrayWithCapacity:0];
        self.smsArray = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}


@end
