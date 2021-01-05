//
//  BigLetterView.m
//  TypingTutor
//
//  Created by Jacobo Tapia de la Rosa on 1/4/21.
//

#import "BigLetterView.h"

@implementation BigLetterView {
    BOOL _highlight;
    NSMutableDictionary *_attributes;
    BOOL _italic;
    BOOL _bold;
}

- (instancetype)initWithFrame:(NSRect)frame
{
    if (!(self = [super initWithFrame:frame]))
        return nil;

    [self _commonInit];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (!(self = [super initWithCoder:coder]))
        return nil;

    [self _commonInit];
    return self;
}

- (void)_commonInit
{
    self.window.acceptsMouseMovedEvents = YES;
    _color = NSColor.lightGrayColor;
    _string = @" ";

    _attributes = [NSMutableDictionary dictionary];
    _attributes[NSFontAttributeName] = [NSFont userFontOfSize:75];
    _attributes[NSForegroundColorAttributeName] = NSColor.redColor;
}

- (void)viewDidMoveToWindow
{
    int options = NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingInVisibleRect;

    NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSRect bounds = self.bounds;

    if (_highlight)
        [NSColor.highlightColor set];
    else
        [_color set];

    [NSBezierPath fillRect:bounds];

    [self _drawStringCenteredInRect:bounds];

    // Am I the window's first responder?
    if ((self.window.firstResponder == self) &&
        [NSGraphicsContext currentContextDrawingToScreen]) {
        [NSGraphicsContext saveGraphicsState];
        NSSetFocusRingStyle(NSFocusRingOnly);
        [NSBezierPath fillRect:bounds];
        [NSGraphicsContext restoreGraphicsState];
    }
}

- (BOOL)isOpaque
{
    return YES;
}

- (void)setColor:(NSColor *)color
{
    _color = color;
    self.needsDisplay = YES;
}

- (void)setString:(NSString *)string
{
    NSLog(@"The string is now: %@", string);
    _string = [string copy];
    self.needsDisplay = YES;
}

- (void)_drawStringCenteredInRect:(NSRect)rect
{
    NSSize stringSize = [_string sizeWithAttributes:_attributes];
    NSPoint stringOrigin = {
        rect.origin.x + (NSWidth(rect) - stringSize.width) / 2,
        rect.origin.y + (NSHeight(rect) - stringSize.height) / 2
    };

    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = NSMakeSize(stringSize.width / 2, stringSize.height / 2);
    shadow.shadowBlurRadius = 10;
    shadow.shadowColor = NSColor.purpleColor;
    _attributes[NSShadowAttributeName] = shadow;

    [_string drawAtPoint:stringOrigin withAttributes:_attributes];
}

// MARK: First Responder

- (BOOL)acceptsFirstResponder
{
    NSLog(@"Accepting");
    return YES;
}

- (BOOL)resignFirstResponder
{
    NSLog(@"Resigning");
    [self setKeyboardFocusRingNeedsDisplayInRect:self.bounds];
    return YES;
}

- (BOOL)becomeFirstResponder
{
    NSLog(@"Becoming");
    self.needsDisplay = YES;
    return YES;
}

// MARK: Key Events

- (void)keyDown:(NSEvent *)event
{
    [self interpretKeyEvents:@[ event ]];
}

- (void)insertText:(NSString *)insertString
{
    self.string = insertString;
}

- (void)insertTab:(id)sender
{
    [self.window selectKeyViewFollowingView:self];
}

- (void)insertBacktab:(id)sender
{
    [self.window selectKeyViewPrecedingView:self];
}

- (void)deleteBackward:(id)sender
{
    self.string = @" ";
}

// MARK: Mouse Events

- (void)mouseEntered:(NSEvent *)event
{
    _highlight = YES;
    self.needsDisplay = YES;
}

- (void)mouseExited:(NSEvent *)event
{
    _highlight = NO;
    self.needsDisplay = YES;
}

// MARK: Actions

- (void)savePDF:(id)sender
{
    __block NSSavePanel *savePanel = [NSSavePanel savePanel];
    savePanel.allowedFileTypes = @[ @"pdf" ];

    [savePanel beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse result) {
        if (result != NSModalResponseOK)
            return;

        NSRect rect = self.bounds;
        NSData *data = [self dataWithPDFInsideRect:rect];

        NSError *error;
        BOOL successful = [data writeToURL:savePanel.URL options:0 error:&error];
        if (!successful) {
            NSAlert *alert = [NSAlert alertWithError:error];
            [alert runModal];
        }

        savePanel = nil;
    }];
}

- (void)boldStateDidChange:(NSButton *)sender
{
    _bold = sender.state == NSControlStateValueOn;

    NSFontManager *fontManager = NSFontManager.sharedFontManager;
    NSFont *font = _attributes[NSFontAttributeName];
    if (_bold)
        _attributes[NSFontAttributeName] = [fontManager convertFont:font toHaveTrait:NSFontBoldTrait];
    else
        _attributes[NSFontAttributeName] = [fontManager convertFont:font toNotHaveTrait:NSFontBoldTrait];

    self.needsDisplay = YES;
}

- (void)italicStateDidChange:(NSButton *)sender
{
    _italic = sender.state == NSControlStateValueOn;

    NSFontManager *fontManager = NSFontManager.sharedFontManager;
    NSFont *font = _attributes[NSFontAttributeName];
    if (_italic)
        _attributes[NSFontAttributeName] = [fontManager convertFont:font toHaveTrait:NSFontItalicTrait];
    else
        _attributes[NSFontAttributeName] = [fontManager convertFont:font toNotHaveTrait:NSFontItalicTrait];

    self.needsDisplay = YES;
}

@end
