//
//  DrawingToolsPanelController.m
//  OvalDrawing
//
//  Created by Jacobo Tapia on 31/10/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import "DrawingToolsPanelController.h"

@interface DrawingToolsPanelController ()

@property (nonatomic, weak) IBOutlet NSColorWell *backgroundColorWell;
@property (nonatomic, weak) IBOutlet NSColorWell *ovalColorWell;
@property (nonatomic, weak) IBOutlet NSPopUpButton *drawingStyle;
@property (nonatomic, weak) IBOutlet NSSlider *radiusOfOvalSlider;
@property (nonatomic, weak) IBOutlet NSPopUpButton *mouseInteractionType;

@end

@implementation DrawingToolsPanelController

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
        return;
    }

    if (sender != _backgroundColorWell)
        return;

    _backgroundColor = sender.color;
    [NSNotificationCenter.defaultCenter postNotificationName:@"BackgroundColorDidChange" object:self];
}

- (void)drawingTypeDidChange:(NSPopUpButton *)sender
{
    _shouldFillOval = sender.selectedTag;
}

- (void)mouseInteractionTypeDidChange:(NSPopUpButton *)sender
{
    _isDrawing = sender.selectedTag;
}

- (void)radiusOfOvalDidChange:(NSSlider *)sender
{
    _radiusOfOval = sender.floatValue;
}

@end
