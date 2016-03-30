//
//  BaseTableViewController.h
//  VoiceCopanion
//
//  Created by 米翊米 on 15/4/8.
//  Copyright (c) 2015年 米翊米. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface BaseTableViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

-(id)initWithStyle:(UITableViewStyle)style;

@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,assign)BOOL edgeInsetsZero;

@end
