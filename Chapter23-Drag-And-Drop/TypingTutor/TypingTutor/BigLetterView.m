//
//  BigLetterView.m
//  TypingTutor
//
//  Created by Jacobo Tapia de la Rosa on 1/4/21.
//

#import "BigLetterView.h"
#import "TypingTutorNSStringExtras.h"

@interface BigLetterView () <NSDraggingSource, NSDraggingDestination>
@end

@implementation BigLetterView {
    BOOL _highlight;
    NSMutableDictionary *_attributes;
    BOOL _italic;
    BOOL _bold;

    NSEvent *_mouseDownEvent;
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

    [self registerForDraggedTypes:@[ NSPasteboardTypeString ]];
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

    if (_highlight) {
        NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:NSColor.whiteColor endingColor:_color];
        [gradient drawInRect:bounds relativeCenterPosition:NSZeroPoint];
    } else {
        [_color set];
        [NSBezierPath fillRect:bounds];
    }

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


// MARK: Mouse Events

- (void)mouseDown:(NSEvent *)event
{
    _mouseDownEvent = event;
}

- (void)mouseDragged:(NSEvent *)event
{
    NSPoint down = _mouseDownEvent.locationInWindow;
    NSPoint drag = event.locationInWindow;

    float distance = hypot(down.x - drag.x, down.y - drag.y);
    if (distance < 3)
        return;

    // Get the string size
    NSSize stringSize = [_string sizeWithAttributes:_attributes];

    // Create the image that will be dragged
    NSImage *dragImage = [[NSImage alloc] initWithSize:stringSize];

    // Create a rect to draw the letter in the image
    NSRect imageBounds;
    imageBounds.origin = NSZeroPoint;
    imageBounds.size = stringSize;

    // Draw the letter on the image
    [dragImage lockFocus];
    [self _drawStringCenteredInRect:imageBounds];
    [dragImage unlockFocus];

    // Get the pasteboard
    NSPasteboard *pasteboard = [NSPasteboard pasteboardWithName:NSPasteboardNameDrag];

    // Put the string in the pasteboard
    [self _writeToPasteboard:pasteboard];

    // Get the location of the mousej down event
    NSPoint mouseDownLocation = [self convertPoint:down fromView:nil];

    // Drag from the center of the image
    mouseDownLocation.x = mouseDownLocation.x - stringSize.width / 2;
    mouseDownLocation.y = mouseDownLocation.y - stringSize.height / 2;

    // Start the drag
    NSPasteboardItem *pasteboardItem = [[NSPasteboardItem alloc] init];
    [pasteboardItem setString:_string.copy forType:NSPasteboardTypeString];

    NSData *pdf = [self _convertViewToPDF];
    [pasteboardItem setData:pdf forType:NSPasteboardTypePDF];

    NSDraggingItem *draggingItem = [[NSDraggingItem alloc] initWithPasteboardWriter:pasteboardItem];
    NSRect draggingFrame;
    draggingFrame.origin = mouseDownLocation;
    draggingFrame.size = stringSize;
    [draggingItem setDraggingFrame:draggingFrame contents:dragImage];

    /* Another way to set the image
        draggingItem.imageComponentsProvider = ^NSArray<NSDraggingImageComponent *> * {
            NSDraggingImageComponent *imageComponent = [[NSDraggingImageComponent alloc] initWithKey:NSDraggingImageComponentIconKey];
            imageComponent.contents = dragImage;
            imageComponent.frame = imageBounds;

            return @[ imageComponent ];
        };
    */

    [self beginDraggingSessionWithItems:@[ draggingItem ] event:_mouseDownEvent source:self];
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
    // _highlight = YES;
    // self.needsDisplay = YES;
}

- (void)mouseExited:(NSEvent *)event
{
    // _highlight = NO;
    // self.needsDisplay = YES;
}

// MARK: Actions

- (void)savePDF:(id)sender
{
    __block NSSavePanel *savePanel = [NSSavePanel savePanel];
    savePanel.allowedFileTypes = @[ @"pdf" ];

    [savePanel beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse result) {
        if (result != NSModalResponseOK)
            return;

        NSData *data = [self _convertViewToPDF];

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

// MARK: Cut, Copy and Pasting

- (void)cut:(id)sender
{
    [self copy:sender];
    self.string = @" ";
}

- (void)copy:(id)sender
{
    NSPasteboard *pasteboard = NSPasteboard.generalPasteboard;
    [self _writeToPasteboard:pasteboard];
}

- (void)paste:(id)sender
{
    NSPasteboard *pasteboard = NSPasteboard.generalPasteboard;
    if ([self _readFromPasteboard:pasteboard])
        NSBeep();
}

- (void)_writeToPasteboard:(NSPasteboard *)pasteboard
{
    // Copy data to the pasteboard
    [pasteboard clearContents];
    // [pasteboard writeObjects:@[ _string ]]; Regular copy and pasting

    NSPasteboardItem *pasteboardItem = [[NSPasteboardItem alloc] init];
    [pasteboardItem setString:_string.copy forType:NSPasteboardTypeString];

    NSData *pdf = [self _convertViewToPDF];
    [pasteboardItem setData:pdf forType:NSPasteboardTypePDF];

    [pasteboard writeObjects:@[ pasteboardItem ]];
}

- (NSData *)_convertViewToPDF
{
    NSRect rect = self.bounds;
    return [self dataWithPDFInsideRect:rect];
}

- (BOOL)_readFromPasteboard:(NSPasteboard *)pasteboard
{
    NSArray *classes = @[ NSString.class ];
    NSArray *objects = [pasteboard readObjectsForClasses:classes options:nil];

    if (!objects.count)
        return NO;

    NSString *value = objects.firstObject;
    self.string = [value tt_firstLetter];
    
    return YES;
}

// MARK: Drag and Drop

- (NSDragOperation)draggingSession:(NSDraggingSession *)session sourceOperationMaskForDraggingContext:(NSDraggingContext)context
{
    return NSDragOperationCopy | NSDragOperationDelete;
}

- (void)draggingSession:(NSDraggingSession *)session willBeginAtPoint:(NSPoint)screenPoint
{
}

- (void)draggingSession:(NSDraggingSession *)session endedAtPoint:(NSPoint)screenPoint operation:(NSDragOperation)operation
{
    if (NSDragOperationDelete == operation)
        self.string = @"";
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    NSLog(@"Dragging Entered");
    if (sender.draggingSource == self)
        return NSDragOperationNone;

    _highlight = YES;
    self.needsDisplay = YES;
    return NSDragOperationCopy;
}

- (void)draggingExited:(id<NSDraggingInfo>)sender
{
    NSLog(@"Dragging Exited");
    _highlight = NO;
    self.needsDisplay = YES;
}

- (BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender
{
    return YES;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
    NSPasteboard *pasteboard = sender.draggingPasteboard;
    if ([self _readFromPasteboard:pasteboard])
        return YES;

    NSLog(@"Could not read from dragging pasteboard");
    return NO;
}

- (void)concludeDragOperation:(id<NSDraggingInfo>)sender
{
    NSLog(@"Conclude drag operation");
    _highlight = NO;
    self.needsDisplay = YES;
}

- (NSDragOperation)draggingUpdated:(id<NSDraggingInfo>)sender
{
    NSDragOperation operation = sender.draggingSourceOperationMask;
    NSLog(@"Operation Mask: %ld", operation);

    if (sender.draggingSource == self)
        return NSDragOperationNone;

    return NSDragOperationCopy;
}

@end
