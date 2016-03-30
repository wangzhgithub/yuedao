//
//  Voice_Threed_ViewController.h
//  VoiceCopanion
//
//  Created by wangzh on 16/3/8.
//  Copyright © 2016年 米翊米. All rights reserved.
//

#import "TVStaticTableViewController.h"
#import "NavigationContrller.h"
#import <MBProgressHUD.h>

@interface Voice_Threed_ViewController : TVStaticTableViewController

@property(nonatomic,strong) NavigationContrller *navigationController;
@property(nonatomic) BOOL navHiden;
@property(nonatomic) BOOL tabHiden;
@property(nonatomic) BOOL isFirstVC;

- (void)textStateHUD:(NSString *)text;
- (void)loadHUD;
- (void)hideHUD;
@end
