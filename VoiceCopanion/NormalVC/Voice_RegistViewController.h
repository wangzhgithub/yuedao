//
//  Voice_RegistViewController.h
//  VoiceCopanion
//
//  Created by 米翊米 on 15/5/26.
//  Copyright (c) 2015年 米翊米. All rights reserved.
//

#import "BaseViewController.h"

@protocol RegistDelegate <NSObject>

- (void)didRegist;

@end

typedef void (^registBlock)();

@interface Voice_RegistViewController : BaseViewController
{
    registBlock _registBlock;
}

- (void)setRegistBlock:(registBlock)block;
@property(nonatomic,assign)id <RegistDelegate>delegate;
@property(nonatomic)NSInteger type;

@end
