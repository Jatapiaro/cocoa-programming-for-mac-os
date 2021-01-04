//
//  DrawingCanvasEncoderObject.h
//  OvalDrawing
//
//  Created by Jacobo Tapia de la Rosa on 1/4/21.
//  Copyright © 2021 Jacobo Tapia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Oval.h"

NS_ASSUME_NONNULL_BEGIN

@interface DrawingCanvasEncoderObject : NSObject <NSSecureCoding>

- (id)initWithOvals:(NSArray<Oval *> *)ovals backgroundColor:(NSColor *)color;
@property (nonatomic, copy, readonly) NSArray<Oval *> *ovals;
@property (nonatomic, copy) NSColor *backgroundColor;

@end

NS_ASSUME_NONNULL_END
