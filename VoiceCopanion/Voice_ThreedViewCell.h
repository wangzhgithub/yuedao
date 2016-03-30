//
//  Voice_ThreedViewCell.h
//  VoiceCopanion
//
//  Created by wangzh on 16/3/9.
//  Copyright © 2016年 米翊米. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface Voice_ThreedViewCell : BaseTableViewCell{
//    UITextField *titleFiled;
//    UITextView  *contview;
    UILabel     *placeLabel;
}
@property (strong, nonatomic) UITextField *titleFiled;
@property (strong, nonatomic) UITextView *contview;

@property (nonatomic)NSString *FieldText;
@property (nonatomic)NSString *ViewText;
- (void)createUI:(NSString*)titleText countText:(NSString*)countText;

@end
