//
//  AppController.m
//  RaiseMan
//
//  Created by Jacobo Tapia on 01/08/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import "AppController.h"
#import "PreferenceController.h"
#import "AppConstants.h"

@implementation AppController {
    PreferenceController *preferenceController;
}

+ (void)initialize
{
    NSData *colorAsData = [NSKeyedArchiver archivedDataWithRootObject:NSColor.yellowColor requiringSecureCoding:NO error:nil];
    NSNumber *openUntitled = [NSNumber numberWithBool:YES];

    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:@[
                                   colorAsData,
                                   openUntitled,
                               ] forKeys:@[
                                   TableBackgroundColorKey,
                                   EmptyDocumentKey,
                               ]];

    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
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

// MARK: NSApplicationDelegate

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender
{
    return [PreferenceController preferenceEmptyDocument];
}

- (void)applicationDidResignActive:(NSNotification *)notification
{
    NSBeep();
}

@end
