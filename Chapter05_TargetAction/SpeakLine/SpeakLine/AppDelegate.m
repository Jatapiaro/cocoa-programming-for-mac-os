//
//  AppDelegate.m
//  SpeakLine
//
//  Created by Jacobo Tapia on 12/07/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (id)init
{
    self = [super init];
    if (self) {
        NSLog(@"Init");

        _speechSynth = [[NSSpeechSynthesizer alloc] initWithVoice:nil];
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)speakIt:(id)sender
{
    NSString *textToSay = _textField.stringValue;
    if (textToSay.length == 0)
        return;

    [_speechSynth startSpeakingString:textToSay];
}

- (IBAction)stopIt:(id)sender
{
    [_speechSynth stopSpeaking];
}

@end
