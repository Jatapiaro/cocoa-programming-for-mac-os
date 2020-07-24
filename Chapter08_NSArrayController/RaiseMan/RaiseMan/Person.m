//
//  Person.m
//  RaiseMan
//
//  Created by Jacobo Tapia on 16/07/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import "Person.h"

@implementation Person

- (id)init
{
    self = [super init];

    if (self) {
        _name = @"New Person";
        _expectedRaise = 0.05;
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
