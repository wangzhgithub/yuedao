//
//  NavigationContrller.m
//  VoiceCopanion
//
//  Created by 米翊米 on 15/4/8.
//  Copyright (c) 2015年 米翊米. All rights reserved.
//

#import "NavigationContrller.h"

typedef void (^APTransitionBlock)(void);

@interface NavigationContrller () <UINavigationControllerDelegate> {
    BOOL _transitionInProgress;         //是否完成动画标示
    NSMutableArray *_peddingBlocks;     //动画视图块数组
}

@end

@implementation NavigationContrller

-(id) initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    
    if (self) {
        [self commonInit];
        
        //设置导航栏背景
        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:LMH_COLOR_NAVTITLE}];
////        [self.navigationBar setBarTintColor:[UIColor blueColor]];
        [self.navigationBar setBackgroundImage:LOAD_LOCALIMG(@"navbackground") forBarMetrics:UIBarMetricsDefault];
        [self.navigationBar setShadowImage:[[UIImage alloc] init]];
        
        self.navigationController.navigationBar.translucent = NO;
        self.delegate = self;
    }
    
    return self;
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}
/**
 *  初始化参数
 */
- (void)commonInit
{
    _transitionInProgress = NO;
    _peddingBlocks = [NSMutableArray arrayWithCapacity:2];
}

#pragma mark - addLeftButton
/**
 *  添加自定义返回按钮
 *
 *  @return 自定义按钮
 */
- (UIBarButtonItem *)createLeftBarButonItem
{
    UIButton *rightBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 27)];
    [rightBarButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    [rightBarButton addTarget:self action:@selector(leftBarItemClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    backBarButtonItem.style = UIBarButtonItemStylePlain;
    
    return backBarButtonItem;
}

- (void)addLeftBarItem{
    UINavigationItem * navItem = self.topViewController.navigationItem;
    [navItem setLeftBarButtonItem:[self createLeftBarButonItem] animated:YES];
}

- (UIBarButtonItem *)createRightBarButonItem
{
    
    
    UIButton * backBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 27)];
    [backBarButton setTitle:@"注册" forState:UIControlStateNormal];
//    [backBarButton setTintColor:LMH_COLOR_BTNBACK];
    [backBarButton setTitleColor:LMH_COLOR_BTNBACK forState:UIControlStateNormal];
    backBarButton.titleLabel.font = LMH_FONT_15;
    [backBarButton addTarget:self action:@selector(rightBarItemClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBarButton];
    backBarButtonItem.style = UIBarButtonItemStylePlain;
    
    return backBarButtonItem;
}

- (void)addRightBarItem{
    UINavigationItem * navItem = self.topViewController.navigationItem;
    [navItem setRightBarButtonItem:[self createRightBarButonItem] animated:YES];
}

#pragma mark - 自定义返回按钮
/**
 *  返回按钮触发事件
 */
- (void)leftBarItemClick{
    if ([self.navDelegate respondsToSelector:@selector(leftBarItemClick)]) {
        [self.navDelegate leftBarItemClick];
    }else{
        [self popViewControllerAnimated:YES];
    }
}

- (void)rightBarItemClick{
    if ([self.navDelegate respondsToSelector:@selector(rightBarItemClick)]) {
        [self.navDelegate rightBarItemClick];
    }
}

#pragma mark - 跳转到下一视图
/**
 *  跳转到下一视图
 *
 *  @param viewController 下个视图
 *  @param animated       是否开启动画
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (IOS_8 >= 8.0) {
        [super pushViewController:viewController animated:animated];
    }else {
        [self addTransitionBlock:^{
            [super pushViewController:viewController animated:animated];
        }];
    }
}

#pragma mark - 返回视图
/**
 *  返回上一视图
 *
 *  @param animated 是否开启动画
 *
 *  @return 上一个视图
 */
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController *poppedViewController = nil;
    if (IOS_8 >= 8.0) {
        poppedViewController = [super popViewControllerAnimated:animated];
    } else {
        __weak NavigationContrller *weakSelf = self;
        [self addTransitionBlock:^{
            UIViewController *viewController = [super popViewControllerAnimated:animated];
            if (viewController == nil) {
                weakSelf.transitionInProgress = NO;
            }
        }];
    }
    return poppedViewController;
}

/**
 *  返回指定视图
 *
 *  @param viewController 指定的视图
 *  @param animated       是否开启动画
 *
 *  @return 返回指定视图的前的数组
 */
- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSArray *poppedViewControllers = nil;
    if (IOS_8 >= 8.0) {
        poppedViewControllers = [super popToViewController:viewController animated:animated];
    } else {
        __weak NavigationContrller *weakSelf = self;
        [self addTransitionBlock:^{
            if ([weakSelf.viewControllers containsObject:viewController]) {
                NSArray *viewControllers = [super popToViewController:viewController animated:animated];
                if (viewControllers.count == 0) {
                    weakSelf.transitionInProgress = NO;
                }
            } else {
                weakSelf.transitionInProgress = NO;
            }
        }];
    }
    return poppedViewControllers;
}

/**
 *  返回根视图
 *
 *  @param animated 是否开启动画
 *
 *  @return 返回至首页后的数组
 */
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    NSArray *poppedViewControllers = nil;
    if (IOS_8 >= 8.0) {
        poppedViewControllers = [super popToRootViewControllerAnimated:animated];
    } else {
        __weak NavigationContrller *weakSelf = self;
        [self addTransitionBlock:^{
            NSArray *viewControllers = [super popToRootViewControllerAnimated:animated];
            if (viewControllers.count == 0) {
                weakSelf.transitionInProgress = NO;
            }
        }];
    }
    return poppedViewControllers;
}

#pragma mark - Transition Manager
/**
 *  保证视图切换安全
 *  防止出现 Can't add self as subview
 */
- (void)addTransitionBlock:(void (^)(void))block
{
    if (![self isTransitionInProgress]) {
        self.transitionInProgress = YES;
        block();
    } else {
        [_peddingBlocks addObject:[block copy]];
    }
}

- (BOOL)isTransitionInProgress
{
    return _transitionInProgress;
}

- (void)setTransitionInProgress:(BOOL)transitionInProgress
{
    _transitionInProgress = transitionInProgress;
    if (!transitionInProgress && _peddingBlocks.count > 0) {
        _transitionInProgress = YES;
        [self runNextTransition];
    }
}

- (void)runNextTransition
{
    APTransitionBlock block = _peddingBlocks.firstObject;
    [_peddingBlocks removeObject:block];
    block();
}

@end
