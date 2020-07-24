//
//  AppDelegate.m
//  KvcFun
//
//  Created by Jacobo Tapia on 15/07/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import "AppDelegate.h"

const NSString *fidoKey = @"fido";

@interface AppDelegate ()
@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

// @synthesize fido; // This is no longer needed
@synthesize fido = _fido; // This is no longer needed too. This just add prefix

- (id)init
{
    self = [super init];

    if (self) {
        [self setValue:[NSNumber numberWithInt:5] forKey:fidoKey];
        NSNumber *n = [self valueForKey:fidoKey];

        NSLog(@"fido = %@", n);
    }

    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)incrementFido:(id)sender
{
    [self willChangeValueForKey:fidoKey];
    _fido++;
    [self didChangeValueForKey:fidoKey];

    /**
     Either use the setter method:

        [self setFido:[self fido] + 1];

     or using key value coding:

        NSNumber *n = [self valueForKey:@"fido"];
        NSNumber *npp = [NSNumber numberWithInt:[n intValue] + 1];
        [self setValue:npp forKey:@"fido"];

     could work here too
     */
}

@end
