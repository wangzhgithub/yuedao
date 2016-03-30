//
//  Voice_ThreedViewController.m
//  VoiceCopanion
//
//  Created by 米翊米 on 15/5/27.
//  Copyright (c) 2015年 米翊米. All rights reserved.
//

#import "Voice_ThreedViewController.h"
#import "Voice_ResetViewController.h"
#import "Voice_SettingViewController.h"

@interface Voice_ThreedViewController (){
    UITextView *contentView;
    UILabel *smsNumLabel;
    UIButton *resetBtn;
    UILabel *phoneNumLabel;
    UIButton *rechargeBtn;
    
    NSNumber *useAble;
    NSNumber *byUse;
    BOOL isopen;
    NSUserDefaults *def;
}
@end

@implementation Voice_ThreedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"短信设置";
        def = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightBtn setTitle:@"设置" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(setClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    UINavigationItem * navItem = self.navigationController.topViewController.navigationItem;
    [navItem setRightBarButtonItem:rightItem animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (contentView) {
        NSString *tent = [def objectForKey:@"tent"];
        if (tent) {
            contentView.text = [NSString stringWithFormat:@"%@" ,tent];
            [resetBtn setTitle:@"内容重置" forState:UIControlStateNormal];
        }else{
            contentView.text = @"";
            [resetBtn setTitle:@"设置短信内容" forState:UIControlStateNormal];
        }
    }
}

- (void)createUI{
    phoneNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, SCRW-40, 20)];
    phoneNumLabel.textColor = LMH_COLOR_BLACKTEXT;
    phoneNumLabel.font = LMH_FONT_15;
    phoneNumLabel.text = @"短信内容:";
    [self.view addSubview:phoneNumLabel];
    
    contentView = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMinX(phoneNumLabel.frame), CGRectGetMaxY(phoneNumLabel.frame)+5, SCRW-40, (SCRW-40)/4*3)];
    contentView.font = LMH_FONT_15;
    contentView.textColor = LMH_COLOR_BLACKTEXT;
    contentView.layer.borderColor = LMH_COLOR_GRAYTEXT.CGColor;
    contentView.layer.borderWidth = 0.5;
    contentView.userInteractionEnabled = NO;
    [self.view addSubview:contentView];
    
    NSString *tent = [def objectForKey:@"tent"];
    if (tent) {
        contentView.text = [NSString stringWithFormat:@"%@" ,tent];
    }
    
    resetBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(contentView.frame)+10, SCRW-40, 40)];
    resetBtn.layer.cornerRadius = 3.0;
    [resetBtn.titleLabel setFont:LMH_FONT_15];
    [resetBtn setBackgroundColor:LMH_COLOR_BTNBACK];
    if (contentView.text.length > 0) {
        [resetBtn setTitle:@"内容重置" forState:UIControlStateNormal];
    }else{
        [resetBtn setTitle:@"设置短信内容" forState:UIControlStateNormal];
    }
    [resetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [resetBtn addTarget:self action:@selector(resetClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resetBtn];
}

- (void)resetClick{
    Voice_ResetViewController *resetVC = [[Voice_ResetViewController alloc] initWithNibName:nil bundle:nil];
    resetVC.hidesBottomBarWhenPushed = YES;
    resetVC.navigationController = self.navigationController;
    [self.navigationController pushViewController:resetVC animated:YES];
}

- (void)setClick{
    Voice_SettingViewController *setVC = [[Voice_SettingViewController alloc] initWithStyle:UITableViewStylePlain];
    setVC.navigationController = self.navigationController;
    setVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setVC animated:YES];
}

@end
