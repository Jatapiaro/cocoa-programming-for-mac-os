//
//  CarArrayController.m
//  CarLot
//
//  Created by Jacobo Tapia on 25/07/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import "CarArrayController.h"

@implementation CarArrayController

- (id)newObject
{
    id newObject = [super newObject];
    NSDate *now = [NSDate date];
    [newObject setValue:now forKey:@"datePurchased"];
    return newObject;
}

@end
