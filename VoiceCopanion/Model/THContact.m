//
//  Contact.m
//  upsi
//
//  Created by Mac on 3/24/14.
//  Copyright (c) 2014 Laith. All rights reserved.
//

#import "THContact.h"

@implementation THContact

// 当将一个自定义对象保存到文件的时候就会调用该方法
// 在该方法中说明如何存储自定义对象的属性
// 也就说在该方法中说清楚存储自定义对象的哪些属性
-(void)encodeWithCoder:(NSCoder *)aCoder
{
//    NSLog(@"调用了encodeWithCoder:方法");
    [aCoder encodeInteger:self.recordId forKey:@"recordId"];
    [aCoder encodeObject:self.firstName forKey:@"firstName"];
    [aCoder encodeObject:self.lastName forKey:@"lastName"];
    [aCoder encodeObject:self.phoneNumber forKey:@"phoneNumber"];
    [aCoder encodeObject:self.image forKey:@"image"];
    [aCoder encodeObject:self.recordTime forKey:@"recordTime"];
    [aCoder encodeObject:self.fullName forKey:@"fullName"];
    [aCoder encodeObject:self.type forKey:@"type"];
}

// 当从文件中读取一个对象的时候就会调用该方法
// 在该方法中说明如何读取保存在文件中的对象
// 也就是说在该方法中说清楚怎么读取文件中的对象
-(id)initWithCoder:(NSCoder *)aDecoder
{
//    NSLog(@"调用了initWithCoder:方法");
    //注意：在构造方法中需要先初始化父类的方法
    if (self=[super init]) {
        self.recordId = [aDecoder decodeIntegerForKey:@"recordId"];
        self.firstName = [aDecoder decodeObjectForKey:@"firstName"];
        self.lastName = [aDecoder decodeObjectForKey:@"lastName"];
        self.phoneNumber = [aDecoder decodeObjectForKey:@"phoneNumber"];
        self.image = [aDecoder decodeObjectForKey:@"image"];
        self.recordTime = [aDecoder decodeObjectForKey:@"recordTime"];
        self.fullName = [aDecoder decodeObjectForKey:@"fullName"];
        self.type = [aDecoder decodeObjectForKey:@"type"];
    }
    return self;
}

@end
