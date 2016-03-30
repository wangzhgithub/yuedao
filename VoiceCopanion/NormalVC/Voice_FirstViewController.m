//
//  Voice_FirstViewController.m
//  VoiceCopanion
//
//  Created by 米翊米 on 15/5/10.
//  Copyright (c) 2015年 米翊米. All rights reserved.
//

#import "Voice_FirstViewController.h"
#import "Voice_LoginViewController.h"
#import "Voice_RegistViewController.h"
#import "THContact.h"
#import "UIDevice+Resolutions.h"
#import <objc/runtime.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "Voice_SmsView.h"
#import "NSDate+Helper.h"
#import "PopoverViewController.h"

@interface Voice_FirstViewController ()<UITableViewDelegate,UITableViewDataSource,LoginDelegate,RegistDelegate,MFMessageComposeViewControllerDelegate,Voice_SmsViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIPopoverPresentationControllerDelegate,MBProgressHUDDelegate>
{
    UIView *numberView;
    UIView *leftbtnView;
    UIView *centerbtnView;
    UIView *rightbtnView;
    UILabel *phoneNumlbl;
    UIView *phoneView;
    UIImageView *imgView;
    UIButton *leftBtn;
    UIButton *rightBtn;
    UIButton *callBtn;
    UIButton *smsBtn;
    Voice_SmsView *smsView;
    
    NSMutableString *numStr;
    NSArray *recordArray;
    THContact *tmpCont;
    THContact *useCont;
    NSMutableArray *searchResults;
    NSArray *letterArr;
    
    UIView *addTableView;
    UITextField *titFiled;
    UITextView *contentView;
    UILabel *placeholderLab;
    
    MBProgressHUD *stateHud;
    
    float  sizeNumberView;
    
}

@property (strong, nonatomic) PopoverViewController *butPopVC;
@end

@implementation Voice_FirstViewController

- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
        numStr = [[NSMutableString alloc] init];
        searchResults = [[NSMutableArray alloc] init];
        tmpCont = [[THContact alloc] init];
        letterArr = [NSArray arrayWithObjects:@"ABC",@"DEF",@"GHI",@"JKL",@"MNO",@"PQRS",@"TUV",@"WXYZ",nil];
        self.navigationItem.title = @"通话记录";
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableview.frame = CGRectMake(0, 0, SCRW, (SCRH-NAVHEIGHT-TABHEIGHT)- 275+(275*(SCRH-568)/568));
    
    sizeNumberView = 275+(275*(SCRH-568)/568);
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self layoutNumView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didImageView) name:@"DIDIMAGEVIEW" object:nil];
    smsView = [[Voice_SmsView alloc] initWithFrame:self.view.frame];
    smsView.smsDelegate = self;
    [self.view addSubview:smsView];
    smsView.hidden = YES;
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showLoginView];
    
    [self flashRecord];
    phoneView.hidden = YES;
    [self showClick];
    phoneNumlbl.text = @"";
    tmpCont.phoneNumber = @"";
    tmpCont.fullName = @"";
    [numStr setString:@""];
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}



- (void)createAddUI{
    
    
    addTableView = [[UIView alloc] initWithFrame:CGRectMake(0,0,SCRW,SCRH)];
    addTableView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo:)];
    [addTableView addGestureRecognizer:tapGesture];
    [[[[UIApplication sharedApplication] windows] objectAtIndex:0] addSubview:addTableView];
    
    [titFiled removeFromSuperview];
    titFiled = [[UITextField alloc] initWithFrame:CGRectMake(20, 130, SCRW-40, 30)];
    titFiled.placeholder = @"请输入模板标题(限10字符以内)";
    titFiled.text = @"通用模板1";
    [titFiled becomeFirstResponder];
    titFiled.textColor = LMH_COLOR_GRAYTEXT;
    titFiled.font = LMH_FONT_15;
    titFiled.layer.borderColor = LMH_COLOR_GRAYTEXT.CGColor;
    titFiled.layer.borderWidth = 0.5;
    titFiled.delegate = self;
    
    [addTableView addSubview:titFiled];
    
    [contentView removeFromSuperview];
    contentView = [[UITextView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(titFiled.frame)+20, SCRW-40, (SCRW-40)/2)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.borderColor = LMH_COLOR_GRAYTEXT.CGColor;
    contentView.text = @"尊敬的客户，您好，我是[   ],由于您的电话无法接听，特发此条信息告知，如有打扰，尽请谅解，若有疑问请回复本机。";
    contentView.layer.borderWidth = 0.5;
    contentView.font = LMH_FONT_15;
    contentView.textColor = LMH_COLOR_GRAYTEXT;
    contentView.delegate = self;
    
    [addTableView addSubview:contentView];
    
    placeholderLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 200, 20)];
    placeholderLab.text = @"请填写内容，不超过70个字";
    placeholderLab.textColor = LMH_COLOR_LGTGRAYTEXT;
    placeholderLab.font = LMH_FONT_15;
    [contentView addSubview:placeholderLab];
    placeholderLab.hidden = YES;
    
    UIButton *addOKBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(contentView.frame)+20, SCRW-40, 40)];
    addOKBtn.layer.cornerRadius = 3.0;
    [addOKBtn.titleLabel setFont:LMH_FONT_15];
    [addOKBtn setBackgroundColor:LMH_COLOR_BTNBACK];
    [addOKBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [addOKBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addOKBtn setBackgroundImage:LOAD_LOCALIMG(@"btnBack") forState:UIControlStateHighlighted];
    [addOKBtn addTarget:self action:@selector(addOKClick) forControlEvents:UIControlEventTouchUpInside];
    [addTableView addSubview:addOKBtn];
    addTableView.hidden = NO;
    numberView.hidden = YES;
    leftbtnView.hidden = YES;
    centerbtnView.hidden = YES;
    rightbtnView.hidden = YES;
    
}


-(void)Actiondo:(id)sender
{
    [titFiled resignFirstResponder];
    [contentView resignFirstResponder];
}

-(void)addOKClick{
    
    NSInteger smsIndex = 1;
    NSUserDefaults  *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary = [userDef dictionaryRepresentation];
    for(NSString* key in [dictionary allKeys]){
        if([key rangeOfString:@"title_"].location !=NSNotFound || [key rangeOfString:@"tent_"].location !=NSNotFound) {
            [userDef removeObjectForKey:key];
            [userDef synchronize];
        }
    }
    if (titFiled.text.length == 0) {
        [self textStateHUD:@"请设置标题"];
        return;
    }
    
    if (contentView.text.length <= 0) {
        [self textStateHUD:@"短信内容不能为空"];
        return;
    }else{
        
        [userDef setObject:titFiled.text forKey:[NSString stringWithFormat:@"title_%zi", smsIndex]];
        [userDef setObject:contentView.text forKey:[NSString stringWithFormat:@"tent_%zi", smsIndex]];
        [self textStateHUD:@"模板添加成功"];
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        //根据键值取出name
        NSString *userName = [defaults objectForKey:@"username"];
        NSString *registUserID = [userName stringByAppendingString:@"_first"];
        if ([[defaults objectForKey:registUserID] boolValue]) {
            
            [defaults setValue:@NO forKey:registUserID];
            [defaults synchronize];
        }
        addTableView.hidden = YES;
        numberView.hidden = NO;
    } 
}

- (void)textStateHUD:(NSString *)text
{
    if (!stateHud) {
        stateHud = [[MBProgressHUD alloc] initWithView:self.view];
        stateHud.delegate = self;
        [addTableView addSubview:stateHud];
    }
    stateHud.mode = MBProgressHUDModeText;
    stateHud.detailsLabelText = text;
    stateHud.detailsLabelFont = LMH_FONT_13;
    [stateHud show:YES];
    [stateHud hide:YES afterDelay:1.5];
}

- (void)showLoginView{
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"login"] boolValue]) {
        if (!imgView) {
            imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCRW, SCRH)];
            if ([[[DeviceModel shareModel] phoneType] hasPrefix:@"iPhone 4"]) {
                imgView.image = LOAD_LOCALIMG(@"4S");
            }else{
                imgView.image = LOAD_LOCALIMG(@"5S");
            }
            imgView.userInteractionEnabled = YES;
            
            UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, SCRH-70, (SCRW-60)/2, 35)];
            [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
            [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [loginBtn.titleLabel setFont:LMH_FONT_15];
            loginBtn.backgroundColor = LMH_COLOR_SKIN;
            loginBtn.layer.cornerRadius = 3.0;
            loginBtn.tag = 1001;
            [loginBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [imgView addSubview:loginBtn];
            
            UIButton *registBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(loginBtn.frame)+20, SCRH-70, (SCRW-60)/2, 35)];
            [registBtn setTitle:@"注册" forState:UIControlStateNormal];
            [registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [registBtn.titleLabel setFont:LMH_FONT_15];
            registBtn.backgroundColor = LMH_COLOR_SKIN;
            registBtn.layer.cornerRadius = 3.0;
            registBtn.tag = 1002;
            [registBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [imgView addSubview:registBtn];
            
            [[[[UIApplication sharedApplication] windows] objectAtIndex:0] addSubview:imgView];
        }
        imgView.hidden = NO;
    }
}

- (void)flashRecord{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *record = [defaults objectForKey:@"record"];
    
    if (record) {
        recordArray = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:record];
    }
    
    [self.tableview reloadData];
}

- (void)layoutNumView{
    //整视图
    numberView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableview.frame), SCRW, sizeNumberView)];
    numberView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:numberView];
    
    //隐藏或者显示号码的
    //显示号码的
    phoneNumlbl = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, SCRW-80, 30)];
    phoneNumlbl.font = LMH_FONT_25;
//    [phoneNumlbl setFont:[UIFont fontWithName:@"Arial-BoldItalicMT" size:25]];
    phoneNumlbl.textAlignment = NSTextAlignmentCenter;
    phoneNumlbl.lineBreakMode = NSLineBreakByTruncatingHead;
    [numberView addSubview:phoneNumlbl];
    
    
    //分割线
    //    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 29, SCRW, 1)];
    //    line.backgroundColor = LMH_COLOR_BACKGROUND;
    //    [numberView addSubview:line];
    
    //号码数字视图
    phoneView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, SCRW, CGRectGetHeight(numberView.frame)-75)];
    phoneView.backgroundColor = [UIColor whiteColor];
    [numberView addSubview:phoneView];
    
    
    int totalCol = 3;
    //控件的长度
    CGFloat viewW = SCRW/3;
    //控件的高度
    CGFloat viewH = (sizeNumberView-75)/4-5;
    //控件横向间隔距离
    CGFloat marginX = (SCRW - totalCol * viewW) / (totalCol + 1);
    //控件纵向间隔距离
    CGFloat marginY = 5;
    //控件开始的纵坐标
    CGFloat startY = 0;
    for (int i = 0; i < 12; i++) {
        
        int row = i / totalCol;
        //        NSLog(@"行数为：%d",row);
        int col = i % totalCol;
        //        NSLog(@"列数为：%d",col);
        //        NSLog(@"--------------------");
        CGFloat x = marginX + (viewW + marginX) * col;
        CGFloat y = startY + marginY + (viewH + marginY) * row;
        
        if (col < 2) {
            UILabel *lineLbl = [[UILabel alloc] initWithFrame:CGRectMake(x + viewW + marginX/2, y, 0.5, viewH+5)];
            [lineLbl setBackgroundColor:[UIColor grayColor]];
            [phoneView addSubview:lineLbl];
        }
        
        
        UILabel *lineLbls = [[UILabel alloc] initWithFrame:CGRectMake(x, y, SCRW/3, 0.5)];
        [lineLbls setBackgroundColor:[UIColor grayColor]];
        [phoneView addSubview:lineLbls];
        if (row == 3) {
            UILabel *lineLbls = [[UILabel alloc] initWithFrame:CGRectMake(x, y+viewH+5, SCRW/3, 0.5)];
            [lineLbls setBackgroundColor:[UIColor grayColor]];
            [phoneView addSubview:lineLbls];
            
        }
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(x, y, viewW, viewH);
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake((SCRW/3)/2+10, 0, viewW, viewH)];
        //        btn.layer.borderColor = LMH_COLOR_BLACKTEXT.CGColor;
        //        btn.layer.borderWidth = 1.0;
//        btn.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:30];
        [btn.titleLabel setFont:LMH_FONT_30];
        lab.font = LMH_FONT_10;
        if (i < 9) {
            [btn setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
            if (i > 0) {
                lab.text = letterArr[i-1];
            }
            
        }else if(i == 9){
//            [btn setBackgroundImage:LOAD_LOCALIMG(@"button") forState:UIControlStateNormal];
            [btn setTitle:@"✱" forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont fontWithName:@"Georgia" size:35]];
        }else if(i == 10){
            [btn setTitle:@"0" forState:UIControlStateNormal];
            lab.text = @"+";
        }else if(i == 11){
            [btn setTitle:@"＃" forState:UIControlStateNormal];
        }
        
        [btn setTitleColor:LMH_COLOR_GRAYTEXT forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        btn.tag = 1000+i;
        [btn addTarget:self action:@selector(numberClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn addSubview:lab];
        [phoneView addSubview:btn];
        
    }
    
    //    //绘画数字键
    //    CGFloat btnW = (SCRW-210)/3*5/4;
    //    CGFloat offsetX = (SCRW - (SCRW-200)/3*5/4*3)/4;
    //
    //    for (int i = 0; i < 12; i++) {
    //        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnW*(i%3)+offsetX+(i%3)*offsetX, 5+i/3*btnW+5*((i/3)+1), btnW, btnW)];
    //        btn.layer.borderColor = LMH_COLOR_BLACKTEXT.CGColor;
    //        btn.layer.borderWidth = 1.0;
    //        btn.layer.cornerRadius = btnW/2;
    //        [btn.titleLabel setFont:LMH_FONT_30];
    //
    //        if (i < 9) {
    //            [btn setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
    //        }else if(i == 9){
    //            [btn setTitle:@"✱" forState:UIControlStateNormal];
    //            [btn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:40]];
    //        }else if(i == 10){
    //            [btn setTitle:@"0" forState:UIControlStateNormal];
    //        }else if(i == 11){
    //            [btn setTitle:@"＃" forState:UIControlStateNormal];
    //        }
    //
    //        [btn setTitleColor:LMH_COLOR_GRAYTEXT forState:UIControlStateNormal];
    //        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    //        btn.tag = 1000+i;
    //        [btn addTarget:self action:@selector(numberClick:) forControlEvents:UIControlEventTouchUpInside];
    //        [phoneView addSubview:btn];
    //    }
    
    leftbtnView = [[UIView alloc]initWithFrame:CGRectMake(0, sizeNumberView-45, SCRW/5, 45)];
    leftbtnView.backgroundColor = LMH_COLOR_LEFTBUT;
    [numberView addSubview:leftbtnView];
    
    centerbtnView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftbtnView.frame), sizeNumberView-45, SCRW/5*3, 45)];
    centerbtnView.backgroundColor = LMH_COLOR_CENTERBUT;
    [numberView addSubview:centerbtnView];
    
    rightbtnView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(centerbtnView.frame), sizeNumberView-45, SCRW/5, 45)];
    rightbtnView.backgroundColor = LMH_COLOR_LEFTBUT;
    [numberView addSubview:rightbtnView];
    
    
    leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCRW/5/2-15, 10, 30, 30)];
    [leftBtn setBackgroundImage:LOAD_LOCALIMG(@"down") forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(showClick) forControlEvents:UIControlEventTouchUpInside];
    [leftbtnView addSubview:leftBtn];
    
    
    smsBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftBtn.frame), 10, 30, 30)];
    smsBtn.tag = 102;
    [smsBtn setImage:LOAD_LOCALIMG(@"sms") forState:UIControlStateNormal];
    //    [smsBtn setBackgroundImage:LOAD_LOCALIMG(@"btn_def") forState:UIControlStateNormal];
    //    [smsBtn setBackgroundImage:LOAD_LOCALIMG(@"btn_select") forState:UIControlStateSelected];
    //    [smsBtn setBackgroundImage:LOAD_LOCALIMG(@"btn_select") forState:UIControlStateHighlighted];
    [smsBtn addTarget:self action:@selector(smsClick:) forControlEvents:UIControlEventTouchUpInside];
    [centerbtnView addSubview:smsBtn];

    
    callBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(smsBtn.frame)+40, 10, 30, 30)];
    callBtn.tag = 101;
    [callBtn setImage:LOAD_LOCALIMG(@"call") forState:UIControlStateNormal];
//    [callBtn setBackgroundImage:LOAD_LOCALIMG(@"btn_def") forState:UIControlStateNormal];
//    [callBtn setBackgroundImage:LOAD_LOCALIMG(@"btn_select") forState:UIControlStateSelected];
//    [callBtn setBackgroundImage:LOAD_LOCALIMG(@"btn_select") forState:UIControlStateHighlighted];
    [callBtn addTarget:self action:@selector(callClick:) forControlEvents:UIControlEventTouchUpInside];
    [centerbtnView addSubview:callBtn];
    
    
    //删除号码的
    rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCRW/5/2-15, 10, 30, 30)];
    [rightBtn setBackgroundImage:LOAD_LOCALIMG(@"delete") forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clearNum) forControlEvents:UIControlEventTouchUpInside];
    [rightbtnView addSubview:rightBtn];
}

- (void)showNumber{
    phoneView.hidden = YES;
    [self showClick];
}

- (void)showClick{
    phoneView.hidden = !phoneView.hidden;
    CGRect numFrame = numberView.frame;
    CGRect tFrame = self.tableview.frame;
    CGRect lFrame = leftbtnView.frame;
    CGRect cFrame = centerbtnView.frame;
    CGRect rFrame = rightbtnView.frame;
    
    if (phoneView.hidden) {
        tFrame.size.height += CGRectGetHeight(numFrame)-(40+(SCRW-60)/8);
        lFrame.origin.y -= numFrame.size.height-(40+(SCRW-60)/8+10);
        cFrame.origin.y -= numFrame.size.height-(40+(SCRW-60)/8+10);
        rFrame.origin.y -= numFrame.size.height-(40+(SCRW-60)/8+10);
        numFrame = CGRectMake(0, CGRectGetMaxY(tFrame)-10, SCRW, (40+(SCRW-60)/8+10));
        [leftBtn setBackgroundImage:LOAD_LOCALIMG(@"up") forState:UIControlStateNormal];
    }else{
        tFrame = CGRectMake(0, 0, SCRW, (SCRH-NAVHEIGHT-TABHEIGHT)-sizeNumberView);
        numFrame = CGRectMake(0, CGRectGetMaxY(tFrame), SCRW, sizeNumberView);
        lFrame = CGRectMake(0, sizeNumberView-45, SCRW/5, 45);
        cFrame = CGRectMake(CGRectGetMaxX(lFrame), sizeNumberView-45, SCRW/5*3, 45);
        rFrame = CGRectMake(CGRectGetMaxX(cFrame), sizeNumberView-45, SCRW/5, 45);
        [leftBtn setBackgroundImage:LOAD_LOCALIMG(@"down") forState:UIControlStateNormal];
    }
    
    
//    if (phoneView.hidden) {
//        tFrame.size.height += CGRectGetHeight(numFrame)-(40+(SCRW-60)/8);
//        lFrame.origin.y -= numFrame.size.height-(82+(SCRW-60)/8);
//        cFrame.origin.y -= numFrame.size.height-(82+(SCRW-60)/8);
//        rFrame.origin.y -= numFrame.size.height-(82+(SCRW-60)/8);
//        numFrame = CGRectMake(0, CGRectGetMaxY(tFrame)-10, SCRW, (40+(SCRW-60)/8+10));
//        [leftBtn setBackgroundImage:LOAD_LOCALIMG(@"up") forState:UIControlStateNormal];
//    }else{
//        tFrame = CGRectMake(0, 0, SCRW, (SCRH-NAVHEIGHT-TABHEIGHT)-(SCRW-200)/3*5-(SCRW-60)/8);
//        numFrame = CGRectMake(0, CGRectGetMaxY(tFrame)+32, SCRW, (SCRW-60)/8+(SCRW-200)/3*5);
//        lFrame = CGRectMake(0, CGRectGetHeight(numFrame)-(SCRW-60)/8-37, SCRW/5, 45);
//        cFrame = CGRectMake(CGRectGetMaxX(lFrame), CGRectGetMinY(lFrame), SCRW/5*3, 45);
//        rFrame = CGRectMake(CGRectGetMaxX(cFrame), CGRectGetMinY(lFrame), SCRW/5, 45);
//        [leftBtn setBackgroundImage:LOAD_LOCALIMG(@"down") forState:UIControlStateNormal];
//    }

    
    self.tableview.frame = tFrame;
    numberView.frame = numFrame;
    leftbtnView.frame = lFrame;
    centerbtnView.frame = cFrame;
    rightbtnView.frame = rFrame;
}


- (void)numberClick:(UIButton *)sender{
    if (sender.tag - 1000 < 9) {
         [numStr appendFormat:@"%zi",sender.tag - 999];
    }else if(sender.tag - 1000 == 9){
        [numStr appendString:@"*"];
    }else if (sender.tag - 1000 == 10){
        [numStr appendString:@"0"];
    }else{
        [numStr appendString:@"#"];
    }
    
    phoneNumlbl.text = numStr;
    tmpCont.fullName = @"未知";
    tmpCont.phoneNumber = numStr;
}

- (void)clearNum{
    if (numStr.length > 0) {
        [numStr setString:[numStr substringToIndex:numStr.length-1]];
        phoneNumlbl.text = numStr;
        tmpCont.phoneNumber = numStr;
        tmpCont.fullName = nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return recordArray.count;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 50;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"RECORD";
    
    NSInteger row = indexPath.row;
    
    THContact *contact = recordArray[row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor whiteColor];
        
//        cell.imageView.image = LOAD_LOCALIMG(@"sms_h");
//        cell.imageView.alpha = 0.0f;
    }
    
    cell.textLabel.text = contact.fullName?contact.fullName:@"未知";
    cell.textLabel.font = LMH_FONT_16;
    NSMutableString *phonNumber = [[NSMutableString alloc] initWithString:contact.phoneNumber];
    
    if (phonNumber.length == 11) {
        [phonNumber insertString:@"-" atIndex:3];
        [phonNumber insertString:@"-" atIndex:8];
    }
    
    
    cell.detailTextLabel.text = phonNumber;
    cell.detailTextLabel.font = LMH_FONT_15;
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    UIButton *imgBtn = (UIButton *)[cell.contentView viewWithTag:102];
    if (!imgBtn) {
        imgBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCRW-80, 20, 20, 20)];
        [imgBtn setBackgroundImage:LOAD_LOCALIMG(@"sms_p") forState:UIControlStateNormal];
        [imgBtn setBackgroundImage:LOAD_LOCALIMG(@"sms_h") forState:UIControlStateHighlighted];
        imgBtn.tag = 102;
        [imgBtn addTarget:self action:@selector(smsClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:imgBtn];
    }
    objc_setAssociatedObject(imgBtn, "param", contact, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    UILabel *timeLbl = (UILabel *)[cell viewWithTag:1000];
    if (!timeLbl) {
        timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCRW/3*2-10, 0, SCRW/3, 24)];
        timeLbl.textColor = [UIColor lightGrayColor];
        timeLbl.textAlignment = NSTextAlignmentRight;
        timeLbl.font = LMH_FONT_14;
        timeLbl.tag = 1000;
        [cell.contentView addSubview:timeLbl];
    }
    timeLbl.text = [NSDate stringTimesAgo:contact.recordTime];
    
    UIButton *accessBtn = (UIButton *)[cell.contentView viewWithTag:101];
    if (!accessBtn) {
        accessBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCRW-40, 20, 20, 20)];
        [accessBtn setBackgroundImage:LOAD_LOCALIMG(@"call_p") forState:UIControlStateNormal];
        [accessBtn setBackgroundImage:LOAD_LOCALIMG(@"call_h") forState:UIControlStateHighlighted];
        accessBtn.tag = 101;
        [accessBtn addTarget:self action:@selector(callClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:accessBtn];
    }
    objc_setAssociatedObject(accessBtn, "param", contact, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    THContact *contcat = recordArray[indexPath.row];
    if (!contcat.phoneNumber) {
        return;
    }
    tmpCont = contcat;
    [numStr setString:[NSString stringWithFormat:@"%@", contcat.phoneNumber]];
    phoneNumlbl.text = numStr;
}

- (void)btnClick:(UIButton *)sender{
    if (sender.tag == 1001) {
        Voice_LoginViewController *loginVC = [[Voice_LoginViewController  alloc] initWithNibName:nil bundle:nil];
        loginVC.delegate = self;
        NavigationContrller *navc = [[NavigationContrller alloc] initWithRootViewController:loginVC];
        loginVC.navigationController = navc;
        [self presentViewController:navc animated:NO completion:^{
            imgView.hidden = YES;
        }];
    }else{
        Voice_RegistViewController *registVC = [[Voice_RegistViewController  alloc] initWithNibName:nil bundle:nil];
        registVC.delegate = self;
        NavigationContrller *navc = [[NavigationContrller alloc] initWithRootViewController:registVC];
        registVC.navigationController = navc;
        registVC.type = 1;
        [self presentViewController:navc animated:NO completion:^{
            imgView.hidden = YES;
        }];
    }
}

- (void)didLogin{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"login"] boolValue]) {
        imgView.hidden = YES;
    }else{
        imgView.hidden = NO;
    }
}

- (void)didRegist{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"login"] boolValue]) {
        imgView.hidden = YES;
    }else{
        imgView.hidden = NO;
    }
}

-(void)didImageView{
//    imgView.hidden = YES;
    [self createAddUI];
//    [imgView removeFromSuperview];
}

-(NSString *)findNumFromStr:(NSString *)phoneStr{
    NSString *originalString = phoneStr;
    
    // Intermediate
    NSMutableString *numberString = [[NSMutableString alloc] init];
    NSString *tempStr;
    NSScanner *scanner = [NSScanner scannerWithString:originalString];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    while (![scanner isAtEnd]) {
        // Throw away characters before the first number.
        [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
        
        // Collect numbers.
        [scanner scanCharactersFromSet:numbers intoString:&tempStr];
        [numberString appendString:tempStr];
        tempStr = @"";
    }
    
    return numberString;
}

- (void)selectIndex:(NSInteger)index{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    useCont.recordTime  = [dateFormatter stringFromDate:currentDate];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *record = [defaults objectForKey:@"record"];
    NSMutableArray *cordArray = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:record];
    
    if (cordArray.count == 0) {
        cordArray = [[NSMutableArray alloc] init];
        [cordArray addObject:useCont];
    }else if(cordArray.count > 2000){
        [cordArray replaceObjectAtIndex:0 withObject:useCont];
    }else{
        [cordArray insertObject:useCont atIndex:0];
    }
    record = [NSKeyedArchiver archivedDataWithRootObject:cordArray];
    [defaults setObject:record forKey:@"record"];
    [defaults synchronize];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *tent = [def objectForKey:@"tent"];
    if (useCont.phoneNumber.length > 0) {
        [self sendSMS:tent recipientList:@[useCont.phoneNumber]];
    }
    
    [self flashRecord];
}

//发短信
- (void)smsClick:(UIButton *)sender{
    THContact *contcat = objc_getAssociatedObject(sender, "param");
    contcat.type = @"sms";
    
    if (!contcat) {
        tmpCont.type = @"sms";
        contcat = tmpCont;
    }
    useCont = contcat;
    
    if (useCont.phoneNumber.length > 0) {
        smsView.hidden = NO;
        [smsView.smsTableView reloadData];
    }
    
    return;
}

#pragma mark - 发送短信并传送文字
- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText]){
        controller.body = bodyOfMessage;
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

#pragma mark 处理发送完的响应结果
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (result == MessageComposeResultCancelled)
        [self textStateHUD:@"发送取消"];
    else if (result == MessageComposeResultSent)
        [self textStateHUD:@"发送成功"];
    else
        [self textStateHUD:@"发送失败"];
}

//打电话
- (void)callClick:(UIButton *)sender{
    if (phoneView.hidden) {
        [self showClick];
    }
    THContact *contcat = objc_getAssociatedObject(sender, "param");
   
    contcat.image = nil;
    contcat.type = @"call";
    if (!contcat) {
        tmpCont.type = @"call";
        contcat = tmpCont;
    }
    if (contcat.phoneNumber.length == 0) {
        return;
    }
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    contcat.recordTime  = [dateFormatter stringFromDate:currentDate];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *record = [defaults objectForKey:@"record"];
    NSMutableArray *cordArray = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:record];
    
    if (cordArray.count == 0) {
        cordArray = [[NSMutableArray alloc] init];
        [cordArray addObject:contcat];
    }else if(cordArray.count > 2000){
        [cordArray replaceObjectAtIndex:0 withObject:contcat];
    }else{
        [cordArray insertObject:contcat atIndex:0];
    }
    record = [NSKeyedArchiver archivedDataWithRootObject:cordArray];
    [defaults setObject:record forKey:@"record"];
    [defaults synchronize];
    
    NSString *phoneStr = [NSString stringWithFormat:@"tel://%@", contcat.phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
    
    [self flashRecord];
    phoneNumlbl.text = @"";
    tmpCont.phoneNumber = @"";
    tmpCont.fullName = @"";
    [numStr setString:@""];
}

@end
