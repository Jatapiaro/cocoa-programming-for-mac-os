//
//  Oval.m
//  OvalDrawing
//
//  Created by Jacobo Tapia on 31/10/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import "Oval.h"

@implementation Oval {
    NSRect _originRect;
}

- (instancetype)initWithRect:(NSRect)rect color:(NSColor *)color filled:(BOOL)filled
{
    if (!(self = [super init]))
        return nil;

    _originRect = rect;
    _color = color;
    _filled = filled;
    [super appendBezierPathWithOvalInRect:rect];

    return self;
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

- (CGFloat)xOrigin
{
    return self.bounds.origin.x;
}

- (CGFloat)xFinal
{
    return self.xOrigin + NSWidth(self.bounds);
}

- (CGFloat)yOrigin
{
    return self.bounds.origin.y;
}

- (CGFloat)yFinal
{
    return self.yOrigin + NSHeight(self.bounds);
}

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

@end
