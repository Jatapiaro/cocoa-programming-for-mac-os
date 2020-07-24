//
//  AppDelegate.h
//  SpeakLine
//
//  Created by Jacobo Tapia on 12/07/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, NSSpeechSynthesizerDelegate, NSTableViewDelegate, NSTableViewDataSource> {
    NSSpeechSynthesizer *_speechSynth;
    NSArray *_voices;
}

@property (weak) IBOutlet NSTextField *textField;
@property (weak) IBOutlet NSButton *speak;
@property (weak) IBOutlet NSButton *stop;
@property (weak) IBOutlet NSTableView *tableView;

- (IBAction)stopIt:(id)sender;
- (IBAction)speakIt:(id)sender;

@end

