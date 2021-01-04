//
//  Oval.h
//  OvalDrawing
//
//  Created by Jacobo Tapia on 31/10/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, OvalTransformType) {
    OvalTraslationNone,
    OvalResizingTop,
    OvalResizingTrailing,
    OvalResizingBottom,
    OvalResizingLeading,
    OvalTraslation,
};

@interface Oval : NSBezierPath <NSSecureCoding>

- (instancetype)initWithCenter:(NSPoint)center rect:(NSRect)rect color:(NSColor *)color filled:(BOOL)filled;

@property (nonatomic) NSRect originRect;

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
@property (nonatomic, readonly) NSPoint center;

@property (nonatomic) NSColor *color;
@property (nonatomic, readonly) NSBezierPath *selectionPath;
@property (nonatomic) BOOL filled;
@property (nonatomic, readonly, getter=isTraslating) BOOL traslating;
@property (nonatomic, readonly, getter=isRezising) BOOL resizing;

- (BOOL)isInRect:(NSRect)rect;
- (void)addSelectionPath;
- (void)removeSelectionPath;
- (void)updateOvalSizeUsingPoint:(NSPoint)point;
- (void)checkResizingAvailability:(NSPoint)point;

@end

NS_ASSUME_NONNULL_END
