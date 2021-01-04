//
//  AppController.m
//  ManualRaiseMan
//
//  Created by Jacobo Tapia on 01/08/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import "AppController.h"
#import "PreferencesController.h"

@implementation AppController {
    PreferencesController *preferencesController;
}

- (void)showAboutPanel:(id)sender
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
    [NSBundle loadNibNamed:@"AboutPanel" owner:self];
#pragma clang diagnostic pop
}

- (void)showPreferencesPanel:(id)sender
{
    if (!preferencesController)
        preferencesController = [[PreferencesController alloc] init];

    [preferencesController showWindow:nil];
}

@end
