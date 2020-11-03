//
//  DrawingDocumentWindowController.m
//  OvalDrawing
//
//  Created by Jacobo Tapia on 01/11/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import "DrawingDocumentWindowController.h"
#import "DrawingToolsPanelController.h"

@interface DrawingDocumentWindowController ()

@end

@implementation DrawingDocumentWindowController

- (void)windowDidLoad
{
    [super windowDidLoad];

    DrawingToolsPanelController *drawingToolsPanelController = DrawingToolsPanelController.sharedDrawingToolsPanelController;
    [drawingToolsPanelController updateBackgroundColor:NSColor.whiteColor ovalColor:NSColor.blackColor shouldFillOval:NO radiusOfOval:10];

    if (!drawingToolsPanelController.window.isVisible)
        [drawingToolsPanelController showWindow:nil];
}

@end
