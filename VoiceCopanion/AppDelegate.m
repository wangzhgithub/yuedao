//
//  AppDelegate.m
//  VoiceCopanion
//
//  Created by 米翊米 on 15/5/10.
//  Copyright (c) 2015年 米翊米. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarController.h"
#import <MobClick.h>

@interface AppDelegate ()<UIAlertViewDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    TabBarController *tabVC = [[TabBarController alloc] init];
    self.window.rootViewController = tabVC;
    
    [self.window makeKeyAndVisible];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick startWithAppkey:UMAPPID];
    [MobClick startWithAppkey:UMAPPID reportPolicy:BATCH channelId:@"appstore"];
    
    [self performSelector:@selector(checkAppUpdate) withObject:nil afterDelay:0.2];
    
    return YES;
}

-(void)checkAppUpdate
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/lookup?id=%@",@"1037707641"]]];
    [request setHTTPMethod:@"GET"];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (returnData) {
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:returnData options:0 error:nil];
        
        NSString *latestVersion = [jsonData[@"results"] objectAtIndex:0][@"version"];
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        if ([latestVersion compare:version] == NSOrderedDescending) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"升级提示" message:@"有新版本更新了" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"升级", nil];
            [alert show];
        }
    }
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", @"1037707641"]];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
