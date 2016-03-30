//
//  Voice_LoginViewController.h
//  VoiceCopanion
//
//  Created by 米翊米 on 15/5/24.
//  Copyright (c) 2015年 米翊米. All rights reserved.
//

#import "BaseViewController.h"

@protocol LoginDelegate <NSObject>

- (void)didLogin;

@end

@interface Voice_LoginViewController : BaseViewController

@property(nonatomic,assign)id <LoginDelegate> delegate;
+ (void)showInViewController:(id<LoginDelegate>)mainVC;

@end
