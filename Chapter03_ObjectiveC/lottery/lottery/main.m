//
//  main.m
//  lottery
//
//  Created by Jacobo Tapia on 10/07/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        NSMutableArray<NSNumber *> *array = [NSMutableArray array];
        for (int i = 0; i < 10; i++) {
            NSNumber *newNumber = [[NSNumber alloc] initWithInt:i*3];
            [array addObject:newNumber];
        }

        [array enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop) {
            NSLog(@"The number at index %li is %@", idx, obj);
        }];
    }
    return 0;
}

