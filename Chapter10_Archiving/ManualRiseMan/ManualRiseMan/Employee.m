//
//  Employee.m
//  ManualRiseMan
//
//  Created by Jacobo Tapia on 16/07/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import "Employee.h"

@implementation Employee

- (id)init
{
    return [self initWithName:@"Person name" expectedRaise:0.5];
}

- (id)initWithName:(NSString *)name expectedRaise:(float)raise
{
    self = [super init];

    if (self)
    {
        _name = name;
        _expectedRaise = raise;
    }

    return self;
}

// MARK: KVO

- (void)setNilValueForKey:(NSString *)key
{
    if ([key isEqualToString:@"expectedRaise"])
        _expectedRaise = 0.0;
    else
        [super setNilValueForKey:key];
}

// MARK: Archiving

- (id)initWithCoder:(NSCoder *)coder
{
    NSString *name = [coder decodeObjectOfClass:NSString.class forKey:@"name"];
    float expectedRaise = [coder decodeFloatForKey:@"expectedRaise"];
    return [self initWithName:name expectedRaise:expectedRaise];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeFloat:_expectedRaise forKey:@"expectedRaise"];
}

+ (BOOL)supportsSecureCoding
{
    return YES;
}

@end
