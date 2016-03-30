//
//  Voice_SmsView.h
//  VoiceCopanion
//
//  Created by 米翊米 on 15/8/31.
//  Copyright (c) 2015年 米翊米. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Voice_SmsViewDelegate <NSObject>

- (void)selectIndex:(NSInteger)index;

@end

@interface Voice_SmsView : UIView

@property(nonatomic,strong)UITableView *smsTableView;
@property(nonatomic,strong)id <Voice_SmsViewDelegate>smsDelegate;
@property(nonatomic)NSInteger viewType;

@end
