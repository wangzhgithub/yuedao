//
//  TabBarController.m
//  VoiceCopanion
//
//  Created by 米翊米 on 15/4/8.
//  Copyright (c) 2015年 米翊米. All rights reserved.
//

#import "TabBarController.h"
#import "NavigationContrller.h"
#import "Voice_SecondViewController.h"
#import "Voice_ThreedViewController.h"
#import "Voice_ResetViewController.h"
#import "Voice_Threed_ViewController.h"

@interface TabBarController ()<UITabBarControllerDelegate>
{
    Voice_FirstViewController *firstVC;
    
    NSMutableArray *tabArray;
}

@end

@implementation TabBarController

- (id)init{
    self = [super init];
    if (self) {
        firstVC = [[Voice_FirstViewController alloc] initWithStyle:UITableViewStylePlain];
        NavigationContrller *firstNav = [[NavigationContrller alloc] initWithRootViewController:firstVC];
        firstVC.navigationController = firstNav;
        firstVC.tabHiden = NO;
        firstVC.isFirstVC = YES;
        
        Voice_SecondViewController *secondVC = [[Voice_SecondViewController alloc] initWithStyle:UITableViewStylePlain];
        NavigationContrller *secondNav = [[NavigationContrller alloc] initWithRootViewController:secondVC];
        secondVC.navigationController = secondNav;
        secondVC.tabHiden = NO;
        secondVC.isFirstVC = YES;
        
//        Voice_ResetViewController *thirdVC = [[Voice_ResetViewController alloc] initWithNibName:nil bundle:nil];
//        NavigationContrller *thirdNav = [[NavigationContrller alloc] initWithRootViewController:thirdVC];
//        thirdVC.navigationController = thirdNav;
//        thirdVC.tabHiden = NO;
//        thirdVC.isFirstVC = YES;
        
        Voice_Threed_ViewController *thirdVC = [[Voice_Threed_ViewController alloc] initWithNibName:nil bundle:nil];
        NavigationContrller *thirdNav = [[NavigationContrller alloc] initWithRootViewController:thirdVC];
        thirdVC.navigationController = thirdNav;
        thirdVC.tabHiden = NO;
        thirdVC.isFirstVC = YES;
        
        //视图加入TabBar组
        tabArray = [NSMutableArray arrayWithObjects:firstNav, secondNav, thirdNav, nil];
        [super setViewControllers:tabArray];
        
        //设置TabBar图文
        [self initTabBarItem];
        
        //移除顶部阴影和黑线
//        [self.tabBar setClipsToBounds:YES];
        //移除阴影
        [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
        [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  设置TabBar图文
 */
- (void)initTabBarItem{
    UITabBar *tabBar = self.tabBar;
    self.delegate = self;
    
    //TabBar的文字
    NSArray *titleArray = [NSArray arrayWithObjects:@"拨号", @"联系人", @"设置", nil];
    for (int i = 0; i < tabBar.items.count; i ++) {
        UITabBarItem *unitItem = tabBar.items[i];
        
        //设置TabBar文字
        unitItem.title = titleArray[i];
        
        //设置默认时字体颜色
        NSDictionary *attrs = @{NSForegroundColorAttributeName:[UIColor grayColor], NSFontAttributeName:LMH_FONT_11};
        [unitItem setTitleTextAttributes:attrs forState:UIControlStateNormal];
        
        //设置被选中时的字体颜色
//        attrs = @{NSForegroundColorAttributeName:LMH_COLOR_SKIN, NSFontAttributeName:LMH_FONT_11};
//        [unitItem setTitleTextAttributes:attrs forState:UIControlStateSelected];
        
        //设置默认图片
        NSString *imgStr = [NSString stringWithFormat:@"tabDefault%d",i+1];
        UIImage *barImage = [LOAD_LOCALIMG(imgStr) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        unitItem.image = barImage;
        
        //设置选中时的图片
        imgStr = [NSString stringWithFormat:@"tabSelect%d",i+1];
        barImage = [LOAD_LOCALIMG(imgStr) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        unitItem.selectedImage = barImage;
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[NavigationContrller class]]) {
        [(NavigationContrller *)viewController popToRootViewControllerAnimated:YES];
    }
    if (tabBarController.selectedIndex == 0) {
        [firstVC showNumber];
    }
    
    return YES;
}

@end
