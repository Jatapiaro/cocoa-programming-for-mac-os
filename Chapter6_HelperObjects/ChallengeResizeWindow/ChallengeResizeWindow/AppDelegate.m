//
//  AppDelegate.m
//  ChallengeResizeWindow
//
//  Created by Jacobo Tapia on 13/07/20.
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

- (NSSize)windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize
{
    CGFloat width = frameSize.width;
    return NSMakeSize(width, width * 2);
}

- (void)windowDidResize:(NSNotification *)notification
{
    CGFloat width = NSWidth(_window.frame);
    CGFloat height = NSHeight(_window.frame);
    NSAssert(height == (width * 2), @"Height should be the width twice");
}

@end
