//
//  Employee.m
//  ManualRaiseMan
//
//  Created by Jacobo Tapia on 16/07/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import "Employee.h"

@implementation Employee

- (id)init
{
    self = [super init];

    if (self)
    {
        _name = @"Employee name";
        _expectedRaise = 0.5;
    }

    return self;
}

- (void)setNilValueForKey:(NSString *)key
{
    if ([key isEqualToString:@"expectedRaise"])
        _expectedRaise = 0.0;
    else
        [super setNilValueForKey:key];
}

@end
