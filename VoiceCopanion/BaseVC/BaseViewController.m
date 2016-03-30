//
//  BaseViewController.m
//  VoiceCopanion
//
//  Created by 米翊米 on 15/4/8.
//  Copyright (c) 2015年 米翊米. All rights reserved.
//

#import "BaseViewController.h"
#import "UIViewController+APSafeTransition.h"

@interface BaseViewController ()<MBProgressHUDDelegate,NavigationContrllerDelegate>
{
    MBProgressHUD *stateHud;
}

@end

@implementation BaseViewController
@synthesize navigationController;
@synthesize navHiden,tabHiden;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        navHiden = NO;
        tabHiden = YES;
    }
    return self;
}

- (void)loadView{
    [super loadView];
    
//    contenView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCRW, SCRH)];
    //设置底层view的frame
    CGRect vFrame = self.view.frame;
    vFrame.size.height = navHiden?SCRH:SCRH-NAVHEIGHT;
    vFrame.size.height = tabHiden?vFrame.size.height:vFrame.size.height-TABHEIGHT;
    self.view.frame = vFrame;
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置边缘不延伸至导航栏下
    if (IOS_7){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if (!self.isFirstVC) {
        [self.navigationController addLeftBarItem];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.navigationController.navDelegate = self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navDelegate = nil;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)textStateHUD:(NSString *)text
{
    if (!stateHud) {
        stateHud = [[MBProgressHUD alloc] initWithView:self.view];
        stateHud.delegate = self;
        [self.view addSubview:stateHud];
    }
    stateHud.mode = MBProgressHUDModeText;
    stateHud.detailsLabelText = text;
    stateHud.detailsLabelFont = LMH_FONT_13;
    [stateHud show:YES];
    [stateHud hide:YES afterDelay:1.5];
}

- (void)loadHUD{
    if (!stateHud) {
        stateHud = [[MBProgressHUD alloc] initWithView:self.view];
        stateHud.delegate = self;
        [self.view addSubview:stateHud];
    }
    
    stateHud.mode = MBProgressHUDModeIndeterminate;
    [stateHud show:YES];
}

- (void)hideHUD{
    if (stateHud) {
       [stateHud hide:YES];
    }
}

@end
