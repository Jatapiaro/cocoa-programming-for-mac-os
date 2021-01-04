//
//  DrawingCanvas.h
//  OvalDrawing
//
//  Created by Jacobo Tapia on 24/10/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DrawingCanvasEncoderObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface DrawingCanvas : NSView

@property (nonatomic, readonly) DrawingCanvasEncoderObject *encoderHelperObject;
- (void)loadDataFromEncoder:(DrawingCanvasEncoderObject *)encoderObject;

@end

NS_ASSUME_NONNULL_END
