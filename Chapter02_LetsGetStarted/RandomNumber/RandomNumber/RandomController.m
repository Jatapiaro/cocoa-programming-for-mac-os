//
//  RandomController.m
//  RandomNumber
//
//  Created by Jacobo Tapia on 09/07/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import "RandomController.h"

@implementation RandomController

// At this point the objects from the XIB file were
// brought back to life, but no events are being handled.
- (void)awakeFromNib
{
    NSDate *now = [NSDate date];
    [_textField setObjectValue:now];
}

- (IBAction)generate:(id)sender
{
    int generated = (int)(random() * 100) + 1;
    [_textField setIntValue:generated];
}

- (IBAction)seed:(id)sender
{
    srand((unsigned)time(NULL));
    [_textField setStringValue:@"Generator seeded"];
}

@end
