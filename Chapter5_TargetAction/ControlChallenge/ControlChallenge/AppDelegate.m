//
//  AppDelegate.m
//  ControlChallenge
//
//  Created by Jacobo Tapia on 12/07/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (IBAction)calculate:(id)sender
{
    NSString *userText = _textField.stringValue;
    if (userText.length == 0) {
        _result.stringValue = @"???";
        return;
    }

    _result.stringValue = [[NSString alloc] initWithFormat:@"'%@' has %lu characters", userText, userText.length];
}
@end
