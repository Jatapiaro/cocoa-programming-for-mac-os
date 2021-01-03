//
//  DrawingToolsPanelController.h
//  OvalDrawing
//
//  Created by Jacobo Tapia on 31/10/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Oval.h"

NS_ASSUME_NONNULL_BEGIN

@interface DrawingToolsPanelController : NSWindowController

@property (nonatomic, weak, readonly) NSColor *backgroundColor;
@property (nonatomic, weak, readonly) NSColor *ovalColor;
@property (nonatomic, readonly) BOOL shouldFillOval;
@property (nonatomic, readonly) float radiusOfOval;
@property (nonatomic, readonly) BOOL isDrawing;

+ (DrawingToolsPanelController *)sharedDrawingToolsPanelController;
- (void)updateBackgroundColor:(NSColor *)backgroundColor ovalColor:(NSColor *)ovalColor shouldFillOval:(BOOL)shouldFillOval radiusOfOval:(float)radiusOfOval;

// MARK: Actions

- (IBAction)colorDidChange:(NSColorWell *)sender;
- (IBAction)drawingTypeDidChange:(NSSegmentedControl *)sender;
- (IBAction)mouseInteractionTypeDidChange:(NSSegmentedControl *)sender;
- (IBAction)radiusOfOvalDidChange:(NSSlider *)sender;

// MARK: Helper Methods

- (void)storeOvalSettingsAndLoadOvalPropertiesUsingOval:(Oval *)oval;
- (void)restoreGeneralOvalProperties;

@end

NS_ASSUME_NONNULL_END
