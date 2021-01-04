//
//  PreferencesController.m
//  ManualRaiseMan
//
//  Created by Jacobo Tapia on 01/08/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import "PreferencesController.h"

@interface PreferencesController ()

@end

@implementation PreferencesController

-(id)init
{
    self = [self initWithWindowNibName:@"PreferencesPanel"];

    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (void)changeBackgroundColor:(id)sender
{
    NSColor *color = _colorWell.color;
    NSLog(@"Color changed to %@", color);
}

- (void)changeNewEmptyDocument:(id)sender
{
    NSControlStateValue state = _checkBox.state;
    NSLog(@"State changed %ld", state);
}

@end
