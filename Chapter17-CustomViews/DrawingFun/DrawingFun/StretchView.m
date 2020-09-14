//
//  StretchView.m
//  DrawingFun
//
//  Created by Jacobo Tapia on 9/14/20.
//

#import "StretchView.h"

@implementation StretchView {
    NSBezierPath *_path;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
        srandom((unsigned)time(NULL));
        [self _initPathShouldUseCurves:YES];
    }

    return self;
}

- (void)_initPathShouldUseCurves:(BOOL)curves
{
    _path = [NSBezierPath bezierPath];
    _path.lineWidth = 3.0;
    [_path moveToPoint:[self randomPoint]];

    if (curves)
        [self _drawCurves];
    else
        [self _drawLines];

    [_path closePath];
}

- (void)_drawLines
{
    for (NSInteger i = 0; i < 15; i++)
        [_path lineToPoint:[self randomPoint]];
}

- (void)_drawCurves
{
    for (NSInteger i = 0; i < 15; i++) {
        NSPoint endPoint = [self randomPoint];
        NSPoint controlPointOne = [self randomPoint];
        NSPoint controlPointTwo = [self randomPoint];
        [_path curveToPoint:endPoint controlPoint1:controlPointOne controlPoint2:controlPointTwo];
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
    [NSColor.greenColor set];
    [NSBezierPath fillRect:self.bounds];

    [NSColor.whiteColor set];
    [_path stroke]; // We can use fill here
}

- (NSPoint)randomPoint
{
    NSPoint result;
    NSRect rect = self.bounds;

    result.x = rect.origin.x + random() % (int)rect.size.width;
    result.y = rect.origin.y + random() % (int)rect.size.height;

    return result;
}

@end
