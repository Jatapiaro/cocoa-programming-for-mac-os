//
//  NSMutableArrayExtras.m
//  ManualRaiseMan
//
//  Created by Jacobo Tapia on 8/30/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import "NSMutableArrayExtras.h"

@implementation NSMutableArray (NSMutableArrayExtras)

- (NSIndexSet *)indexesOfObjectsInArray:(NSArray *)array
{
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
    for (id obj in array)
        [indexes addIndex:[self indexOfObject:obj]];

    return indexes;
}

@end
