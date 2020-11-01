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
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (!(self = [super initWithCoder:coder]))
        return nil;

    _ovals = [NSMutableArray array];
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];

    DrawingToolsPanelController *drawingToolsPanelController = DrawingToolsPanelController.sharedDrawingToolsPanelController;

    [drawingToolsPanelController.backgroundColor set];
    [NSBezierPath fillRect:self.bounds];

    [drawingToolsPanelController.ovalColor set];
    for (Oval *oval in _ovals) {
        if ([oval isInRect:dirtyRect]) {
            [oval fill];
        }
    }
}

// MARK: Mouse Drawing

- (void)mouseDown:(NSEvent *)event
{
    NSPoint mousePosition = event.locationInWindow;
    [self _createOvalWithCenter:mousePosition];
}

- (void)_createOvalWithCenter:(NSPoint)center
{
    NSPoint mousePosition = [_scrollView convertPoint:center toView:nil];
    mousePosition = [_scrollView convertPoint:mousePosition toView:self];

    NSRect rect = NSMakeRect(mousePosition.x - 5.0, mousePosition.y - 5.0, 10.0, 10.0);
    Oval *oval = [[Oval alloc] initWithRect:rect];
    [_ovals addObject:oval];

    self.needsDisplay = YES;
}

@end
