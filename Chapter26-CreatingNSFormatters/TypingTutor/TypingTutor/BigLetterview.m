//
//  BigLetterview.m
//  TypingTutor
//
//  Created by Jacobo Tapia de la Rosa on 1/10/21.
//

#import "BigLetterview.h"

@interface BigLetterview ()
@end

@implementation BigLetterview {
    NSMutableDictionary *_attributes;
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
    _string = @" ";
    _color = NSColor.lightGrayColor;

    _attributes = [NSMutableDictionary dictionary];
    _attributes[NSFontAttributeName] = [NSFont userFontOfSize:75];
    _attributes[NSForegroundColorAttributeName] = NSColor.redColor;
}

- (void)setColor:(NSColor *)color
{
    _color = color;
    self.needsDisplay = YES;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSRect bounds = self.bounds;

    [_color set];
    [NSBezierPath fillRect:bounds];

    [self _drawStringCenteredInRect:bounds];

    if ((self.window.firstResponder == self) && NSGraphicsContext.currentContextDrawingToScreen) {
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

- (BOOL)becomeFirstResponder
{
    self.needsDisplay = YES;
    return YES;
}

- (BOOL)acceptsFirstResponder
{
    return YES;
}

- (BOOL)resignFirstResponder
{
    [self setKeyboardFocusRingNeedsDisplayInRect:self.bounds];
    return YES;
}

- (void)setString:(NSString *)string
{
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

    [_string drawAtPoint:stringOrigin withAttributes:_attributes];
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

@end
