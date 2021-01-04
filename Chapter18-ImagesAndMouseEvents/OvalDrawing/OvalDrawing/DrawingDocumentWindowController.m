//
//  DrawingDocumentWindowController.m
//  OvalDrawing
//
//  Created by Jacobo Tapia on 01/11/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import "DrawingDocumentWindowController.h"
#import "DrawingToolsPanelController.h"
#import "AppDefaults.h"

@interface DrawingDocumentWindowController ()
@end

@implementation DrawingDocumentWindowController {
    NSColor *_windowBackgroundColor;
    NSColor *_windowOvalColor;
    float _windowRadiusOfOval;
    BOOL _windowShouldFillOval;
    BOOL _windowIsDrawing;
    DrawingToolsPanelController *_drawingToolsPanelController;
}

- (void)windowDidLoad
{
    [super windowDidLoad];

    _windowBackgroundColor = NSColor.whiteColor;
    _windowOvalColor = NSColor.blackColor;
    _windowRadiusOfOval = 20;
    _windowShouldFillOval = NO;
    _windowIsDrawing = YES;

    [self _updateDrawingToolsPanel];
    if (!_drawingToolsPanelController.window.isVisible)
        [_drawingToolsPanelController showWindow:nil];

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_windowDidBecameKeyWindow) name:NSWindowDidBecomeKeyNotification object:self.window];

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_backgroundColorDidChange) name:OvalDrawingBackgroundColorDidChangeNotificationKey object:_drawingToolsPanelController];

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_ovalColorDidChange) name:OvalDrawingOvalColorDidChangeNotificationKey object:_drawingToolsPanelController];

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_ovalDrawingStyleDidChange) name:OvalDrawingOvalDrawingStyleDidChangeNotificationKey object:_drawingToolsPanelController];

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_mouseInteractionDidChange) name:OvalDrawingMouseInteractionDidChangeNotificationKey object:_drawingToolsPanelController];

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_radiusOfOvalDidChange) name:OvalDrawingOvalRadiusDidChangeNotificationKey object:_drawingToolsPanelController];
}

- (void)_windowDidBecameKeyWindow
{
    if (!(self.window == _drawingToolsPanelController.currentOwner))
        [self _updateDrawingToolsPanel];
}

- (void)_updateDrawingToolsPanel
{
    if (!_drawingToolsPanelController)
        _drawingToolsPanelController = DrawingToolsPanelController.sharedDrawingToolsPanelController;

    _drawingToolsPanelController.currentOwner = self.window;
    [_drawingToolsPanelController updateBackgroundColor:_windowBackgroundColor ovalColor:_windowOvalColor shouldFillOval:_windowShouldFillOval radiusOfOval:_windowRadiusOfOval isDrawing:_windowIsDrawing];
}

- (void)_backgroundColorDidChange
{
    if (self.window.isMainWindow)
        _windowBackgroundColor = _drawingToolsPanelController.backgroundColor;
}

- (void)_ovalColorDidChange
{
    if (self.window.isMainWindow)
        _windowOvalColor = _drawingToolsPanelController.ovalColor;
}

- (void)_ovalDrawingStyleDidChange
{
    if (self.window.isMainWindow)
        _windowShouldFillOval = _drawingToolsPanelController.shouldFillOval;
}

- (void)_mouseInteractionDidChange
{
    if (self.window.isMainWindow)
        _windowIsDrawing = _drawingToolsPanelController.isDrawing;
}

- (void)_radiusOfOvalDidChange
{
    if (self.window.isMainWindow)
        _windowRadiusOfOval = _drawingToolsPanelController.radiusOfOval;
}

@end
