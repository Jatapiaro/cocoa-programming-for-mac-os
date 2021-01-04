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
        _speechSynth.delegate = self;

        _voices = [NSSpeechSynthesizer availableVoices];
    }
    return self;
}

- (void)awakeFromNib
{
    // When tv appears on screen, the default voice should be selected
    NSInteger defaultVoiceRow = [_voices indexOfObject:[NSSpeechSynthesizer defaultVoice]];
    NSIndexSet *indices = [NSIndexSet indexSetWithIndex:defaultVoiceRow];
    [_tableView selectRowIndexes:indices byExtendingSelection:NO];
    [_tableView scrollRowToVisible:defaultVoiceRow];
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
    _speak.enabled = NO;
    _stop.enabled = YES;
    _tableView.enabled = NO;
}

- (IBAction)stopIt:(id)sender
{
    [_speechSynth stopSpeaking];
}

// MARK: NSSpeechSynthesizerDelegate

- (void)speechSynthesizer:(NSSpeechSynthesizer *)sender didFinishSpeaking:(BOOL)finishedSpeaking
{
    _speak.enabled = YES;
    _stop.enabled = NO;
    _tableView.enabled = YES;
}

// MARK: TableView data source informal protocol

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return _voices.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSDictionary *voiceAttributes = [NSSpeechSynthesizer attributesForVoice:[_voices objectAtIndex:row]];
    return [voiceAttributes objectForKey:NSVoiceName];
}

// MARK: TableView delegate

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSInteger row = _tableView.selectedRow;
    if (row == -1)
        return;

    [_speechSynth setVoice:[_voices objectAtIndex:row]];
}

@end
