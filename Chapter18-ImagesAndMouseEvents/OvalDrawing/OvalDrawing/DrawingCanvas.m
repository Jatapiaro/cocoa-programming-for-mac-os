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
#import "AppDefaults.h"
#import "Document.h"

@interface DrawingCanvas ()
@property (nonatomic, weak) IBOutlet NSScrollView *scrollView;
@end

@implementation DrawingCanvas {
    NSMutableArray<Oval *> *_ovals;
    DrawingToolsPanelController *_drawingToolsPanelController;
    Oval *_selectedOval;
    NSRect _selectedOvalOriginRect;
    NSUndoManager *_undoManager;
    BOOL _isCreatingOval;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (!(self = [super initWithCoder:coder]))
        return nil;

    _ovals = [NSMutableArray array];
    _drawingToolsPanelController = DrawingToolsPanelController.sharedDrawingToolsPanelController;

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_backgroundColorDidChange) name:OvalDrawingBackgroundColorDidChangeNotificationKey object:_drawingToolsPanelController];

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_ovalColorDidChange) name:OvalDrawingOvalColorDidChangeNotificationKey object:_drawingToolsPanelController];

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_ovalDrawingStyleDidChange) name:OvalDrawingOvalDrawingStyleDidChangeNotificationKey object:_drawingToolsPanelController];

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_mouseInteractionDidChange) name:OvalDrawingMouseInteractionDidChangeNotificationKey object:_drawingToolsPanelController];
    
    NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingMouseMoved | NSTrackingActiveInKeyWindow
| NSTrackingActiveInActiveApp | NSTrackingInVisibleRect owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
    
    return self;
}

- (void)awakeFromNib
{
    Document *document = self.window.windowController.document;
    _undoManager = document.undoManager;
}

- (void)_backgroundColorDidChange
{
    if (self.window.isMainWindow)
        self.needsDisplay = YES;
}

- (void)_ovalColorDidChange
{
    if (!_selectedOval)
        return;

    [self _changeColorOfOval:_selectedOval withNewColor:[_drawingToolsPanelController.ovalColor copy]];
}

- (void)_changeColorOfOval:(Oval *)oval withNewColor:(NSColor *)color
{
    [self _prepareUndoManager];
    [[_undoManager prepareWithInvocationTarget:self] _changeColorOfOval:oval withNewColor:[oval.color copy]];
    [self _addUndoManagerActionName:@"Change Color Of Oval"];

    oval.color = color;
    self.needsDisplay = YES;
}

- (void)_ovalDrawingStyleDidChange
{
    if (!_selectedOval)
        return;

    _selectedOval.filled = _drawingToolsPanelController.shouldFillOval;
    self.needsDisplay = YES;
}

- (void)_mouseInteractionDidChange
{
    if (!_selectedOval)
        return;

    [self _unselectSelectedOval];
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
        if (NSIsEmptyRect(_selectedOvalOriginRect))
            _selectedOvalOriginRect = _selectedOval.originRect;

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

- (void)mouseUp:(NSEvent *)event
{
    if (NSIsEmptyRect(_selectedOvalOriginRect))
        return;

    if (_selectedOval.isTraslating)
        [NSCursor.openHandCursor set];

    [self _prepareUndoManager];
    [[_undoManager prepareWithInvocationTarget:self] _translateOval:_selectedOval usingRect:_selectedOvalOriginRect];
    [self _addUndoManagerActionName:@"Change Position Of Oval"];

    _selectedOvalOriginRect = NSZeroRect;
}

- (void)_translateOval:(Oval *)oval usingRect:(NSRect)rect
{
    [self _prepareUndoManager];
    [[_undoManager prepareWithInvocationTarget:self] _translateOval:oval usingRect:oval.originRect];
    [self _addUndoManagerActionName:@"Change Position Of Oval"];

    oval.originRect = rect;
    self.needsDisplay = YES;
}

// MARK: Oval Drawing

- (void)_createOvalWithCenter:(NSPoint)center
{
    if (_isCreatingOval)
        return;

    _isCreatingOval = YES;
    NSPoint mousePosition = [self _convertMousePositionUsingPoint:center];

    CGFloat radius = _drawingToolsPanelController.radiusOfOval;
    CGFloat diameter = radius * 2;
    NSRect rect = NSMakeRect(mousePosition.x - radius, mousePosition.y - radius, diameter, diameter);

    NSColor *colorOfOval = _drawingToolsPanelController.ovalColor;
    BOOL shouldFillOval = _drawingToolsPanelController.shouldFillOval;

    Oval *oval = [[Oval alloc] initWithCenter:center rect:rect color:colorOfOval filled:shouldFillOval];
    [_ovals addObject:oval];

    self.needsDisplay = YES;
    _isCreatingOval = NO;

    [self _prepareUndoManager];
    [[_undoManager prepareWithInvocationTarget:self] _removeOval:oval];
    [self _addUndoManagerActionName:@"Remove Oval"];
}

- (void)_removeOval:(Oval *)oval
{
    [self _prepareUndoManager];
    [[_undoManager prepareWithInvocationTarget:self] _createOvalWithCenter:oval.center];
    [self _addUndoManagerActionName:@"Re-add Oval"];

    [_ovals removeObject:oval];
    self.needsDisplay = YES;
}

- (void)_selectOvalUsingPoint:(NSPoint)point
{
    NSPoint mousePosition = [self _convertMousePositionUsingPoint:point];

    for (Oval *oval in _ovals) {
        if ([oval containsPoint:mousePosition]) {
            [self _setSelectedOval:oval];
            [_drawingToolsPanelController storeOvalSettingsAndLoadOvalPropertiesUsingOval:oval];
            self.needsDisplay = YES;
            return;
        }
    }

    if (_selectedOval && !_selectedOval.isRezising)
        [self _unselectSelectedOval];
}

- (void)_unselectSelectedOval
{
    [_selectedOval removeSelectionPath];
    _selectedOval = nil;
    [_drawingToolsPanelController restoreGeneralOvalProperties];
    self.needsDisplay = YES;
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

// MARK: UndoManager commons

- (void)_prepareUndoManager
{
    if (_undoManager.groupingLevel > 0) {
        [_undoManager endUndoGrouping];
        [_undoManager beginUndoGrouping];
    }
}

- (void)_addUndoManagerActionName:(NSString *)actionName
{
    if (!_undoManager.isUndoing || !_undoManager.isRedoing)
        [_undoManager setActionName:actionName];
}

@end
