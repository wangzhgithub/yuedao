//
//  Voice_SecondViewController.m
//  VoiceCopanion
//
//  Created by 米翊米 on 15/5/21.
//  Copyright (c) 2015年 米翊米. All rights reserved.
//

#import "Voice_SecondViewController.h"
#import <AddressBook/AddressBook.h>
#import "THContact.h"
#import "pinyin.h"
#import "ChineseString.h"
#import <AddressBookUI/AddressBookUI.h>
#import <objc/runtime.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "Voice_SmsView.h"
#import "NSDate+Helper.h"

@interface Voice_SecondViewController ()<ABNewPersonViewControllerDelegate,ABPersonViewControllerDelegate,MFMessageComposeViewControllerDelegate,Voice_SmsViewDelegate>
{
    Voice_SmsView *smsView;
    
    NSArray *addressBookArray;
    NSMutableArray *seachArray;
    NSMutableArray *resultArray;
    ABAddressBookRef addressBookRef;
    THContact *useCont;
}

@end

@implementation Voice_SecondViewController

- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"联系人";
        self.edgeInsetsZero = NO;
        
        seachArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //判断是否开启权限
    ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
        if (granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self getContactsFromAddressBook];
            });
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请在系统设置-隐私-通讯录打开权限" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    });
    
    for (int i = 0; i < 27; i++){
        NSString *cstr = @"";
        if (i == 26) {
            cstr = @"#";
        }else{
            cstr = [NSString stringWithFormat:@"%c", 'A'+i];
        }
        
        [seachArray addObject:cstr];
    }
    
    self.tableview.bounces = YES;
    self.tableview.sectionIndexColor = LMH_COLOR_GRAYTEXT;
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 30)];
    [rightBtn setImage:LOAD_LOCALIMG(@"insert") forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:30]];
    [rightBtn addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    UINavigationItem * navItem = self.navigationController.topViewController.navigationItem;
    [navItem setRightBarButtonItem:rightItem animated:YES];
    
    smsView = [[Voice_SmsView alloc] initWithFrame:self.view.frame];
    smsView.smsDelegate = self;
    [self.view addSubview:smsView];
    smsView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshContacts];
    });
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //        [self.navigationBar setBarTintColor:[UIColor blueColor]];
    [self.navigationController.navigationBar setBackgroundImage:LOAD_LOCALIMG(@"background") forBarMetrics:UIBarMetricsDefault];
}

- (void)addAddress{
    ABNewPersonViewController *picker = [[ABNewPersonViewController alloc] init];
    picker.newPersonViewDelegate = self;
    
    NavigationContrller *navigation = [[NavigationContrller alloc] initWithRootViewController:picker];
    [self presentViewController:navigation animated:YES completion:nil];
}

- (void)compositor{
    resultArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 27; i++) {
        [resultArray addObject:[NSArray array]];
    }
    for (THContact *cont in addressBookArray) {
        ChineseString *chineseString=[[ChineseString alloc]init];
        
        chineseString.string = [NSString stringWithString:cont.fullName];
        if(chineseString.string == nil){
            chineseString.string = @"";
        }
        
        if(![chineseString.string isEqualToString:@""]){
            NSString *pinYinResult = [NSString string];
            for(int j = 0; j < chineseString.string.length;j++){
                NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
                
                pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            chineseString.pinYin = pinYinResult;
        }else{
            chineseString.pinYin = @"";
        }
        
        NSString *oneC = @"";
        if (chineseString.pinYin.length > 0) {
            oneC = [chineseString.pinYin substringToIndex:1];
        }
        
        BOOL isP = YES;
        for (int i = 0; i < seachArray.count-1; i++) {
            NSString *cp = seachArray[i];
            if (![cp compare:oneC options:NSCaseInsensitiveSearch | NSNumericSearch]) {
                isP = NO;
                
                NSMutableArray *array = [NSMutableArray arrayWithArray:resultArray[i]];
                [array addObject:cont];
                [resultArray replaceObjectAtIndex:i withObject:array];
                break;
            }
        }
        if (isP) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:resultArray[resultArray.count-1]];
            [array addObject:cont];
            [resultArray replaceObjectAtIndex:seachArray.count-1 withObject:array];
        }
    }
}

- (void) refreshContacts
{
    [self getContactsFromAddressBook];
    
    [self.tableview reloadData];
}

-(void)getContactsFromAddressBook
{
    CFErrorRef error = NULL;
    addressBookArray = [[NSMutableArray alloc]init];
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    if (addressBook) {
        NSArray *allContacts = (__bridge_transfer NSArray*)ABAddressBookCopyArrayOfAllPeople(addressBook);
        NSMutableArray *mutableContacts = [NSMutableArray arrayWithCapacity:allContacts.count];
        
        NSUInteger i = 0;
        for (i = 0; i<[allContacts count]; i++)
        {
            THContact *contact = [[THContact alloc] init];
            ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
            contact.recordId = ABRecordGetRecordID(contactPerson);
            
            // Get first and last names
            NSString *firstName = (__bridge_transfer NSString*)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
            NSString *lastName = (__bridge_transfer NSString*)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
            
            // Set Contact properties
            contact.firstName = firstName;
            contact.lastName = lastName;
            
            if(contact.firstName != nil && contact.lastName != nil) {
                contact.fullName =  [NSString stringWithFormat:@"%@ %@", contact.lastName, contact.firstName];
            } else if (contact.firstName != nil) {
                contact.fullName =  contact.firstName;
            } else if (contact.lastName != nil) {
                contact.fullName =  contact.lastName;
            } else {
                contact.fullName =  @"";
            }
            
            // Get mobile number
            ABMultiValueRef phonesRef = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
            contact.phoneNumber = [self getMobilePhoneProperty:phonesRef];
            
            if(phonesRef) {
                CFRelease(phonesRef);
            }
            
            // Get image if it exists
            NSData  *imgData = (__bridge_transfer NSData *)ABPersonCopyImageData(contactPerson);
            contact.image = [UIImage imageWithData:imgData];
            if (!contact.image) {
                contact.image = [UIImage imageNamed:@"number"];
            }
            
            if (contact.phoneNumber.length > 0) {
                [mutableContacts addObject:contact];
            }
        }
        
        if(addressBook) {
            CFRelease(addressBook);
        }
        
        addressBookArray = [NSArray arrayWithArray:mutableContacts];
        [self compositor];
        
        [self.tableview reloadData];
    }else{
        NSLog(@"Error");
        
    }
}

- (NSString *)getMobilePhoneProperty:(ABMultiValueRef)phonesRef
{
    for (int i=0; i < ABMultiValueGetCount(phonesRef); i++) {
        CFStringRef currentPhoneLabel = ABMultiValueCopyLabelAtIndex(phonesRef, i);
        CFStringRef currentPhoneValue = ABMultiValueCopyValueAtIndex(phonesRef, i);
        
        if(currentPhoneLabel) {
            if (CFStringCompare(currentPhoneLabel, kABPersonPhoneMobileLabel, 0) == kCFCompareEqualTo) {
                return (__bridge NSString *)currentPhoneValue;
            }
            
            if (CFStringCompare(currentPhoneLabel, kABHomeLabel, 0) == kCFCompareEqualTo) {
                return (__bridge NSString *)currentPhoneValue;
            }
        }
        if(currentPhoneLabel) {
            CFRelease(currentPhoneLabel);
        }
        if(currentPhoneValue) {
            CFRelease(currentPhoneValue);
        }
    }
    
    return nil;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return seachArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return seachArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (seachArray.count > section) {
        return seachArray[section];
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (resultArray.count > section) {
        return [resultArray[section] count]?20:0;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (resultArray.count > section) {
        return [resultArray[section] count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Get the desired contact from the filteredContacts array
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    THContact *contact = [resultArray[section] objectAtIndex:row];
    
    // Initialize the table view cell
    NSString *cellIdentifier = @"ContactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    UIImageView *imgIcon = (UIImageView *)[cell viewWithTag:100];
    if (!imgIcon) {
        imgIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
        imgIcon.layer.cornerRadius = 20;
        imgIcon.layer.masksToBounds=YES;
        imgIcon.tag = 100;
        [cell.contentView addSubview:imgIcon];
    }
    if (contact.image) {
        imgIcon.image = contact.image;
    }else{
        imgIcon.image = LOAD_LOCALIMG(@"number");
    }
    
    UILabel *textLabel = (UILabel *)[cell viewWithTag:101];
    if (!textLabel) {
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgIcon.frame)+10,0,SCRW-CGRectGetMaxX(imgIcon.frame)-100,22)];
        textLabel.font = LMH_FONT_15;
        textLabel.textColor = LMH_COLOR_BLACKTEXT;
        textLabel.tag = 101;
        [cell.contentView addSubview:textLabel];
    }
    textLabel.text = contact.fullName;
    
    UILabel *detailLabel = (UILabel *)[cell viewWithTag:102];
    if (!detailLabel) {
        detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgIcon.frame)+10,CGRectGetMaxY(textLabel.frame),SCRW-CGRectGetMaxX(imgIcon.frame)-100,22)];
        detailLabel.font = LMH_FONT_15;
        detailLabel.textColor = [UIColor grayColor];
        detailLabel.tag = 102;
        [cell.contentView addSubview:detailLabel];
    }
    detailLabel.text = contact.phoneNumber;
    
    UIButton *smsBtn = (UIButton *)[cell viewWithTag:103];
    if (!smsBtn) {
        smsBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCRW-90,12,20,20)];
        smsBtn.tag = 103;
        [smsBtn setBackgroundImage:LOAD_LOCALIMG(@"sms_h") forState:UIControlStateNormal];
        [smsBtn addTarget:self action:@selector(smsClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:smsBtn];
    }
    objc_setAssociatedObject(smsBtn, "param", contact, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    UIButton *callBtn = (UIButton *)[cell viewWithTag:104];
    if (!callBtn) {
        callBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCRW-50,10,20,20)];
        callBtn.tag = 104;
        [callBtn setBackgroundImage:LOAD_LOCALIMG(@"call_h") forState:UIControlStateNormal];
        [callBtn addTarget:self action:@selector(callClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:callBtn];
    }
    objc_setAssociatedObject(callBtn, "param", contact, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma mark ABNewPersonViewControllerDelegate methods
// Dismisses the new-person view controller.
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonViewController didCompleteWithNewPerson:(ABRecordRef)person
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return YES;
}

- (void)selectIndex:(NSInteger)index{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yy/MM/dd";
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
}

//发短信
- (void)smsClick:(UIButton *)sender{
    THContact *contcat = objc_getAssociatedObject(sender, "param");
    contcat.type = @"sms";
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
    THContact *contcat = objc_getAssociatedObject(sender, "param");
    if (!contcat.phoneNumber) {
        [self textStateHUD:@"号码为空"];
        return;
    }
    contcat.image = nil;
    contcat.type = @"call";
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    contcat.recordTime  = [dateFormatter stringFromDate:currentDate];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *record = [defaults objectForKey:@"record"];
    NSMutableArray *recordArray = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:record];
    
    if (recordArray.count == 0) {
        recordArray = [[NSMutableArray alloc] init];
        [recordArray addObject:contcat];
    }else if(recordArray.count > 2000){
        [recordArray replaceObjectAtIndex:0 withObject:contcat];
    }else{
        [recordArray insertObject:contcat atIndex:0];
    }
    record = [NSKeyedArchiver archivedDataWithRootObject:recordArray];
    [defaults setObject:record forKey:@"record"];
    [defaults synchronize];
    
    if ([contcat.phoneNumber rangeOfString:@"+86 "].location != NSNotFound) {
        contcat.phoneNumber =  [contcat.phoneNumber substringFromIndex:4];
    }
    
    NSString *phoneStr = [NSString stringWithFormat:@"tel://%@", contcat.phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
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
        if (tempStr) {
            [numberString appendString:tempStr];
        }
        
        tempStr = @"";
    }
    
    return numberString;
}

@end
