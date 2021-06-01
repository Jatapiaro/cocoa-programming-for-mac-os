//
//  ScatteredController.m
//  Scattered
//
//  Created by Jacobo Tapia on 5/30/21.
//

#import "ScatteredController.h"
#import <QuartzCore/QuartzCore.h>

@interface ScatteredController ()
@property (nonatomic, weak) IBOutlet NSTextField *durationTextField;
- (IBAction)reposition:(NSButton *)sender;
@end

@implementation ScatteredController {
    CATextLayer *_textLayer;
    NSMutableSet<CALayer *> *_imageLayers;
    CGFloat _duration;
    
    NSOperationQueue *_imageQueue;
    NSOperationQueue *_ioQueue;
}

- (instancetype)init
{
    if (!(self = [super init]))
        return nil;
    
    _imageLayers = [NSMutableSet set];
    _duration = 1.5f;
    _ioQueue = [[NSOperationQueue alloc] init];
    _imageQueue = [[NSOperationQueue alloc] init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.bounds = NSMakeRect(0, 0, 500, 500);
    
    srandom((unsigned)time(NULL));
    self.view.layer = [CALayer layer];
    self.view.wantsLayer = YES;
    
    CALayer *textContainer = [CALayer layer];
    textContainer.anchorPoint = CGPointZero;
    textContainer.position = CGPointMake(10, 10);
    textContainer.zPosition = 100;
    
    textContainer.backgroundColor = CGColorGetConstantColor(kCGColorBlack);
    textContainer.borderColor = CGColorGetConstantColor(kCGColorWhite);
    textContainer.borderWidth = 2;
    textContainer.cornerRadius = 15;
    textContainer.shadowOpacity = 0.5f;
    [self.view.layer addSublayer:textContainer];
    
    _textLayer = [CATextLayer layer];
    _textLayer.anchorPoint = CGPointZero;
    _textLayer.position = CGPointMake(10, 6);
    _textLayer.zPosition = 100;
    _textLayer.fontSize = 24;
    _textLayer.foregroundColor = CGColorGetConstantColor(kCGColorWhite);
    [textContainer addSublayer:_textLayer];
    
    // Rely on setText to set the above layers bounds
    [self _setText:@"Loading..." inLayer:_textLayer];
    [self _selfAddImagesFromFolderURL:[NSURL fileURLWithPath:@"/Users/jacobo/Pictures/Radiohead-Lima"]];
}

- (void)_setText:(NSString *)text inLayer:(CATextLayer *)textLayer
{
    NSFont *font = [NSFont systemFontOfSize:textLayer.fontSize];
    NSDictionary *attributes = @{NSFontAttributeName : font};
    NSSize size = [text sizeWithAttributes:attributes];
    
    // Ensure the width is in whole numbers
    size.width = ceilf(size.width);
    size.height = ceil(size.height);
    textLayer.bounds = CGRectMake(0, 0, size.width + 10, size.height);
    textLayer.superlayer.bounds = CGRectMake(0, 0, size.width + 20, size.height + 25);
    
    textLayer.string = text;
}

- (void)_selfAddImagesFromFolderURL:(NSURL *)folderURL
{
    
    NSTimeInterval t0 = [NSDate timeIntervalSinceReferenceDate];
    __weak ScatteredController *weakSelf = self;
    [_ioQueue addOperationWithBlock:^{
        NSFileManager *fileManager = NSFileManager.defaultManager;
        NSDirectoryEnumerator *directoryEnumerator = [fileManager enumeratorAtURL:folderURL includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:nil];
        
        for (NSURL *url in directoryEnumerator) {
            // Skip directories
            NSNumber *isDirectory = nil;
            [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:nil];
            if (isDirectory.boolValue)
                continue;
            
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            if (!imageData)
                continue;
            
            ScatteredController *strongSelf = weakSelf;
            [strongSelf->_imageQueue addOperationWithBlock:^{
                NSImage *image = [[NSImage alloc] initWithData:imageData];
                NSImage *thumbImage = [self _thumbnailFromImage:image];
                
                [NSOperationQueue.mainQueue addOperationWithBlock:^{
                    [strongSelf _presentImage:thumbImage fromURL:url];
                    [strongSelf _setText:[NSString stringWithFormat:@"%0.1fs", [NSDate timeIntervalSinceReferenceDate] - t0] inLayer:strongSelf->_textLayer];
                }];
            }];
        }
    }];
}

- (void)_presentImage:(NSImage *)image fromURL:(NSURL *)url
{
    CGRect superlayerBounds = self.view.layer.bounds;
    NSPoint center = {CGRectGetMidX(superlayerBounds), CGRectGetMidY(superlayerBounds)};
    NSRect imageBounds = CGRectMake(0, 0, image.size.width, image.size.height);
    CGPoint randomPoint = {
        CGRectGetMaxX(superlayerBounds) * (double)random() / (double)RAND_MAX,
        CGRectGetMaxY(superlayerBounds) * (double)random() / (double)RAND_MAX
    };
    
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *positionAnimation = [CABasicAnimation animation];
    positionAnimation.fromValue = [NSValue valueWithPoint:center];
    positionAnimation.duration = _duration;
    positionAnimation.timingFunction = timingFunction;
    
    CABasicAnimation *bdsAnimation = [CABasicAnimation animation];
    bdsAnimation.fromValue = [NSValue valueWithRect:NSZeroRect];
    bdsAnimation.duration = _duration;
    bdsAnimation.timingFunction = timingFunction;
    
    CALayer *layer = [CALayer layer];
    [_imageLayers addObject:layer];
    layer.contents = image;
    layer.actions = @{
        @"position": positionAnimation,
        @"bounds": bdsAnimation,
    };
    
    CATextLayer *textLayer = [self _makeImageTextLayer];
    CAMediaTimingFunction *textTimingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation *textPositionAnimation = [CABasicAnimation animation];
    textPositionAnimation.fromValue = [NSValue valueWithPoint:NSZeroPoint];
    textPositionAnimation.duration = _duration;
    positionAnimation.timingFunction = textTimingFunction;
    
    CABasicAnimation *textBoundsAnimation = [CABasicAnimation animation];
    textBoundsAnimation.fromValue = [NSValue valueWithRect:NSZeroRect];
    textBoundsAnimation.duration = _duration;
    textBoundsAnimation.timingFunction = textTimingFunction;
    textLayer.actions = @{
        @"position": textPositionAnimation,
        @"bounds": textBoundsAnimation,
    };
    
    [CATransaction begin];
    [self.view.layer addSublayer:layer];
    layer.position = randomPoint;
    layer.bounds = NSRectToCGRect(imageBounds);
    [layer addSublayer:textLayer.superlayer];
    
    [CATransaction setCompletionBlock:^{
        [CATransaction begin];
            [self _setText:url.absoluteString.lastPathComponent.stringByDeletingPathExtension inLayer:textLayer];
            CGRect superlayerBounds = textLayer.superlayer.bounds;
            if (superlayerBounds.size.width > imageBounds.size.width)
                textLayer.superlayer.bounds = CGRectMake(10, 10, imageBounds.size.width - 10, superlayerBounds.size.height);
        [CATransaction commit];
    }];
    
    [CATransaction commit];
}

- (CATextLayer *)_makeImageTextLayer
{
    CALayer *textContainer = [CALayer layer];
    textContainer.anchorPoint = CGPointZero;
    textContainer.position = CGPointMake(10, 10);
    textContainer.zPosition = 100;
    
    textContainer.backgroundColor = CGColorGetConstantColor(kCGColorBlack);
    textContainer.borderColor = CGColorGetConstantColor(kCGColorWhite);
    textContainer.borderWidth = 2;
    textContainer.cornerRadius = 15;
    textContainer.shadowOpacity = 1;
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.anchorPoint = CGPointMake(0, 0);
    textLayer.position = CGPointMake(10, 10);
    textLayer.zPosition = 100;
    textLayer.fontSize = 10;
    textLayer.foregroundColor = CGColorGetConstantColor(kCGColorWhite);
    [textContainer addSublayer:textLayer];
    
    return textLayer;
}

- (NSImage *)_thumbnailFromImage:(NSImage *)image
{
    const CGFloat targetHeight = 200.0f;
    NSSize imageSize = image.size;
    NSSize smallerSize = {targetHeight * imageSize.width / imageSize.height, imageSize.height};
    
    NSImage *smallerImage = [[NSImage alloc] initWithSize:smallerSize];
    [smallerImage lockFocus];
    [image drawInRect:NSMakeRect(0, 0, smallerSize.width, smallerSize.height) fromRect:NSZeroRect operation:NSCompositingOperationCopy fraction:1.0];
    [smallerImage unlockFocus];
    
    return smallerImage;
}

- (void)reposition:(NSButton *)sender
{
    if (!_imageLayers || !_imageLayers.count)
        return;
    
    if (_durationTextField.stringValue.length > 0)
        _duration = _durationTextField.floatValue;
    
    CGRect superlayerBounds = self.view.layer.bounds;
    for (CALayer *layer in _imageLayers) {
        CGPoint randomPoint = {
            CGRectGetMaxX(superlayerBounds) * (double)random() / (double)RAND_MAX,
            CGRectGetMaxY(superlayerBounds) * (double)random() / (double)RAND_MAX
        };
        CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        CABasicAnimation *positionAnimation = [CABasicAnimation animation];
        positionAnimation.fromValue = [NSValue valueWithPoint:layer.position];
        positionAnimation.duration = _duration;
        positionAnimation.timingFunction = timingFunction;
        
        layer.actions = @{
            @"position": positionAnimation,
        };
        
        [CATransaction begin];
            layer.position = randomPoint;
        [CATransaction commit];
    }
}

@end
