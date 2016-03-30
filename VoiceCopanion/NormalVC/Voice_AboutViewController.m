//
//  Voice_AboutViewController.m
//  VoiceCopanion
//
//  Created by 米翊米 on 15/6/26.
//  Copyright (c) 2015年 米翊米. All rights reserved.
//

#import "Voice_AboutViewController.h"

@interface Voice_AboutViewController ()

@end

@implementation Voice_AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"关于约到";
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.font = LMH_FONT_15;
    textLabel.numberOfLines = 0;
    textLabel.textColor = LMH_COLOR_GRAYTEXT;
    [self.view addSubview:textLabel];
    
    textLabel.text = @"    约到是一款高效智能的通讯辅助APP，用户设置短信后，在拨号界面拨打电话的同时可以短信告知被呼叫方此次呼叫的目的或者身份信息。例如快递行业，快递员送件无法联系上用户，可以短信告知用户自己的身份以及送货信息，让用户联系自己。";
    
    CGSize textSzie = [textLabel.text boundingRectWithSize:CGSizeMake(SCRW-10, 1000) options:NSStringDrawingTruncatesLastVisibleLine |
                       NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:textLabel.font} context:nil].size;
    textLabel.frame = CGRectMake(10, 10, SCRW-20, textSzie.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
