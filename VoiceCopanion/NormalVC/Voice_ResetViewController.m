//
//  Voice_ResetViewController.m
//  VoiceCopanion
//
//  Created by 米翊米 on 15/5/28.
//  Copyright (c) 2015年 米翊米. All rights reserved.
//

#import "Voice_ResetViewController.h"
#import "Voice_SettingViewController.h"
#import "Voice_SmsView.h"

@interface Voice_ResetViewController ()<UITextFieldDelegate,UITextViewDelegate, Voice_SmsViewDelegate>
{
    UIScrollView *scrollView;
    UITextView *contview;
    UITextField *titleFiled;
    UIButton *tempBtn;
    UIView *bgView;
    UILabel *placeLabel;
    Voice_SmsView *smsView;
    
    CGRect vFrame;
    NSUserDefaults *userDef;
    NSMutableArray *tempArray;
    NSMutableArray *smsArray;
    NSInteger smsIndex;
}

@end

@implementation Voice_ResetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        self.title = @"短信内容";
        userDef = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [self createUI];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightBtn setTitle:@"设置" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(setClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    UINavigationItem * navItem = self.navigationController.topViewController.navigationItem;
    [navItem setRightBarButtonItem:rightItem animated:YES];
    
    smsView = [[Voice_SmsView alloc] initWithFrame:self.view.frame];
    smsView.smsDelegate = self;
    smsView.viewType = 1;
    [self.view addSubview:smsView];
    smsView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initData];
}

- (void)initData{
    tempArray = [[NSMutableArray alloc] init];
    smsArray = [[NSMutableArray alloc] init];
    smsIndex = 0;
    
    [tempArray addObject:@"选择短信模板"];
    for (int i = 1; i < 6; i++) {
        NSString *tent = [userDef objectForKey:[NSString stringWithFormat:@"tent_%zi", i]];
        NSString *title = [userDef objectForKey:[NSString stringWithFormat:@"title_%zi", i]];
        
        if (title.length > 0) {
            [tempArray addObject:title];
            [smsArray addObject:tent];
        }
    }
    if (tempArray.count < 6) {
        [tempArray addObject:@"添加短信模板"];
    }
    
    [tempBtn setTitle:tempArray[smsIndex] forState:UIControlStateNormal];
    if (smsIndex > 0) {
        contview.text = smsArray[smsIndex-1];
        placeLabel.hidden = YES;
        
        titleFiled.text = tempArray[smsIndex];
    }

    if (smsIndex == 0) {
        titleFiled.text = @"";
        contview.text = @"";
        titleFiled.userInteractionEnabled = NO;
        contview.userInteractionEnabled = NO;
    }
}

- (void)createUI{
    vFrame = self.view.frame;
    
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    
    tempBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, SCRW-40, 30)];
    [tempBtn setTitle:tempArray[0] forState:UIControlStateNormal];
    [tempBtn.titleLabel setFont:LMH_FONT_15];
    [tempBtn setTitleColor:LMH_COLOR_GRAYTEXT forState:UIControlStateNormal];
    [tempBtn setImage:LOAD_LOCALIMG(@"tempdown") forState:UIControlStateNormal];
    [tempBtn setBackgroundImage:LOAD_LOCALIMG(@"btnBack") forState:UIControlStateHighlighted];
    [tempBtn addTarget:self action:@selector(tempClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:tempBtn];
    [tempBtn setReversesTitleShadowWhenHighlighted:YES];
    tempBtn.layer.cornerRadius = 5.0;
    tempBtn.layer.borderColor = LMH_COLOR_LGTGRAYTEXT.CGColor;
    tempBtn.layer.borderWidth = 0.5;
    
    titleFiled = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(tempBtn.frame), CGRectGetMaxY(tempBtn.frame)+20, CGRectGetWidth(tempBtn.frame), 30)];
    titleFiled.placeholder = @"请输入模板标题(限10字符以内)";
    titleFiled.textColor = LMH_COLOR_GRAYTEXT;
    titleFiled.font = LMH_FONT_15;
    titleFiled.layer.borderColor = LMH_COLOR_GRAYTEXT.CGColor;
    titleFiled.layer.borderWidth = 0.5;
    [scrollView addSubview:titleFiled];
    
    contview = [[UITextView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(titleFiled.frame)+10, SCRW-40, (SCRW-40)/2)];
    contview.backgroundColor = [UIColor whiteColor];
    contview.layer.borderColor = LMH_COLOR_GRAYTEXT.CGColor;
    contview.layer.borderWidth = 0.5;
    contview.font = LMH_FONT_15;
    contview.delegate = self;
    contview.textColor = LMH_COLOR_GRAYTEXT;
    contview.delegate = self;
    
    placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 150, 20)];
    placeLabel.text = @"请输入短信内容...";
    placeLabel.textColor = LMH_COLOR_LGTGRAYTEXT;
    placeLabel.font = LMH_FONT_15;
    [contview addSubview:placeLabel];
    
    [scrollView addSubview:contview];
    
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(contview.frame)+10, SCRW-40, 40)];
    sureBtn.layer.cornerRadius = 3.0;
    [sureBtn.titleLabel setFont:LMH_FONT_15];
    [sureBtn setBackgroundColor:LMH_COLOR_BTNBACK];
    [sureBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn setBackgroundImage:LOAD_LOCALIMG(@"btnBack") forState:UIControlStateHighlighted];
    [sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:sureBtn];
    
    scrollView.contentSize = CGSizeMake(SCRW, CGRectGetMaxY(sureBtn.frame)+10);
}

- (void)sureClick{
    if (smsIndex == 0) {
        [self textStateHUD:@"请选择短信模板"];
        return;
    }
    
    NSString *contentText = [contview.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    contentText = [contentText stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *titleText = [titleFiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    titleText = [titleText stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (titleText.length == 0) {
        [self textStateHUD:@"请设置标题"];
        return;
    }
    
    if (contentText.length <= 0) {
        if (smsIndex > smsArray.count) {
            [self textStateHUD:@"请添加短信内容"];
            return;
        }else if(smsIndex > 0){
            [self textStateHUD:@"短信内容不能为空"];
            return;
        }
    }else{
        [userDef setObject:contview.text forKey:[NSString stringWithFormat:@"tent_%zi", smsIndex]];
        [userDef setObject:titleFiled.text forKey:[NSString stringWithFormat:@"title_%zi", smsIndex]];
    }
    
    if (smsIndex > smsArray.count) {
        [self textStateHUD:@"模板添加成功"];
    }else{
        [self textStateHUD:@"模板修改成功"];
    }
    
    [self initData];
}

- (void)tempClick{
    [self.view endEditing:YES];
    smsView.hidden = NO;
    [smsView.smsTableView reloadData];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (SCRH <= 568) {
        [scrollView setContentOffset:CGPointMake(0, 80) animated:YES];
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 0) {
        placeLabel.hidden = YES;
    }else{
        placeLabel.hidden = NO;
    }
}

- (void)selectIndex:(NSInteger)index{
    [tempArray addObject:@"选择短信模板"];
    [tempArray removeAllObjects];
    [smsArray removeAllObjects];
    
    [tempArray addObject:@"选择短信模板"];
    for (int i = 1; i < 6; i++) {
        NSString *tent = [userDef objectForKey:[NSString stringWithFormat:@"tent_%zi", i]];
        NSString *title = [userDef objectForKey:[NSString stringWithFormat:@"title_%zi", i]];
        
        if (title.length > 0) {
            [tempArray addObject:title];
            [smsArray addObject:tent];
        }
    }
    if (tempArray.count < 6) {
        [tempArray addObject:@"添加短信模板"];
    }
    
    smsIndex = index+1;
    [tempBtn setTitle:tempArray[smsIndex] forState:UIControlStateNormal];
    
    if (smsIndex == 0) {
        titleFiled.userInteractionEnabled = NO;
        contview.userInteractionEnabled = NO;
    }else{
        titleFiled.userInteractionEnabled = YES;
        contview.userInteractionEnabled = YES;
    }
    
    if ([tempArray[smsIndex] isEqualToString:@"添加短信模板"]) {
        contview.text = @"";
    }else if (smsIndex > 0) {
        contview.text = smsArray[smsIndex-1];
        placeLabel.hidden = YES;
    }else{
        contview.text = @"";
    }
    
    NSString *title = [userDef objectForKey:[NSString stringWithFormat:@"title_%zi", smsIndex]];
    
    switch (smsIndex) {
        case 1:
            titleFiled.text = title;
            break;
        case 2:
            titleFiled.text = title;
            break;
        case 3:
            titleFiled.text = title;
            break;
        case 4:
            titleFiled.text = title;
            break;
        case 5:
            titleFiled.text = title;
            break;
        default:
            titleFiled.text = @"";
            placeLabel.hidden = NO;
            break;
    }
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat hOffset = endKeyboardRect.size.height;
    CGFloat yOffset = endKeyboardRect.origin.y;
    
    CGRect frame = vFrame;
    if (yOffset == SCRH) {
        scrollView.frame = vFrame;
    }else{
        frame.size.height -= hOffset-TABHEIGHT;
        scrollView.frame = frame;
    }
}

- (void)hideKeyboard{
    [self.view endEditing:YES];
}

- (void)setClick{
    Voice_SettingViewController *setVC = [[Voice_SettingViewController alloc] initWithStyle:UITableViewStylePlain];
    setVC.navigationController = self.navigationController;
    setVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setVC animated:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}
@end
