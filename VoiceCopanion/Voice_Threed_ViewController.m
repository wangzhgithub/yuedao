//
//  Voice_Threed_ViewController.m
//  VoiceCopanion
//
//  Created by wangzh on 16/3/8.
//  Copyright © 2016年 米翊米. All rights reserved.
//

#import "Voice_Threed_ViewController.h"
#import "UIViewController+APSafeTransition.h"
#import "Voice_SettingViewController.h"
#import "Voice_Protocol.h"
#import "Voice_ThreedViewCell.h"
#import "PopoverViewController.h"

@interface Voice_Threed_ViewController ()<UIPopoverPresentationControllerDelegate,UITextFieldDelegate,UITextViewDelegate,MBProgressHUDDelegate,NavigationContrllerDelegate>{
    
    MBProgressHUD *stateHud;
    
    NSMutableArray *mySectionArr;
    // 每个section中的row个数
    NSMutableArray   *rowOfSectionArr;
    // 每个section展开收起状态标识符
    NSMutableArray *openedInSectionArr;
    UITableView *myTableView;
    UIView *addTableView;
    NSInteger smsIndex;
    NSInteger count;
    
    UIImageView *headerImage;
    UILabel  *userNameLab;
    
    UIButton *addBtn;
    
    UITextField *titFiled;
    UITextView *contentView;
    UILabel *placeholderLab;
}



@property (weak, nonatomic) UISegmentedControl *animationSegment;
@property (strong, nonatomic) PopoverViewController *buttonPopVC;

@end

@implementation Voice_Threed_ViewController

@synthesize navigationController;
@synthesize navHiden,tabHiden;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        navHiden = NO;
        tabHiden = YES;
        self.title = @"设置";
        userDef = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 20, 20)];
    [rightBtn setBackgroundImage:LOAD_LOCALIMG(@"set") forState:UIControlStateNormal];
    //    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(setClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    UINavigationItem * navItem = self.navigationController.topViewController.navigationItem;
    [navItem setRightBarButtonItem:rightItem animated:YES];
    
    if (!self.isFirstVC) {
        [self.navigationController addLeftBarItem];
    }
    [self loadView];
       
    [self setExtraCellLineHidden:myTableView];
}


- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
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
    return UIStatusBarStyleDefault;
}


#pragma mark - View lifecycle
// Implement loadView to create a view hierarchy programmatically,without using a nib.
- (void)loadView
{
    
    UIView * myView = [[UIView alloc] initWithFrame:CGRectMake(0,0,SCRW,SCRH-109)];
    myView.backgroundColor = [UIColor whiteColor];
    self.view = myView;
    if (IOS_7){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    // memberInfoVC = [[MemberInfo alloc] init];
    // sectionheader文字
    count = 1;
    [self initData];
    [self createAddUI];
    // 每个section展开收起状态标识符
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,100,SCRW,SCRH/2) style:UITableViewStylePlain];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    [self.view addSubview:myTableView];
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(DownView:)];
//    [self.view addGestureRecognizer:tapGesture];
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    //根据键值取出name
    NSString *userName = [defaults objectForKey:@"username"];
    
    headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 30, HEADERGHT, HEADERGHT)];
    headerImage.image = LOAD_LOCALIMG(@"header");
    headerImage.layer.cornerRadius = HEADERGHT/2;
    headerImage.layer.masksToBounds = YES;
    [self.view addSubview:headerImage];
    
    userNameLab  = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headerImage.frame), 60, 150, 30)];
    userNameLab.textColor = [UIColor blackColor];
    userNameLab.text = userName;
    [self.view addSubview:userNameLab];
    
    addBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, SCRH-189, SCRW-40, 35)];
    addBtn.layer.cornerRadius = 3.0;
    [addBtn setTitle:@"添加模板" forState:UIControlStateNormal];
//    [addBtn.titleLabel setFont:LMH_FONT_15];
    [addBtn setBackgroundColor:LMH_COLOR_BTNBACK];
//    [addBtn setBackgroundImage:LOAD_LOCALIMG(@"btnBack") forState:UIControlStateHighlighted];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    [addBtn.titleLabel setFont:LMH_FONT_15];
//    [addBtn setBackgroundImage:LOAD_LOCALIMG(@"background") forState:UIControlStateNormal];
    [self.view addSubview:addBtn];
    
}

-(void)DownView:(id)sender
{
    [titFiled resignFirstResponder];
    [contentView resignFirstResponder];
}


- (void)createAddUI{
    
    
    addTableView = [[UIView alloc] initWithFrame:CGRectMake(0,80,SCRW,SCRH/2)];
    [self.view addSubview:addTableView];
    
    [titFiled removeFromSuperview];
    titFiled = [[UITextField alloc] initWithFrame:CGRectMake(20, 5, SCRW-40, 30)];
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

    UIButton *addOKBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, (SCRW-40)/2+70, SCRW-40, 35)];
    addOKBtn.layer.cornerRadius = 3.0;
    [addOKBtn.titleLabel setFont:LMH_FONT_15];
    [addOKBtn setBackgroundColor:LMH_COLOR_BTNBACK];
    [addOKBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [addOKBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [addOKBtn setBackgroundImage:LOAD_LOCALIMG(@"background") forState:UIControlStateNormal];
    [addOKBtn addTarget:self action:@selector(addOKClick) forControlEvents:UIControlEventTouchUpInside];
    [addTableView addSubview:addOKBtn];

    
    addTableView.hidden = YES;
    
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        placeholderLab.hidden = YES;
    }else{
        placeholderLab.hidden = NO;
    }
    
    if (textView.text.length > 70) {
        textView.text = [textView.text substringToIndex:70];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [titFiled resignFirstResponder];
    [contentView resignFirstResponder];
}

-(void)addClick{
    
    self.title = @"添加模板";
    headerImage.hidden = YES;
    userNameLab.hidden = YES;
    addBtn.hidden = YES;
    myTableView.hidden = YES;
    addTableView.hidden = NO;
    
}

-(void)addOKClick{
    
    smsIndex = smsArray.count+1;
    if (titFiled.text.length == 0) {
//        [self textStateHUD:@"请设置标题"];
        [self showPopView:titFiled poptext:@"请设置标题" directions:1];
        return;
    }
    
    if (contentView.text.length <= 0) {
        if (smsIndex > smsArray.count) {
//            [self textStateHUD:@"请添加短信内容"];
            [self showPopView:contentView poptext:@"请添加短信内容" directions:2];
            return;
        }else if(smsIndex > 0){
            [self showPopView:contentView poptext:@"短信内容不能为空" directions:2];
//            [self textStateHUD:@"短信内容不能为空"];
            return;
        }
    }else{
        
        [userDef setObject:titFiled.text forKey:[NSString stringWithFormat:@"title_%zi", smsIndex]];
        [userDef setObject:contentView.text forKey:[NSString stringWithFormat:@"tent_%zi", smsIndex]];
        
    }
    
    if (smsIndex > smsArray.count) {
        [self textStateHUD:@"模板添加成功"];
    }else{
        [self textStateHUD:@"模板修改成功"];
    }
    
    [self initData];
    
    headerImage.hidden = NO;
    userNameLab.hidden = NO;
    addBtn.hidden = NO;
    myTableView.hidden = NO;
    addTableView.hidden = YES;
    [myTableView reloadData];

}

- (void)showPopView:(UIView*)view poptext:(NSString*)poptext directions:(NSInteger)direction{
    self.buttonPopVC = [[PopoverViewController alloc] init];
    self.buttonPopVC.modalPresentationStyle = UIModalPresentationPopover;
    self.buttonPopVC.popText = poptext;
    self.buttonPopVC.popBackgroundColor = [UIColor grayColor];
    self.buttonPopVC.popTextColor = [UIColor whiteColor];
    self.buttonPopVC.popoverPresentationController.sourceView = view;
    self.buttonPopVC.popoverPresentationController.sourceRect = view.bounds;
    if (direction == 1) {
        self.buttonPopVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp; //箭头方向
    }else{
        self.buttonPopVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown; //箭头方向
    }
    
    self.buttonPopVC.popoverPresentationController.backgroundColor = [UIColor grayColor];
    self.buttonPopVC.popoverPresentationController.delegate = self;
    [self presentViewController:self.buttonPopVC animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
        [self.buttonPopVC dismissViewControllerAnimated:YES completion:nil];    //我暂时使用这个方法让popover消失，但我觉得应该有更好的方法，因为这个方法并不会调用popover消失的时候会执行的回调。
        self.buttonPopVC = nil;
    });
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    return NO;   //点击蒙版popover不消失， 默认yes
}

- (void)setClick{
    Voice_SettingViewController *setVC = [[Voice_SettingViewController alloc] initWithStyle:UITableViewStylePlain];
    setVC.navigationController = self.navigationController;
    setVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setVC animated:YES];
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


- (NSIndexPath *)showHideIndexPath1
{
    return [NSIndexPath indexPathForRow:0 inSection:0];
}

- (NSIndexPath *)showHideIndexPath2
{
    return [NSIndexPath indexPathForRow:1 inSection:0];
}

- (NSIndexPath *)rowHeightIndexPath
{
    return [NSIndexPath indexPathForRow:2 inSection:0];
}

- (BOOL)isReloadWithAnimation
{
    return self.animationSegment.selectedSegmentIndex == 0;
}

- (void)testShowHide:(UIButton *)sender
{
    sender.selected = ![sender isSelected];
    
    if ([sender isSelected])
    {
        if ([self isReloadWithAnimation])
        {
            [self insertRowsAtIndexPaths:@[self.showHideIndexPath1, self.showHideIndexPath2] withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            [self insertRowsAtIndexPaths:@[self.showHideIndexPath1, self.showHideIndexPath2]];
            [self.tableView reloadData];
        }
    }
    else
    {
        if ([self isReloadWithAnimation])
        {
            [self deleteRowsAtIndexPaths:@[self.showHideIndexPath1, self.showHideIndexPath2] withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            [self deleteRowsAtIndexPaths:@[self.showHideIndexPath1, self.showHideIndexPath2]];
            [self.tableView reloadData];
        }
    }
}

- (void)testRowHeight:(UIButton *)sender
{
    sender.selected = ![sender isSelected];
    
    if ([sender isSelected])
    {
        [self setRowHeight:200 forIndexPath:self.rowHeightIndexPath];
    }
    else
    {
        [self setRowHeight:56 forIndexPath:self.rowHeightIndexPath];
    }
    
    if ([self isReloadWithAnimation])
    {
        [self.tableView beginUpdates];
        [self.tableView reloadData];
        [self.tableView endUpdates];
    }
    else
    {
        [self.tableView reloadData];
    }
}

- (NSInteger)initData{
    tempArray = [[NSMutableArray alloc] init];
    smsArray = [[NSMutableArray alloc] init];
    openedInSectionArr = [[NSMutableArray alloc]init];
    
    
    for (int i = 1; i < 50; i++) {
        
        NSString *title = [userDef objectForKey:[NSString stringWithFormat:@"title_%zi", i]];
        NSString *tent = [userDef objectForKey:[NSString stringWithFormat:@"tent_%zi", i]];
        
        if (title.length > 0 && tent.length > 0) {
            [openedInSectionArr addObject:@"0"];
            [tempArray addObject:title];
            [smsArray addObject:tent];
        }else{
            break;
        }
    }
    return tempArray.count;
}


- (void)sureClick{
    
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:smsIndex];
    Voice_ThreedViewCell *titleData = (Voice_ThreedViewCell*)[myTableView cellForRowAtIndexPath:indexpath];
    
    NSString *titleText = titleData.titleFiled.text;
    NSString *contentText = titleData.contview.text;
    

    if (titleText.length > 0) {
        [userDef setObject:titleText forKey:[NSString stringWithFormat:@"title_%zi", smsIndex+1]];
    }else{
        [self textStateHUD:@"请设置标题"];
//        [self showPopView:titleData.titleFiled poptext:@"请设置标题"];
        return;
    }
    
    if (contentText.length > 0) {
        [userDef setObject:contentText forKey:[NSString stringWithFormat:@"tent_%zi", smsIndex+1]];
    }else{
//        [self showPopView:titleData.contview poptext:@"请设置标题"];
        [self textStateHUD:@"请设置内容"];
        return;
    }
    
    if (smsIndex > smsArray.count) {
        [self textStateHUD:@"模板添加成功"];
    }else{
        [self textStateHUD:@"模板修改成功"];
    }
    [self initData];
    [myTableView reloadData];
}




//点击header的方法
-(void)tapHeader:(UIButton *)sender
{
    if ([[openedInSectionArr objectAtIndex:sender.tag - 100] intValue] == 0) {
        [openedInSectionArr replaceObjectAtIndex:sender.tag - 100 withObject:@"1"];
//        NSLog(@"%ld打开",(long)sender.tag);
        smsIndex = sender.tag - 100;
        self.title = @"短信模板";
        [self.view endEditing:YES];
    }
    else
    {
        [openedInSectionArr replaceObjectAtIndex:sender.tag - 100 withObject:@"0"];
//        NSLog(@"%ld关闭",(long)sender.tag);
        self.title = @"设置";
    }
    [myTableView reloadData];
}

//点击删除按钮
-(void)delBut:(UIButton *)sender{
    NSInteger index = sender.tag - 300;
    if (tempArray.count > 1) {
        [smsArray removeObjectAtIndex:index];
        [tempArray removeObjectAtIndex:index];
        
        for (int i = 0; i < smsArray.count; i++) {
            NSString *tentStr = [NSString stringWithFormat:@"tent_%zi", i+1];
            NSString *titleStr = [NSString stringWithFormat:@"title_%zi", i+1];
            [userDef setValue:smsArray[i] forKey:tentStr];
            [userDef setValue:tempArray[i] forKey:titleStr];
        }
        
        NSString *tentStr = [NSString stringWithFormat:@"tent_%zi", smsArray.count+1];
        NSString *titleStr = [NSString stringWithFormat:@"title_%zi", smsArray.count+1];
        [userDef removeObjectForKey:titleStr];
        [userDef removeObjectForKey:tentStr];
        [userDef synchronize];
        
        [myTableView reloadData];
    }else{
        [self textStateHUD:@"已经是最后一条不能删除"];
    }
    
}

#pragma mark - TableView Method
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return tempArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (SCRW-120)/2 +100;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableView * mySectionView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,SCRW,40)];
    mySectionView.backgroundColor = [UIColor whiteColor];
    
    UIButton * delButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImageView *delImageView = [[UIImageView alloc]initWithImage:LOAD_LOCALIMG(@"delete_temp")];
    [delImageView setFrame:CGRectMake(0, 5, CGRectGetWidth(delImageView.frame)-5, CGRectGetHeight(delImageView.frame)-5)];
    delButton.frame = CGRectMake(SCRW-80, 15, 30, 30);
    
    [delButton addSubview:delImageView];
    delButton.tag = 300 + section;
    [delButton addTarget:self action:@selector(delBut:) forControlEvents:UIControlEventTouchUpInside];
    [mySectionView addSubview:delButton];
    
    
    UIButton * editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImageView *editImageView = [[UIImageView alloc]initWithImage:LOAD_LOCALIMG(@"edit_temp")];
    [editImageView setFrame:CGRectMake(0, 5, CGRectGetWidth(editImageView.frame)-5, CGRectGetHeight(editImageView.frame)-5)];
    editButton.frame = CGRectMake(SCRW-40, 15, 30, 30);
    
    [editButton addSubview:editImageView];
    editButton.tag = 100 + section;
    [editButton addTarget:self action:@selector(tapHeader:) forControlEvents:UIControlEventTouchUpInside];
    [mySectionView addSubview:editButton];
    
    
    
    UILabel * myLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10,SCRW-100,30)];
    myLabel.backgroundColor = [UIColor clearColor];
    myLabel.font = LMH_FONT_15;
    myLabel.textColor = [UIColor grayColor];
    myLabel.text = [tempArray objectAtIndex:section];
    
    UILabel *linesLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 39.5, CGRectGetWidth(self.view.frame), 0.5)];
    linesLbl.backgroundColor = [UIColor colorWithRed:0.81 green:0.81 blue:0.81 alpha:1];
    [mySectionView addSubview:linesLbl];
    
    [mySectionView addSubview:myLabel];
    
    return mySectionView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 判断section的展开收起状态
    if ([[openedInSectionArr objectAtIndex:section] intValue] == 1) {
        return 1;
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [self.navigationController pushViewController:memberInfoVC animated:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * string = @"cell";
    Voice_ThreedViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (!cell) {
        cell = [[Voice_ThreedViewCell alloc] initWithReuseIdentifier:string];
    }
    
//    NSInteger section = indexPath.section;
//    NSLog(@"section = %@",tempArray[indexPath.section]);
    
    [cell createUI:tempArray[indexPath.section] countText:smsArray[indexPath.section]];
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, (SCRW-120)/2+60, SCRW-40, 35)];
    sureBtn.layer.cornerRadius = 3.0;
    [sureBtn.titleLabel setFont:LMH_FONT_15];
    [sureBtn setBackgroundColor:LMH_COLOR_BTNBACK];
    [sureBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [sureBtn setBackgroundImage:LOAD_LOCALIMG(@"background") forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:sureBtn];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}



@end
