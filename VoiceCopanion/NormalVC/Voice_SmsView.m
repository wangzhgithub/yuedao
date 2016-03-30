//
//  Voice_SmsView.m
//  VoiceCopanion
//
//  Created by 米翊米 on 15/8/31.
//  Copyright (c) 2015年 米翊米. All rights reserved.
//

#import "Voice_SmsView.h"

@interface Voice_SmsView ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *tempArray;
    NSMutableArray *smsArray;
    NSUserDefaults *userDef;
}
@end

@implementation Voice_SmsView
@synthesize smsTableView;
@synthesize viewType;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        smsTableView = [[UITableView alloc] initWithFrame:CGRectMake(20, (SCRH-(SCRH/5*2))/2, SCRW-40, SCRH/5*2) style:UITableViewStylePlain];
        smsTableView.bounces = YES;
        smsTableView.backgroundColor = [UIColor whiteColor];
        smsTableView.alpha = 1.0;
        smsTableView.center = self.center;
        smsTableView.layer.cornerRadius = 5.0;
        smsTableView.dataSource = self;
        smsTableView.delegate = self;
        smsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:smsTableView];
        
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        userDef = [NSUserDefaults standardUserDefaults];
        
        [self setExtraCellLineHidden:smsTableView];
        [self initData];
        
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(smsTableView.frame)-12.5, CGRectGetMinY(smsTableView.frame)-12.5, 25, 25)];
        [closeBtn setImage:LOAD_LOCALIMG(@"icon_close") forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
    }
    
    return self;
}

- (NSInteger)initData{
    tempArray = [[NSMutableArray alloc] init];
    smsArray = [[NSMutableArray alloc] init];
    if (viewType) {
        for (int i = 1; i < 6; i++) {
            NSString *tent = [userDef objectForKey:[NSString stringWithFormat:@"tent_%zi", i]];
            NSString *title = [userDef objectForKey:[NSString stringWithFormat:@"title_%zi", i]];
            
            if (title.length > 0) {
                [tempArray addObject:title];
                [smsArray addObject:tent];
            }
        }
        
        if (tempArray.count < 5) {
            [tempArray addObject:@"添加短信模板"];
        }
    }else{
        for (int i = 1; i < 6; i++) {
            NSString *tent = [userDef objectForKey:[NSString stringWithFormat:@"tent_%zi", i]];
            NSString *title = [userDef objectForKey:[NSString stringWithFormat:@"title_%zi", i]];
            
            if (title.length > 0) {
                [tempArray addObject:title];
                [smsArray addObject:tent];
            }
        }
    }
    
    return tempArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self initData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 43.5, SCRW-20, 0.5)];
        line.backgroundColor = LMH_COLOR_LINE;
        [cell addSubview:line];
    }
    cell.textLabel.text = tempArray[row];
    
    UIView *view_bg = [[UIView alloc]initWithFrame:cell.frame];
    view_bg.backgroundColor = LMH_COLOR_SKIN;
    cell.selectedBackgroundView = view_bg;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    
    if ([self.smsDelegate respondsToSelector:@selector(selectIndex:)]) {
        if (viewType == 0) {
            [userDef setValue:smsArray[row] forKey:@"tent"];
            [userDef synchronize];
        }
        [self.smsDelegate selectIndex:row];
    }
    
    self.hidden = YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *tmpStr = tempArray[indexPath.row];
    if (viewType == 1 && ![tmpStr isEqualToString:@"添加短信模板"]) {
        return UITableViewCellEditingStyleDelete;
    }else{
        return UITableViewCellEditingStyleNone;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [smsArray removeObjectAtIndex:indexPath.row];
    [tempArray removeObjectAtIndex:indexPath.row];
    
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
    
    [smsTableView reloadData];
}

- (void)setExtraCellLineHidden:(UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)closeClick{
    if (viewType==1) {
        if ([self.smsDelegate respondsToSelector:@selector(selectIndex:)]) {
            [self.smsDelegate selectIndex:-1];
        }
    }
    self.hidden = YES;
}

@end
