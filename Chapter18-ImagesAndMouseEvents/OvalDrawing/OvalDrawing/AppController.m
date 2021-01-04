//
//  AppController.m
//  OvalDrawing
//
//  Created by Jacobo Tapia on 31/10/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import "AppController.h"
#import "DrawingToolsPanelController.h"

@implementation AppController

- (void)showDrawingToolsPanel:(id)sender
{
    [DrawingToolsPanelController.sharedDrawingToolsPanelController showWindow:nil];
}

@end
