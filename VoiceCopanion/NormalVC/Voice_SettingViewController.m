//
//  Voice_SettingViewController.m
//  VoiceCopanion
//
//  Created by 米翊米 on 15/6/26.
//  Copyright (c) 2015年 米翊米. All rights reserved.
//

#import "Voice_SettingViewController.h"
#import "Voice_AgreementViewController.h"
#import "Voice_AboutViewController.h"

@interface Voice_SettingViewController ()<UIAlertViewDelegate>

@end

@implementation Voice_SettingViewController

- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"关于我们";
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *outBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 220, SCRW-40, 35)];
    outBtn.layer.cornerRadius = 3.0;
    [outBtn.titleLabel setFont:LMH_FONT_15];
    [outBtn setBackgroundColor:LMH_COLOR_BTNBACK];
//    [outBtn setBackgroundImage:LOAD_LOCALIMG(@"background") forState:UIControlStateNormal];
//            [outBtn setBackgroundColor:LMH_COLOR_SKIN];
    [outBtn setTitle:@"退出" forState:UIControlStateNormal];
    [outBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    outBtn.userInteractionEnabled = NO;
    [outBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:outBtn];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    
    NSString *IDF_STR = [NSString stringWithFormat:@"IDF_%zi", section];
    
    if (section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDF_STR];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDF_STR];
            
            UILabel *verLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCRW-90, 0, 80, 44)];
            verLabel.font = LMH_FONT_15;
            verLabel.textColor = LMH_COLOR_GRAYTEXT;
            verLabel.textAlignment = NSTextAlignmentRight;
            NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
            verLabel.text = [NSString stringWithFormat:@"V%@", version];
            
            [cell.contentView addSubview:verLabel];
        }
        cell.textLabel.text = @"约到版本";
        cell.textLabel.font = LMH_FONT_15;
        cell.textLabel.textColor = LMH_COLOR_GRAYTEXT;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (section == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDF_STR];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:IDF_STR];
        }
        cell.textLabel.text = @"用户协议";
        cell.textLabel.font = LMH_FONT_15;
        cell.textLabel.textColor = LMH_COLOR_GRAYTEXT;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (section == 2){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDF_STR];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:IDF_STR];
        }
        cell.textLabel.text = @"帮助中心";
        cell.textLabel.font = LMH_FONT_15;
        cell.textLabel.textColor = LMH_COLOR_GRAYTEXT;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (section == 3){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDF_STR];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IDF_STR];
        }
        cell.textLabel.text = @"客服电话:0571-86822549";
        cell.textLabel.font = LMH_FONT_15;
        cell.textLabel.textColor = LMH_COLOR_GRAYTEXT;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    
    if (section == 1) {
        Voice_AgreementViewController *agreeVC = [[Voice_AgreementViewController alloc] initWithNibName:nil bundle:nil];
        agreeVC.navigationController = self.navigationController;
        agreeVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:agreeVC animated:YES];
    }else if (section == 2){
        Voice_AgreementViewController *agreeVC = [[Voice_AgreementViewController alloc] initWithNibName:nil bundle:nil];
        agreeVC.navigationController = self.navigationController;
        agreeVC.hidesBottomBarWhenPushed = YES;
        agreeVC.viewType = 1;
        [self.navigationController pushViewController:agreeVC animated:YES];
    }else if (section == 3){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"拨打客服电话" message:@"电话:0571-86822549" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
        [alert show];
    }
}

-(void)logout{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:@NO forKey:@"login"];
    [userDef synchronize];
    
    self.tabBarController.selectedIndex = 0;

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://0571-86822549"]]; //拨号
    }
}

@end
