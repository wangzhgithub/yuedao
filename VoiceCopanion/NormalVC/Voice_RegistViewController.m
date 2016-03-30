//
//  Voice_RegistViewController.m
//  VoiceCopanion
//
//  Created by 米翊米 on 15/5/26.
//  Copyright (c) 2015年 米翊米. All rights reserved.
//

#import "Voice_RegistViewController.h"
#import "Voice_Threed_ViewController.h"

@interface Voice_RegistViewController ()<UITextFieldDelegate,UITextViewDelegate>
{
    UITextField *aField;
    UITextField *pField;
    UITextField *cField;
    UIScrollView *scrollView;
    
    NSString *userName;
    NSString *passWord;
    NSString *authCode;
    CGRect vFrame;
    UIView *myUIview;
    NSUserDefaults *userDef;
    
}

@end

@implementation Voice_RegistViewController

+ (void)showInViewController:(id<RegistDelegate>)mainVC
{
    Voice_RegistViewController *registVC = [[Voice_RegistViewController alloc] initWithNibName:nil bundle:nil];
    
    [registVC setDelegate:mainVC];
    NavigationContrller *navc = [[NavigationContrller alloc] initWithRootViewController:registVC];
    registVC.navigationController = navc;
    [(UIViewController*)mainVC presentViewController:navc animated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"注册";
        self.type = 0;
        
        userDef = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController addLeftBarItem];
    
    [self createUI];
//    [self createRightBarButonItem];
    if (self.type == 3) {
        self.title = @"找回密码";
    }
    
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


- (void)createRightBarButonItem
{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 30)];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = LMH_FONT_15;
    [rightBtn setTitleColor:LMH_COLOR_BTNBACK forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(registClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    UINavigationItem * navItem = self.navigationController.topViewController.navigationItem;
    [navItem setRightBarButtonItem:rightItem animated:YES];
}


- (void)leftBarItemClick{
    if (self.type == 1) {//首页过来的
        if ([self.delegate respondsToSelector:@selector(didRegist)]) {
            [self.delegate didRegist];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if(self.type == 2){//登录页过来的
        [self.navigationController popViewControllerAnimated:YES];
    }else{//登录页过来的
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)createUI{
    vFrame = self.view.frame;
    myUIview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCRW, SCRH)];
    myUIview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:myUIview];
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.backgroundColor = [UIColor whiteColor];
    [myUIview addSubview:scrollView];
    
    CGFloat frameH = 30.0;
    
    UIImageView *aImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCRW/8, 40, frameH, frameH)];
    aImgView.image = LOAD_LOCALIMG(@"number1");
    [myUIview addSubview:aImgView];
    
    UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(aImgView.frame)+2, CGRectGetMinY(aImgView.frame), 75, frameH)];
    aLabel.font = LMH_FONT_15;
    aLabel.textColor = LMH_COLOR_LGTGRAYTEXT;
    aLabel.text = @"手机号：";
    [myUIview addSubview:aLabel];
    
    aField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(aLabel.frame), CGRectGetMinY(aLabel.frame), SCRW - CGRectGetMaxX(aLabel.frame)-SCRW/8, frameH)];
    aField.font = LMH_FONT_15;
    aField.layer.borderWidth = 0.5;
    aField.layer.borderColor = LMH_COLOR_LINE.CGColor;
    aField.textColor = LMH_COLOR_LGTGRAYTEXT;
    aField.returnKeyType = UIReturnKeyNext;
    aField.keyboardType = UIKeyboardTypeNumberPad;
//    aField.clearButtonMode = UITextFieldViewModeWhileEditing;
    aField.delegate = self;
    [myUIview addSubview:aField];
    
    UIButton *authBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCRW/8, CGRectGetMaxY(aField.frame)+20, 65+frameH, frameH)];
    authBtn.layer.cornerRadius = 3.0;
    authBtn.backgroundColor = LMH_COLOR_ORANGE;
    [authBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [authBtn.titleLabel setFont:LMH_FONT_15];
    [authBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [authBtn addTarget:self action:@selector(authClick) forControlEvents:UIControlEventTouchUpInside];
    [myUIview addSubview:authBtn];
    
    cField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(authBtn.frame)+12, CGRectGetMinY(authBtn.frame), SCRW - CGRectGetMaxX(authBtn.frame)-SCRW/8-12, frameH)];
    cField.font = LMH_FONT_15;
    cField.layer.borderWidth = 0.5;
    cField.layer.borderColor = LMH_COLOR_LINE.CGColor;
    cField.textColor = LMH_COLOR_LGTGRAYTEXT;
    cField.placeholder = @"请输入验证码";
    cField.returnKeyType = UIReturnKeyNext;
//    cField.clearButtonMode = UITextFieldViewModeWhileEditing;
    cField.delegate = self;
    [myUIview addSubview:cField];

    UIImageView *pImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCRW/8, CGRectGetMaxY(cField.frame)+20, frameH, frameH)];
    pImgView.image = LOAD_LOCALIMG(@"password");
    [myUIview addSubview:pImgView];
    
    UILabel *pLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pImgView.frame)+2, CGRectGetMinY(pImgView.frame), 75, frameH)];
    pLabel.font = LMH_FONT_15;
    pLabel.textColor = LMH_COLOR_LGTGRAYTEXT;
    pLabel.text = @"密   码：";
    if (self.type == 3) {
        pLabel.text = @"新密码";
    }
    [myUIview addSubview:pLabel];
    
    pField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pLabel.frame), CGRectGetMinY(pLabel.frame), SCRW - CGRectGetMaxX(pLabel.frame)-SCRW/8, frameH)];
    pField.font = LMH_FONT_15;
    pField.layer.borderWidth = 0.5;
    pField.layer.borderColor = LMH_COLOR_LINE.CGColor;
    pField.textColor = LMH_COLOR_LGTGRAYTEXT;
    pField.clearsOnBeginEditing = YES;
    pField.secureTextEntry = YES;
    pField.returnKeyType = UIReturnKeyDone;
    pField.clearButtonMode = UITextFieldViewModeWhileEditing;
    pField.delegate = self;
    [myUIview addSubview:pField];
    
    UIButton *registBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCRW/16, CGRectGetMaxY(pField.frame)+35, SCRW/8*7, 35)];
    [registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [registBtn setTitle:@"注    册" forState:UIControlStateNormal];
    if (self.type == 3) {
        [registBtn setTitle:@"确    认" forState:UIControlStateNormal];
    }
    [registBtn.titleLabel setFont:LMH_FONT_15];
//    [registBtn setBackgroundColor:LMH_COLOR_SKIN];
    [registBtn setBackgroundColor:LMH_COLOR_BTNBACK];
    registBtn.layer.cornerRadius = 3.0;
    [registBtn addTarget:self action:@selector(registClick:) forControlEvents:UIControlEventTouchUpInside];
    [myUIview addSubview:registBtn];
    
    scrollView.contentSize = CGSizeMake(SCRW, CGRectGetMaxY(registBtn.frame)+10);
}

- (void)registClick:(UIButton *)sender{
    NSString *telephoneRegex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0-9]))\\d{8}$";
    NSPredicate *telephoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telephoneRegex];
    
    if (![telephoneTest evaluateWithObject:aField.text] && aField.text.length != 11) {
        [self textStateHUD:@"请输入正确的手机号码"];
        return;
    }
    
    NSString *authRegex = @"^[0-9a-zA-Z_@#$%&*]{4,16}$";
    NSPredicate *authTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", authRegex];
    
    if (![authTest evaluateWithObject:cField.text]) {
        [self textStateHUD:@"验证码为4~16位字符"];
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
    
    authCode = [cField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    authCode = [authCode stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [self registResqut];
}

- (void)authClick{
    NSString *telephoneRegex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0-9]))\\d{8}$";
    NSPredicate *telephoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telephoneRegex];
    
    if (![telephoneTest evaluateWithObject:aField.text] && aField.text.length != 11) {
        [self textStateHUD:@"请输入正确的手机号码"];
        return;
    }
    
    userName = [aField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    userName = [userName stringByReplacingOccurrencesOfString:@" " withString:@""];

    [self getAuthCode];
}

- (void)setRegistBlock:(registBlock)block{
    _registBlock = block;
}

- (void)getAuthCode{
    [self loadHUD];
    NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [subParams setObject:userName forKey:@"phone"];
    
    [KTProxy loadWithMethod:@"user_getValidateCode.action" andParams:subParams completed:^(NSString *resp, NSStringEncoding encoding) {
        [self performSelectorOnMainThread:@selector(getAuthCodeResponse:) withObject:resp waitUntilDone:YES];
    } failed:^(NSError *error) {
        [self textStateHUD:@"网络连接失败"];
    }];
}

- (void)getAuthCodeResponse:(NSString *)resp{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        if([respDict isKindOfClass:[NSDictionary class]]){
            NSInteger code = [respDict[@"retCode"] integerValue];
            
            if (code == 1) {
                [self textStateHUD:@"验证码已发送"];
                return;
            } else {
                id messageObj = respDict[@"retMsg"];
                [self textStateHUD:messageObj];
                return;
            }
        }
    }
    [self textStateHUD:@"验证码获取失败"];
}

- (void)registResqut{
    [self loadHUD];
    NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [subParams setObject:userName forKey:@"phone"];
    [subParams setObject:passWord forKey:@"userPwd"];
    [subParams setObject:authCode forKey:@"code"];
    
    NSString *actionStr = @"";
    if (self.type == 3) {
        actionStr = @"user_resetPassword.action";
    }else{
        actionStr = @"user_register.action";
    }
    
    [KTProxy loadWithMethod:actionStr andParams:subParams completed:^(NSString *resp, NSStringEncoding encoding) {
        [self performSelectorOnMainThread:@selector(registResponse:) withObject:resp waitUntilDone:YES];
    } failed:^(NSError *error) {
        [self textStateHUD:@"网络连接失败"];
    }];
}

- (void)registResponse:(NSString *)resp{
    if (resp) {
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
        
        if([respDict isKindOfClass:[NSDictionary class]]){
            NSInteger code = [respDict[@"retCode"] integerValue];
            
            if (code == 1) {
                [self textStateHUD:@"注册成功"];
                if (self.type == 3) {
                    [self textStateHUD:@"找回密码成功"];
                }
                
                [self registOK:respDict[@"sessionId"]];
                return;
            } else {
                id messageObj = respDict[@"retMsg"];
                [self textStateHUD:messageObj];
                return;
            }
        }
    }
    [self textStateHUD:@"网络连接失败"];
}

- (void)registOK:(NSString *)sessionId{
    [userDef setObject:@YES forKey:@"login"];
    [userDef setObject:userName forKey:@"username"];
    [userDef setObject:passWord forKey:@"password"];
    NSString *registUserID;
    NSUserDefaults *def;
    if (sessionId) {
    
        def = [NSUserDefaults standardUserDefaults];
        registUserID = [userName stringByAppendingString:@"_first"];
        [def setValue:@YES forKey:registUserID];
        [userDef setObject:sessionId forKey:@"sessionId"];
    }
    [userDef synchronize];
    if (registUserID) {
        if ([[def objectForKey:registUserID] boolValue]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"DIDIMAGEVIEW" object:nil];
            [def setValue:@YES forKey:registUserID];
            [def synchronize];
        }
    }
    if (_registBlock) {
        _registBlock();
    }

    [self dismissViewControllerAnimated:YES completion:nil];
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
        [cField becomeFirstResponder];
        return YES;
    }else if(textField == cField){
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
