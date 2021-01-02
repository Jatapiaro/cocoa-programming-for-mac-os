//
//  Oval.h
//  OvalDrawing
//
//  Created by Jacobo Tapia on 31/10/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface Oval : NSBezierPath

- (instancetype)initWithRect:(NSRect)rect color:(NSColor *)color filled:(BOOL)filled;

// MARK: Points of Rect as Floats
@property (nonatomic, readonly) CGFloat xOrigin;
@property (nonatomic, readonly) CGFloat yOrigin;
@property (nonatomic, readonly) CGFloat xFinal;
@property (nonatomic, readonly) CGFloat yFinal;

// MARK: Points of Rect as Points
@property (nonatomic, readonly) CGPoint bottomLeadingCorner;
@property (nonatomic, readonly) CGPoint bottomTrailingCorner;
@property (nonatomic, readonly) CGPoint topLeadingCorner;
@property (nonatomic, readonly) CGPoint topTrailingCorner;

@property (nonatomic, readonly, weak) NSColor *color;
@property (nonatomic, readonly) NSBezierPath *selectionPath;
@property (nonatomic, readonly) BOOL filled;

- (BOOL)isInRect:(NSRect)rect;
- (void)addSelectionPath;
- (void)removeSelectionPath;
- (void)updateOvalSizeUsingPoint:(NSPoint)point;
- (void)checkResizingAvailability:(NSPoint)point;

@end

NS_ASSUME_NONNULL_END
