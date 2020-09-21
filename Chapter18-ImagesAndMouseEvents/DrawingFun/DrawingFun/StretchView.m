//
//  StretchView.m
//  DrawingFun
//
//  Created by Jacobo Tapia on 9/20/20.
//

#import "StretchView.h"

@implementation StretchView {
    NSBezierPath *_path;
    NSPoint _initialPoint;
    NSPoint _finalPoint;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
        srandom((unsigned)time(NULL));
        [self _initPathShouldUseCurves:YES];
        _opacity = 1;
    }

    return self;
}

- (void)_initPathShouldUseCurves:(BOOL)curves
{
    _path = [NSBezierPath bezierPath];
    _path.lineWidth = 3.0;
    [_path moveToPoint:[self _randomPoint]];

    if (curves)
        [self _drawCurves];
    else
        [self _drawLines];

    [_path closePath];
}

- (void)_drawLines
{
    for (NSInteger i = 0; i < 15; i++)
    [_path lineToPoint:[self _randomPoint]];
}

- (void)_drawCurves
{
    for (NSInteger i = 0; i < 15; i++) {
        NSPoint endPoint = [self _randomPoint];
        NSPoint controlPointOne = [self _randomPoint];
        NSPoint controlPointTwo = [self _randomPoint];
        [_path curveToPoint:endPoint controlPoint1:controlPointOne controlPoint2:controlPointTwo];
    }
}

- (NSPoint)_randomPoint
{
    NSPoint result;
    NSRect rect = self.bounds;

    result.x = rect.origin.x + random() % (int)rect.size.width * 2;
    result.y = rect.origin.y + random() % (int)rect.size.height * 2;

    return result;
}

- (void)awakeFromNib
{
    NSSize windowSize = self.window.frame.size;
    [self setFrameSize:NSMakeSize(windowSize.width * 2, windowSize.height * 2)];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [NSColor.greenColor set];
    [NSBezierPath fillRect:self.bounds];

    [NSColor.whiteColor set];
    [_path stroke]; // We can use fill here

    [self _drawImageIfPossible];
}

- (void)_drawImageIfPossible
{
    if (!_image)
        return;

    NSRect imageRect;
    imageRect.origin = NSZeroPoint;
    imageRect.size = _image.size;

    NSRect drawingRect = [self _calculateDrawingRect];
    if (NSIsEmptyRect(drawingRect))
        drawingRect.size = imageRect.size;

    [_image drawInRect:drawingRect fromRect:imageRect operation:NSCompositingOperationSourceOver fraction:_opacity];
}

- (NSRect)_calculateDrawingRect
{
    float minX = MIN(_initialPoint.x, _finalPoint.x);
    float maxX = MAX(_initialPoint.x, _finalPoint.x);

    float minY = MIN(_initialPoint.y, _finalPoint.y);
    float maxY = MAX(_initialPoint.y, _finalPoint.y);

    return NSMakeRect(minX, minY, maxX-minX, maxY-minY);
}

// MARK: Mouse Events

- (void)mouseDown:(NSEvent *)event
{
    [self _calculateInitialPointsUsingPoint:[self convertPoint:event.locationInWindow fromView:nil]];
    self.needsDisplay = YES;
}

- (void)mouseDragged:(NSEvent *)event
{
    _finalPoint = [self convertPoint:event.locationInWindow fromView:nil];
    [self autoscroll:event];
    self.needsDisplay = YES;
}

- (void)mouseUp:(NSEvent *)event
{
    _finalPoint = [self convertPoint:event.locationInWindow fromView:nil];
    self.needsDisplay = YES;
}

// MARK: Custom setter

- (void)setImage:(NSImage *)image
{
    _image = image;
    [self _calculateInitialPointsUsingPoint:NSZeroPoint];
    self.needsDisplay = YES;
}

- (void)_calculateInitialPointsUsingPoint:(NSPoint)initial;
{
    _initialPoint = initial;

    _finalPoint.x = _initialPoint.x + _image.size.width;
    _finalPoint.y = _initialPoint.y + _image.size.height;
}

- (void)setOpacity:(float)opacity
{
    _opacity = opacity;
    self.needsDisplay = YES;
}

@end
