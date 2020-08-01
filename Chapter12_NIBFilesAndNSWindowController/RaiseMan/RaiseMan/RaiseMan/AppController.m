//
//  AppController.m
//  RaiseMan
//
//  Created by Jacobo Tapia on 01/08/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import "AppController.h"
#import "PreferenceController.h"

@implementation AppController {
    PreferenceController *preferenceController;
}

- (void)showAboutPanel:(id)sender
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
    [NSBundle loadNibNamed:@"About" owner:nil];
#pragma clang diagnostic pop
}

- (void)showPreferencePanel:(id)sender
{
    if (!preferenceController)
        preferenceController = [[PreferenceController alloc] init];

    [preferenceController showWindow:nil];
}

@end
