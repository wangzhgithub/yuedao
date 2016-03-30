//
//  Voice_AgreementViewController.m
//  VoiceCopanion
//
//  Created by 米翊米 on 15/6/26.
//  Copyright (c) 2015年 米翊米. All rights reserved.
//

#import "Voice_AgreementViewController.h"

@interface Voice_AgreementViewController ()

@end

@implementation Voice_AgreementViewController
@synthesize viewType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (viewType == 0) {
        self.title = @"用户协议";
    }else{
        self.title = @"帮助中心";
    }
    
    UITextView *textView = [[UITextView alloc] initWithFrame:self.view.frame];
    textView.font = LMH_FONT_13;
    textView.textColor = LMH_COLOR_GRAYTEXT;
    textView.editable = NO;
    [self.view addSubview:textView];
    
    if (viewType == 0) {
        textView.text = @"1、使用本“软件”由用户自己承担风险，不论是明示的、默示的或法令的保证和条件，包括但不限于本“软件”的适销性、适用性、无病毒、无疏忽或无技术瑕疵问题、所有权和无侵权的明示或默示的担保和条件，对在任何情况下因使用或不能使用本“软件”所产生的直接、间接、偶然、特殊及后续的损害及风险，不承担任何责任。\n\n2、使用本“软件”涉及到互联网服务，可能会受到各个环节不稳定因素的影响，存在因不可抗力、计算机病毒、黑客攻击、系统不稳定、用户所在位置、用户关机，非法内容信息、骚扰信息屏蔽以及其他任何网络、技术、通信线路、信息安全管理措施等原因造成的服务中断、受阻等不能满足用户要求的风险，用户须明白并自行承担以上风险，用户因此不能发送或接收消息、接收或发错消息，不承担任何责任。\n\n3、因技术故障等不可抗事件影响到服务的正常运行的，承诺在第一时间内与相关单位配合，及时处理进行修复，但用户因此而遭受的经济损失，不承担责任。\n\n4、用户之间通过本“软件”与其他用户交往，因受误导或欺骗而导致或可能导致的任何心理、生理上的伤害以及经济上的损失，由过错方依法承担所有责任，不承担责任。";
    }else if (viewType == 1){
        textView.text = @"1.如何注册\n    下载APP后进入注册界面点击注册，输入您的手机号码，点击获取验证码，根据手机收到的信息填写验证码，设置密码，点击注册即可\n\n2.登录和忘记密码找回\n    本APP软件有自动记住密码功能，每次进入APP无需登录，但是在使用过程中忘记密码我该如何找回呢？登录界面有忘记密码按钮，点击此按钮会出现与注册时相同的操作方法，根据页面提示输入新密码即可\n\n3.如何拨号和发送信息\n    进入APP后主界面即拨号界面，输入号码点击拨号界面的下方电话和短信按钮即可\n\n4.如何给手机通讯录的联系人打电话和发信息\n    点击联系人，跳出同步手机通信录，点确定，即可在联系人页面显示您的手机通讯录，通信录右侧有拨号和短信按钮，点击可做相关操作\n\n5.如何编辑和添加模板\n    点击设置页面，页面上方有模板按钮，点击此按钮选择相应模板做编辑操作，点击添加短信模板按钮，即可添加您需要的短信模板，模板添加好后即可在发送信息中使用\n\n6.如何联系客服\n    设置页面右上角有个设置按钮，点击此按钮可看到客服电话，如您在使用中遇到问题，请及时跟我们联系";
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
