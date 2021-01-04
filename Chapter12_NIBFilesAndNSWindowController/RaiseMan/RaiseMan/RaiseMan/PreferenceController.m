//
//  PreferenceController.m
//  RaiseMan
//
//  Created by Jacobo Tapia on 01/08/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import "PreferenceController.h"

@interface PreferenceController ()

@end

@implementation PreferenceController

- (id)init
{
    self = [super initWithWindowNibName:@"Preferences"];

    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (void)changeBackgroundColor:(id)sender
{
    NSColor *color = _colorWell.color;
    NSLog(@"Color changed: %@ color", color);
}

- (void)changeNewEmptyDocument:(id)sender
{
    NSControlStateValue state = _checkbox.state;
    NSLog(@"Checkbox changed: %ld color", state);
}

@end
