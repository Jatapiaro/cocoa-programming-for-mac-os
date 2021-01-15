//
//  AppDelegate.m
//  RanchForecast
//
//  Created by Jacobo Tapia de la Rosa on 1/14/21.
//

#import "AppDelegate.h"
#import "MainWindowController.h"

@interface AppDelegate ()
@end

@implementation AppDelegate {
    MainWindowController *_mainWindowController;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _mainWindowController = [[MainWindowController alloc] init];
    [_mainWindowController showWindow:self];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    // Insert code here to tear down your application
}


@end
