//
//  Contact.h
//  upsi
//
//  Created by Mac on 3/24/14.
//  Copyright (c) 2014 Laith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface THContact : NSObject

@property (nonatomic, assign) NSInteger recordId;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *recordTime;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *type;

@end
