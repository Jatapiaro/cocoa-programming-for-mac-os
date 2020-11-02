//
//  DrawingToolsPanelController.h
//  OvalDrawing
//
//  Created by Jacobo Tapia on 31/10/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface DrawingToolsPanelController : NSWindowController

@property (nonatomic, weak, readonly) NSColor *backgroundColor;
@property (nonatomic, weak, readonly) NSColor *ovalColor;
@property (nonatomic, readonly) BOOL shouldFillOval;
@property (nonatomic, readonly) float radiusOfOval;

+ (DrawingToolsPanelController *)sharedDrawingToolsPanelController;
- (void)updateBackgroundColor:(NSColor *)backgroundColor ovalColor:(NSColor *)ovalColor shouldFillOval:(BOOL)shouldFillOval radiusOfOval:(float)radiusOfOval;

// MARK: Actions

- (IBAction)colorDidChange:(NSColorWell *)sender;
- (IBAction)drawingTypeDidChange:(NSPopUpButton *)sender;
- (IBAction)radiusOfOvalDidChange:(NSSlider *)sender;

@end

NS_ASSUME_NONNULL_END
