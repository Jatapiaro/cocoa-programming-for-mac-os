//
//  DrawingCanvas.m
//  OvalDrawing
//
//  Created by Jacobo Tapia on 24/10/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import "DrawingCanvas.h"
#import "Oval.h"
#import "DrawingToolsPanelController.h"

@interface DrawingCanvas ()
@property (nonatomic, weak) IBOutlet NSScrollView *scrollView;
@end

@implementation DrawingCanvas {
    NSMutableArray<Oval *> *_ovals;
    DrawingToolsPanelController *_drawingToolsPanelController;
    Oval *_selectedOval;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (!(self = [super initWithCoder:coder]))
        return nil;

    _ovals = [NSMutableArray array];
    _drawingToolsPanelController = DrawingToolsPanelController.sharedDrawingToolsPanelController;
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_backgroundColorDidChange) name:@"BackgroundColorDidChange" object:_drawingToolsPanelController];
    
    NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingMouseMoved | NSTrackingActiveInKeyWindow
| NSTrackingActiveInActiveApp | NSTrackingInVisibleRect owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
    
    return self;
}

- (void)_backgroundColorDidChange
{
    if (self.window.isMainWindow)
        self.needsDisplay = YES;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];

    [_drawingToolsPanelController.backgroundColor set];
    [NSBezierPath fillRect:self.bounds];

    for (Oval *oval in _ovals) {
        if ([oval isInRect:dirtyRect]) {
            [oval.color set];
            
            if (oval.filled)
                [oval fill];
            else
                [oval stroke];

            if (oval == _selectedOval) {
                [NSColor.blackColor set];
                [oval.selectionPath stroke];
            }
        }
    }
}

// MARK: Mouse Drawing

- (void)mouseDown:(NSEvent *)event
{
    NSPoint mousePosition = event.locationInWindow;
    if (_drawingToolsPanelController.isDrawing)
        [self _createOvalWithCenter:mousePosition];
    else
        [self _selectOvalUsingPoint:mousePosition];
}

- (void)mouseDragged:(NSEvent *)event
{
    NSPoint finalPoint = [self _convertMousePositionUsingPoint:event.locationInWindow];
    
    if (_selectedOval) {
        [_selectedOval updateOvalSizeUsingPoint:finalPoint];
        self.needsDisplay = YES;
        return;
    }
}

- (void)mouseMoved:(NSEvent *)event
{
    if (!_selectedOval) {
        [NSCursor.arrowCursor set];
        return;
    }
    
    NSPoint mousePosition = [self _convertMousePositionUsingPoint:event.locationInWindow];
    [_selectedOval checkResizingAvailability:mousePosition];
}

// MARK: Oval Drawing

- (void)_createOvalWithCenter:(NSPoint)center
{
    NSPoint mousePosition = [self _convertMousePositionUsingPoint:center];

    CGFloat radius = _drawingToolsPanelController.radiusOfOval;
    CGFloat diameter = radius * 2;
    NSRect rect = NSMakeRect(mousePosition.x - radius, mousePosition.y - radius, diameter, diameter);

    NSColor *colorOfOval = _drawingToolsPanelController.ovalColor;
    BOOL shouldFillOval = _drawingToolsPanelController.shouldFillOval;

    Oval *oval = [[Oval alloc] initWithRect:rect color:colorOfOval filled:shouldFillOval];
    [_ovals addObject:oval];

    self.needsDisplay = YES;
}

- (void)_selectOvalUsingPoint:(NSPoint)point
{
    NSPoint mousePosition = [self _convertMousePositionUsingPoint:point];

    for (Oval *oval in _ovals) {
        if ([oval containsPoint:mousePosition]) {
            [self _setSelectedOval:oval];
            self.needsDisplay = YES;
            return;
        }
    }
}

- (void)_setSelectedOval:(Oval *)oval
{
    if (_selectedOval)
        [_selectedOval removeSelectionPath];
    
    _selectedOval = oval;
    [_selectedOval addSelectionPath];
}

- (NSPoint)_convertMousePositionUsingPoint:(NSPoint)point
{
    NSPoint mousePosition = [_scrollView convertPoint:point toView:nil];
    mousePosition = [_scrollView convertPoint:mousePosition toView:self];
    
    return mousePosition;
}

@end
