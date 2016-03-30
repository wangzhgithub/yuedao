//
//  BaseTableViewController.m
//  VoiceCopanion
//
//  Created by 米翊米 on 15/4/8.
//  Copyright (c) 2015年 米翊米. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()


@end



@implementation BaseTableViewController
@synthesize tableview;
@synthesize edgeInsetsZero;

-(id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.edgeInsetsZero = YES;
    }
    
    return self;
}

- (void)loadView{
    [super loadView];
    
    CGFloat viewH = SCRH;
    if (!self.navHiden) {
        viewH -= NAVHEIGHT;
    }
    if (!self.tabHiden) {
        viewH -= TABHEIGHT;
    }
    
//    NSLog(@"viewH = %f",viewH);
    if (!tableview) {
        tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCRW, viewH) style:UITableViewStylePlain];
        tableview.dataSource = self;
        tableview.delegate = self;
        
        tableview.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:tableview];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    //设置cell分割线起始位置
    if ([tableview respondsToSelector:@selector(setSeparatorInset:)] && edgeInsetsZero) {
        [tableview setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableview respondsToSelector:@selector(setLayoutMargins:)] && edgeInsetsZero) {
        [tableview setLayoutMargins:UIEdgeInsetsZero];
    }
    //清除多余分割线
    [self setExtraCellLineHidden:tableview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

//设置cell分割线起始位置
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)] && edgeInsetsZero) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)] && edgeInsetsZero) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    return cell;
}

@end
