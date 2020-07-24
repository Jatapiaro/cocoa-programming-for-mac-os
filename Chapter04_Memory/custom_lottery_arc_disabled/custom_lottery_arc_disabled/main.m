//
//  main.m
//  custom_lottery
//
//  Created by Jacobo Tapia on 10/07/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LotteryEntry.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSDate *now = [NSDate now];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *weekComponents = [[NSDateComponents alloc] init];

        srand((unsigned)time(NULL));

        NSMutableArray<LotteryEntry *> *array = [NSMutableArray array];
        for (int i = 0; i < 10; i++) {
            [weekComponents setWeek:i];
            // Create a date / time object that is i weeks away from now
            NSDate *iWeeksFromNow = [calendar dateByAddingComponents:weekComponents toDate:now options:0];

            // Create new lottery instance. At this point retain count is 1
            LotteryEntry *lotteryEntry = [[LotteryEntry alloc] initWithEntryDate:iWeeksFromNow];
            // lotteryEntry retain count is 2 after adding it
            [array addObject:lotteryEntry];
            // Release it so the array has ownership of the object.
            // If we don't do that after releasing the array the ret count will be 1.
            [lotteryEntry release];
        }

        // Done with now and weekComponents
        [now release];
        [weekComponents release];

        for (LotteryEntry *entry in array)
            NSLog(@"%@", entry);

        [array release];

    }
    return 0;
}
