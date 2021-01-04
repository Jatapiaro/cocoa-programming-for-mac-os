//
//  StretchView.h
//  DrawingFun
//
//  Created by Jacobo Tapia on 9/20/20.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface StretchView : NSView

@property (nonatomic, strong) NSImage *image;
@property (nonatomic) float opacity;

@end

NS_ASSUME_NONNULL_END
