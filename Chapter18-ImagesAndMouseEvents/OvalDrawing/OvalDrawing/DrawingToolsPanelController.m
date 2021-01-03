//
//  DrawingToolsPanelController.m
//  OvalDrawing
//
//  Created by Jacobo Tapia on 31/10/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import "DrawingToolsPanelController.h"

#import "AppDefaults.h"

@interface DrawingToolsPanelController ()

@property (nonatomic, weak) IBOutlet NSColorWell *backgroundColorWell;
@property (nonatomic, weak) IBOutlet NSColorWell *ovalColorWell;
@property (nonatomic, weak) IBOutlet NSSegmentedControl *drawingStyle;
@property (nonatomic, weak) IBOutlet NSSlider *radiusOfOvalSlider;
@property (nonatomic, weak) IBOutlet NSSegmentedControl *mouseInteractionType;

@end

@implementation DrawingToolsPanelController {
    NSColor *_currentOvalColor;
    BOOL _currentOvalDrawingStyle;
    float _currentOvalRadius;
}

+ (DrawingToolsPanelController *)sharedDrawingToolsPanelController
{
    static DrawingToolsPanelController *sharedDrawingToolsPanelController;
    if (!sharedDrawingToolsPanelController)
        sharedDrawingToolsPanelController = [[super alloc] initWithWindowNibName:@"DrawingToolsPanel"];

    return sharedDrawingToolsPanelController;
}

- (void)updateBackgroundColor:(NSColor *)backgroundColor ovalColor:(NSColor *)ovalColor shouldFillOval:(BOOL)shouldFillOval radiusOfOval:(float)radiusOfOval
{
    _backgroundColor = backgroundColor;
    _ovalColor = ovalColor;
    _shouldFillOval = shouldFillOval;
    _radiusOfOval = radiusOfOval;
    _isDrawing = YES;

    dispatch_async(dispatch_get_main_queue(), ^{
        self->_backgroundColorWell.color = backgroundColor;
        self->_ovalColorWell.color = ovalColor;
        self->_radiusOfOvalSlider.floatValue = radiusOfOval;
    });
}

// MARK: Actions

- (IBAction)colorDidChange:(NSColorWell *)sender
{
    if (sender == _ovalColorWell) {
        _ovalColor = sender.color;
        [NSNotificationCenter.defaultCenter postNotificationName:OvalDrawingOvalColorDidChangeNotificationKey object:self];
        return;
    }

    if (sender != _backgroundColorWell)
        return;

    _backgroundColor = sender.color;
    [NSNotificationCenter.defaultCenter postNotificationName:OvalDrawingBackgroundColorDidChangeNotificationKey object:self];
}

- (void)drawingTypeDidChange:(NSPopUpButton *)sender
{
    _shouldFillOval = sender.selectedTag;
    [NSNotificationCenter.defaultCenter postNotificationName:OvalDrawingOvalDrawingStyleDidChangeNotificationKey object:self];
}

- (void)mouseInteractionTypeDidChange:(NSPopUpButton *)sender
{
    _isDrawing = sender.selectedTag;
    [NSNotificationCenter.defaultCenter postNotificationName:OvalDrawingMouseInteractionDidChangeNotificationKey object:self];
}

- (void)radiusOfOvalDidChange:(NSSlider *)sender
{
    _radiusOfOval = sender.floatValue;
    [NSNotificationCenter.defaultCenter postNotificationName:OvalDrawingOvalRadiusDidChangeNotificationKey object:self];
}

- (void)storeOvalSettingsAndLoadOvalPropertiesUsingOval:(Oval *)oval
{
    // Stores current settings
    if (!_currentOvalColor) {
        _currentOvalColor = _ovalColor;
        _currentOvalDrawingStyle = _shouldFillOval;
    }

    // Load oval properties
    _ovalColorWell.color = oval.color;
    [_drawingStyle selectSegmentWithTag:oval.filled];
}

- (void)restoreGeneralOvalProperties
{
    if (_currentOvalColor) {
        _ovalColorWell.color = _currentOvalColor;
        _currentOvalColor = nil;

        [_drawingStyle selectSegmentWithTag:_currentOvalDrawingStyle];
    }
}

@end
