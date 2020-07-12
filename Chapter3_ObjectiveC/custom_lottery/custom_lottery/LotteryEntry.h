//
//  LotteryEntry.h
//  custom_lottery
//
//  Created by Jacobo Tapia on 10/07/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LotteryEntry : NSObject {
    NSDate *_entryDate;
    int _firstNumber;
    int _secondNumber;
}

- (id)initWithEntryDate:(NSDate *)date;
- (void)setEntryDate:(NSDate *)date;
- (NSDate *)entryDate;
- (int)firstNumber;
- (int)secondNumber;

@end

NS_ASSUME_NONNULL_END
