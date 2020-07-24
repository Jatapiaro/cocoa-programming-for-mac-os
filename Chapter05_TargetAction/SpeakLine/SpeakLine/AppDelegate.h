//
//  AppDelegate.h
//  SpeakLine
//
//  Created by Jacobo Tapia on 12/07/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSSpeechSynthesizer *_speechSynth;
}

@property (weak) IBOutlet NSTextField *textField;

- (IBAction)stopIt:(id)sender;
- (IBAction)speakIt:(id)sender;

@end

