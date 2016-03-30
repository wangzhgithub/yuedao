//
//  Voice_LoginViewController.m
//  VoiceCopanion
//
//  Created by 米翊米 on 15/5/24.
//  Copyright (c) 2015年 米翊米. All rights reserved.
//

#import "Voice_LoginViewController.h"
#import "Voice_RegistViewController.h"

@interface Voice_LoginViewController ()<UITextFieldDelegate>
{
    UITextField *aField;
    UITextField *pField;
    UIScrollView *scrollView;
    
    BOOL is_remember;
    NSString *userName;
    NSString *passWord;
    CGRect vFrame;
    NSUserDefaults *userDef;
}

@end

@implementation Voice_LoginViewController

+ (void)showInViewController:(id<LoginDelegate>)mainVC
{
    Voice_LoginViewController *loginVC = [[Voice_LoginViewController alloc] initWithNibName:nil bundle:nil];

    [loginVC setDelegate:mainVC];
    NavigationContrller *navc = [[NavigationContrller alloc] initWithRootViewController:loginVC];
    loginVC.navigationController = navc;
    [(UIViewController*)mainVC presentViewController:navc animated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        is_remember = YES;
        
        userDef = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"登录";
    
    [self createUI];
    
    [self.navigationController addLeftBarItem];
    [self.navigationController addRightBarItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)leftBarItemClick{
    if ([self.delegate respondsToSelector:@selector(didLogin)]) {
        [self.delegate didLogin];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightBarItemClick{
    [self registBtn:nil];
}

- (void)createUI{
    vFrame = self.view.frame;
    
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    
    CGFloat frameH = 30.0;
    
    UIImageView *aImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCRW/8, 40, frameH, frameH)];
    aImgView.image = LOAD_LOCALIMG(@"number1");
    [scrollView addSubview:aImgView];
    
    UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(aImgView.frame)+2, CGRectGetMinY(aImgView.frame), 75, frameH)];
    aLabel.font = LMH_FONT_15;
    aLabel.textColor = LMH_COLOR_LGTGRAYTEXT;
    aLabel.text = @"手机号：";
    [scrollView addSubview:aLabel];
    
    aField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(aLabel.frame), CGRectGetMinY(aLabel.frame), SCRW - CGRectGetMaxX(aLabel.frame)-SCRW/8, frameH)];
    aField.font = LMH_FONT_15;
    aField.layer.borderWidth = 0.5;
    aField.layer.borderColor = LMH_COLOR_LINE.CGColor;
    aField.textColor = LMH_COLOR_LGTGRAYTEXT;
    aField.returnKeyType = UIReturnKeyNext;
    aField.keyboardType = UIKeyboardTypeNumberPad;
//    aField.clearButtonMode = UITextFieldViewModeWhileEditing;
    aField.delegate = self;
    [scrollView addSubview:aField];
    
    if ([userDef objectForKey:@"username"]) {
        aField.text = [userDef objectForKey:@"username"];
        
    }
    
    UIImageView *pImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCRW/8, CGRectGetMaxY(aLabel.frame)+20, frameH, frameH)];
    pImgView.image = LOAD_LOCALIMG(@"password");
    [scrollView addSubview:pImgView];
    
    UILabel *pLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pImgView.frame)+2, CGRectGetMinY(pImgView.frame), 75, frameH)];
    pLabel.font = LMH_FONT_15;
    pLabel.textColor = LMH_COLOR_LGTGRAYTEXT;
    pLabel.text = @"密   码：";
    [scrollView addSubview:pLabel];
    
    pField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pLabel.frame), CGRectGetMinY(pLabel.frame), SCRW - CGRectGetMaxX(pLabel.frame)-SCRW/8, frameH)];
    pField.font = LMH_FONT_15;
    pField.layer.borderWidth = 0.5;
    pField.layer.borderColor = LMH_COLOR_LINE.CGColor;
    pField.textColor = LMH_COLOR_LGTGRAYTEXT;
    pField.clearsOnBeginEditing = YES;
    pField.secureTextEntry = YES;
    pField.returnKeyType = UIReturnKeyDone;
//    pField.clearButtonMode = UITextFieldViewModeWhileEditing;
    pField.delegate = self;
    [scrollView addSubview:pField];
    
    UIButton *imgBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCRW/8, CGRectGetMaxY(pImgView.frame)+40, frameH, frameH)];
    [imgBtn setImage:LOAD_LOCALIMG(@"check") forState:UIControlStateNormal];
    [imgBtn setImage:LOAD_LOCALIMG(@"check_no") forState:UIControlStateSelected];
    [imgBtn addTarget:self action:@selector(imgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:imgBtn];
    
    if ([userDef objectForKey:@"password"]) {
        pField.text = [userDef objectForKey:@"password"];
        imgBtn.selected = NO;
    }
    
    UILabel *rLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgBtn.frame)+5, CGRectGetMinY(imgBtn.frame), 80, frameH)];
    rLabel.font = LMH_FONT_15;
    rLabel.textColor = LMH_COLOR_GRAYTEXT;
    rLabel.text = @"记住密码";
    [scrollView addSubview:rLabel];
    
    UIButton *findBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCRW-SCRW/8-80, CGRectGetMinY(imgBtn.frame), 80, frameH)];
    [findBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [findBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [findBtn.titleLabel setFont:LMH_FONT_15];
    findBtn.layer.cornerRadius = 3.0;
    [findBtn setBackgroundColor:LMH_COLOR_ORANGE];
    [findBtn addTarget:self action:@selector(registBtn:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:findBtn];
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCRW/16, CGRectGetMaxY(findBtn.frame)+35, SCRW/8*7, 35)];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [loginBtn setTitle:@"登   录" forState:UIControlStateNormal];
    [loginBtn.titleLabel setFont:LMH_FONT_15];
    [loginBtn setBackgroundColor:LMH_COLOR_BTNBACK];
//    [loginBtn setBackgroundColor:LMH_COLOR_SKIN];
    loginBtn.layer.cornerRadius = 3.0;
    [loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:loginBtn];
    
    scrollView.contentSize = CGSizeMake(SCRW, CGRectGetMaxY(loginBtn.frame)+10);
}

- (void)registBtn:(id)sender{
    Voice_RegistViewController *registVC = [[Voice_RegistViewController alloc] initWithNibName:nil bundle:nil];
    registVC.navigationController = self.navigationController;
    registVC.hidesBottomBarWhenPushed = YES;

    if (sender) {
        registVC.type = 3;//忘记密码
    }else{
        registVC.type = 2;//注册账号
    }
    [self.navigationController pushViewController:registVC animated:YES];
    
    [registVC setRegistBlock:^() {
        if ([self.delegate respondsToSelector:@selector(didLogin)]) {
            [self.delegate didLogin];
        }
    }];
}

- (void)imgBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (!sender.selected) {
        is_remember = YES;
    }else{
        is_remember = NO;
    }
}

- (void)loginClick{
    NSString *telephoneRegex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0-9]))\\d{8}$";
    NSPredicate *telephoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telephoneRegex];
    
    if (![telephoneTest evaluateWithObject:aField.text] && aField.text.length != 11) {
        [self textStateHUD:@"请输入正确的手机号码"];
        return;
    }
    
    NSString *passRegex = @"^[0-9a-zA-Z_@#$%&*]{6,16}$";
    NSPredicate *passTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passRegex];
    
    if (![passTest evaluateWithObject:pField.text]) {
        [self textStateHUD:@"密码为6~16位字符"];
        return;
    }
    
    userName = [aField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    userName = [userName stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    passWord = [pField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    passWord = [passWord stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [self loginRequest];
}

- (void)loginRequest{
    [self loadHUD];
    NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [subParams setObject:userName forKey:@"phone"];
    [subParams setObject:passWord forKey:@"userPwd"];
    
    [KTProxy loadWithMethod:@"user_login.action" andParams:subParams completed:^(NSString *resp, NSStringEncoding encoding) {
        [self performSelectorOnMainThread:@selector(loginResponse:) withObject:resp waitUntilDone:YES];
    } failed:^(NSError *error) {
        [self textStateHUD:@"网络连接失败"];
    }];
}

- (void)loginResponse:(NSString *)resp{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        if([respDict isKindOfClass:[NSDictionary class]]){
            NSInteger code = [respDict[@"retCode"] integerValue];
            
            if (code == 1) {
                [self textStateHUD:@"登陆成功"];
                
                [self loginOK:respDict[@"sessionId"]];
                return;
            } else {
                id messageObj = respDict[@"retMsg"];
                [self textStateHUD:messageObj];
                return;
            }
        }
    }
    [self textStateHUD:@"登录失败"];
}

- (void)loginOK:(NSString *)sessionId{
    [userDef setObject:@YES forKey:@"login"];
    
    if ([self.delegate respondsToSelector:@selector(didLogin)]) {
        [self.delegate didLogin];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [userDef setObject:userName forKey:@"username"];
    if (is_remember) {
        [userDef setObject:passWord forKey:@"password"];
    }else{
        [userDef setObject:@"" forKey:@"password"];
    }
    
    if (sessionId) {
        [userDef setObject:sessionId forKey:@"sessionId"];
    }
    
    [userDef synchronize];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (text.length > 11 && textField == aField) {
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == aField) {
        [pField becomeFirstResponder];
        return YES;
    }
    [textField resignFirstResponder];
    
    return YES;
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat hOffset = endKeyboardRect.size.height;
    CGFloat yOffset = endKeyboardRect.origin.y;
    
    CGRect frame = vFrame;
    if (yOffset == SCRH) {
        scrollView.frame = vFrame;
    }else{
        frame.size.height -= hOffset;
        scrollView.frame = frame;
    }
}

- (void)hideKeyboard{
    [self.view endEditing:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

@end
