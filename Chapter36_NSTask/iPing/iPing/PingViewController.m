//
//  PingViewController.m
//  iPing
//
//  Created by Jacobo Tapia de la Rosa on 7/5/21.
//

#import "PingViewController.h"

@interface PingViewController ()
@property (nonatomic, weak) IBOutlet NSTextView *outputView;
@property (nonatomic, weak) IBOutlet NSTextField *hostField;
@property (nonatomic, weak) IBOutlet NSButton *pingButton;
@end

@implementation PingViewController {
    NSTask *_task;
    NSPipe *_pipe;
}

- (IBAction)startStopPing:(NSButton *)sender
{
    NSString *host = _hostField.stringValue;
    if (!_task && !host.length)
        return;
    
    NSNotificationCenter *notificationCenter = NSNotificationCenter.defaultCenter;
    if (_task) {
        [_task interrupt];
        _task = nil;
        _pipe = nil;
        [notificationCenter removeObserver:self];
        _pingButton.title = @"Start Ping";
        return;
    }
    
    _pingButton.title = @"Stop Ping";
    _task = [[NSTask alloc] init];
    _task.launchPath = @"/sbin/ping";
    _task.arguments = @[ @"-c10", host ];
    
    // Create a new pipe
    _pipe = [[NSPipe alloc] init];
    _task.standardOutput = _pipe;
    
    NSFileHandle *fh = _pipe.fileHandleForReading;
    [notificationCenter addObserver:self selector:@selector(_dataReady:) name:NSFileHandleReadCompletionNotification object:fh];
    [notificationCenter addObserver:self selector:@selector(_taskTerminated:) name:NSTaskDidTerminateNotification object:_task];
    
    [_task launch];
    _outputView.string = @"";
    [fh readInBackgroundAndNotify];
}

- (void)_dataReady:(NSNotification *)notification
{
    NSData *data = notification.userInfo[NSFileHandleNotificationDataItem];
    if (!data.length)
        return;
    
    [self _appendData:data];
    
    // If task is running, start reading again
    [_pipe.fileHandleForReading readInBackgroundAndNotify];
}

- (void)_appendData:(NSData *)data
{
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSTextStorage *textStorage = _outputView.textStorage;
    [textStorage replaceCharactersInRange:NSMakeRange(textStorage.length, 0) withString:string];
}

- (void)_taskTerminated:(NSNotification *)notification
{
    _task = nil;
    _pipe = nil;
    _pingButton.title = @"Start Ping";
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

@end
