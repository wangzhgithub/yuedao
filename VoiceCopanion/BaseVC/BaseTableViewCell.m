//
//  BaseTableViewCell.m
//  Urtime
//
//  Created by wangzh on 15/10/29.
//  Copyright © 2015年 米翊米. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] )
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        //self.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    return self;
}

@end
