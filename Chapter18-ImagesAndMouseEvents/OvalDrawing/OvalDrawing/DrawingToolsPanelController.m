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
@property (nonatomic, weak) IBOutlet NSButton *drawingStyle;
@property (nonatomic, weak) IBOutlet NSSlider *radiusOfOvalSlider;

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

    dispatch_async(dispatch_get_main_queue(), ^{
        self->_backgroundColorWell.color = backgroundColor;
        self->_ovalColorWell.color = ovalColor;
        self->_radiusOfOvalSlider.floatValue = radiusOfOval;
    });
}

@end
