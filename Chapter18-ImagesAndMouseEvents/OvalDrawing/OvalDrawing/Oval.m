//
//  Oval.m
//  OvalDrawing
//
//  Created by Jacobo Tapia on 31/10/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import "Oval.h"

@interface Oval ()
@property (nonatomic) NSRect topResizeReferenceRect;
@property (nonatomic) NSRect bottomResizeReferenceRect;
@property (nonatomic) NSRect leadingResizeReferenceRect;
@property (nonatomic) NSRect trailingResizeReferenceRect;
@end

@implementation Oval {
    NSRect _originRect;
}

- (instancetype)initWithRect:(NSRect)rect color:(NSColor *)color filled:(BOOL)filled
{
    if (!(self = [super init]))
        return nil;

    _originRect = rect;
    [self _calculateResizingReferenceRects];
    _color = color;
    _filled = filled;
    [super appendBezierPathWithOvalInRect:rect];

    return self;
}

// MARK: Points of Rect as Floats

- (CGFloat)xOrigin
{
    return _originRect.origin.x;
}

- (CGFloat)xFinal
{
    return self.xOrigin + NSWidth(_originRect);
}

- (CGFloat)yOrigin
{
    return _originRect.origin.y;
}

- (CGFloat)yFinal
{
    return self.yOrigin + NSHeight(_originRect);
}

- (CGFloat)_width
{
    return self.xFinal - self.xOrigin;
}

- (CGFloat)_height
{
    return self.yFinal - self.yOrigin;
}

// MARK: Points of Rect as Points

- (CGPoint)bottomLeadingCorner
{
    return self.bounds.origin;
}

- (CGPoint)bottomTrailingCorner
{
    return NSMakePoint(self.xFinal, self.yOrigin);
}

- (CGPoint)topLeadingCorner
{
    return NSMakePoint(self.xOrigin, self.yFinal);
}

- (CGPoint)topTrailingCorner
{
    return NSMakePoint(self.xFinal, self.yFinal);
}

- (BOOL)isInRect:(NSRect)rect
{
    if (NSPointInRect(self.bottomLeadingCorner, rect))
        return YES;

    if (NSPointInRect(self.topLeadingCorner, rect))
        return YES;

    if (NSPointInRect(self.bottomTrailingCorner, rect))
        return YES;

    if (NSPointInRect(self.topTrailingCorner, rect))
        return YES;

    return NO;
}

- (void)addSelectionPath
{
    _selectionPath = [NSBezierPath bezierPathWithRect:_originRect];
}

- (void)removeSelectionPath
{
    _selectionPath = nil;
}

- (void)updateOvalSizeUsingPoint:(NSPoint)point
{
    NSRect newOriginRect = _originRect;
    
    if (point.y > self.yFinal) {
        CGFloat height = point.y - self.yOrigin;
        newOriginRect = NSMakeRect(self.xOrigin, self.yOrigin, self._width, height);
    }
    
    if (point.y < self.yOrigin) {
        CGFloat height = self.yFinal - point.y;
        newOriginRect = NSMakeRect(self.xOrigin, point.y, self._width, height);
    }
    
    if (point.x > self.xFinal) {
        CGFloat width = point.x - self.xOrigin;
        newOriginRect = NSMakeRect(self.xOrigin, self.yOrigin, width, self._height);
    }
    
    if (point.x < self.xOrigin) {
        CGFloat width = self.xFinal - point.x;
        newOriginRect = NSMakeRect(point.x, self.yOrigin, width, self._height);
    }
    
    [self removeAllPoints];
    [self _updateOvalSizeWithRect:newOriginRect];
    [self appendBezierPathWithOvalInRect:_originRect];
}

- (void)_updateOvalSizeWithRect:(NSRect)newRect
{
    _originRect = newRect;
    [self _calculateResizingReferenceRects];
    
    if (_selectionPath)
        _selectionPath = [NSBezierPath bezierPathWithRect:_originRect];
}

- (void)_calculateResizingReferenceRects
{
    // Bottom reference rect
    _bottomResizeReferenceRect = NSMakeRect(self.xOrigin, self.yOrigin - 5, self._width, 10);
    
    // Top reference rect
    _topResizeReferenceRect = NSMakeRect(self.xOrigin, self.yFinal - 5, self._width, 10);
    
    CGFloat height = self._height - 10;
    // Leading reference rect
    _leadingResizeReferenceRect = NSMakeRect(self.xOrigin - 5, self.yOrigin + 5, 10, height);
    
    // Trailing reference rect
    _trailingResizeReferenceRect = NSMakeRect(self.xFinal - 5, self.yOrigin + 5, 10, height);
}

- (void)checkResizingAvailability:(NSPoint)point
{
    if (!_selectionPath)
        return;
    
    if (NSPointInRect(point, _topResizeReferenceRect)) {
        [NSCursor.resizeUpDownCursor set];
        return;
    }
    
    if (NSPointInRect(point, _bottomResizeReferenceRect)) {
        [NSCursor.resizeDownCursor set];
        return;
    }
    
    if (NSPointInRect(point, _leadingResizeReferenceRect)) {
        [NSCursor.resizeLeftCursor set];
        return;
    }
    
    if (NSPointInRect(point, _trailingResizeReferenceRect)) {
        [NSCursor.resizeRightCursor set];
        return;
    }
    
    [NSCursor.arrowCursor set];
}

@end
