//
//  LotteryEntry.m
//  custom_lottery
//
//  Created by Jacobo Tapia on 10/07/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import "LotteryEntry.h"

@implementation LotteryEntry

- (id)init
{
    return [self initWithEntryDate:[NSDate date]];
}

- (void)dealloc
{
    NSLog(@"deallocating %@", self);
    [_entryDate release];
    [super dealloc];
}

- (id)initWithEntryDate:(NSDate *)date
{
    self = [super init];

    if (self) {
        NSAssert(date != nil, @"Argument must be non nil");
        _entryDate = [date retain];
        _firstNumber = ((unsigned)random() % 100) + 1;
        _secondNumber = ((unsigned)random() % 100) + 1;
    }

    return self;
}

- (void)setEntryDate:(NSDate *)date
{
    [date retain];
    [_entryDate retain];
    _entryDate = date; 
}

- (NSDate *)entryDate
{
    return _entryDate;
}

- (int)firstNumber
{
    return _firstNumber;
}

- (int)secondNumber
{
    return _secondNumber;
}

- (NSString *)description
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];

    [dateFormatter autorelease];
    return [[NSString alloc] initWithFormat:@"%@ = %d and %d", [dateFormatter stringFromDate:_entryDate], _firstNumber, _secondNumber];
}

@end
