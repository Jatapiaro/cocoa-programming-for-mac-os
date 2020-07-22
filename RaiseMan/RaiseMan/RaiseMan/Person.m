//
//  Person.m
//  RaiseMan
//
//  Created by Jacobo Tapia on 19/07/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import "Person.h"

@implementation Person

- (id)init
{
    return [self initWithName:@"New Employee" expectedRaise:0.5];
}

- (id)initWithName:(NSString *)name expectedRaise:(float)expectedRaise
{
    self = [super init];

    if (self) {
        _name = name;
        _expectedRaise = expectedRaise;
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

// MARK: Encoding

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
