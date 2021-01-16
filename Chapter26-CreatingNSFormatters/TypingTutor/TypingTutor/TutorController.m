//
//  TutorController.m
//  TypingTutor
//
//  Created by Jacobo Tapia de la Rosa on 1/10/21.
//

#import "TutorController.h"
#import "BigLetterview.h"

@interface TutorController () <NSControlTextEditingDelegate>
@property (nonatomic, weak) IBOutlet BigLetterview *inLetterView;
@property (nonatomic, weak) IBOutlet BigLetterview *outLetterView;
@property (nonatomic, weak) IBOutlet NSProgressIndicator *progressIndicator;
@property (nonatomic, weak) IBOutlet NSWindow *speedSheet;
@property (nonatomic, weak) IBOutlet NSSlider *speedSlider;
@property (nonatomic, weak) IBOutlet NSButton *startStopButton;

@property (nonatomic, weak) IBOutlet NSColorWell *colorWell;
@property (nonatomic, weak) IBOutlet NSTextField *colorTextField;

- (IBAction)colorWellValueDidChange:(NSColorWell *)sender;
@end

@implementation TutorController {
    NSArray *_letters;
    NSInteger _lastIndex;

    NSTimeInterval _startTime;
    NSTimeInterval _elapsedTime;
    NSTimeInterval _timeLimit;
    NSTimer *_timer;
}

- (instancetype)init
{
    if (!(self = [super init]))
        return nil;

    _letters = @[@"d", @"f", @"j", @"k", @"l", @";"];
    srandom((unsigned)time(NULL));
    _timeLimit = 5.0;

    return self;
}

- (void)awakeFromNib
{
    [self _configureProgressIndicatorWithTimeLimit:_timeLimit];
    _colorWell.color = _inLetterView.color;
    _colorTextField.objectValue = _inLetterView.color;
}

- (void)_configureProgressIndicatorWithTimeLimit:(NSTimeInterval)timeLimit
{
    _progressIndicator.maxValue = timeLimit;
    _progressIndicator.doubleValue = 0;
}

- (void)stopGo:(NSButton *)sender
{
    [self _resetElapsedTime];

    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(_checkThem:) userInfo:nil repeats:YES];
        sender.title = @"Stop";
        return;
    }

    sender.title = @"Go";
    [_timer invalidate];
    _timer = nil;
    _outLetterView.string = @"";
    _inLetterView.string = @"";
}

- (void)showSpeedSheet:(id)sender
{
    if (_timer)
        [self stopGo:_startStopButton];

    [self.view.window beginSheet:_speedSheet completionHandler:^(NSModalResponse returnCode) {
        self->_timeLimit = self->_speedSlider.integerValue;
        [self _configureProgressIndicatorWithTimeLimit:self->_timeLimit];
    }];
}

- (void)endSpeedSheet:(id)sender
{
    [self.view.window endSheet:_speedSheet];
}

- (void)_checkThem:(NSTimer *)timer
{
    if ([_inLetterView.string isEqualToString:_outLetterView.string])
        [self _showAnotherLetter];

    [self _updateElapsedTime];
    if (_elapsedTime >= _timeLimit) {
        NSBeep();
        // [self _resetElapsedTime];
        [self _showAnotherLetter];
    }
}

- (void)_showAnotherLetter
{
    NSInteger x = _lastIndex;
    while (x == _lastIndex)
        x = (int)(random() % _letters.count);

    _lastIndex = x;
    _outLetterView.string = _letters[_lastIndex];
    [self _resetElapsedTime];
}

- (void)_resetElapsedTime
{
    _startTime = [NSDate timeIntervalSinceReferenceDate];
    [self _updateElapsedTime];
}

- (void)_updateElapsedTime
{
    _elapsedTime = [NSDate timeIntervalSinceReferenceDate] - _startTime;
    _progressIndicator.doubleValue = _elapsedTime;
}

- (void)colorWellValueDidChange:(NSColorWell *)sender
{
    _colorTextField.objectValue = sender.color;
    _inLetterView.color = sender.color;
}

- (void)controlTextDidChange:(NSNotification *)obj
{
    if (!_colorTextField.objectValue)
        return;

    NSAssert(NSThread.isMainThread, @"Ok");
    _colorWell.objectValue = _colorTextField.objectValue;
    _inLetterView.color = _colorWell.color;
}

- (BOOL)control:(NSControl *)control didFailToFormatString:(NSString *)string errorDescription:(NSString *)error
{
    NSLog(@"Error: %@", error);
    return NO;
}

@end
