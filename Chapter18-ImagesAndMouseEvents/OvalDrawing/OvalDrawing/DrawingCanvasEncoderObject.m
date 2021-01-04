//
//  DrawingCanvasEncoderObject.m
//  OvalDrawing
//
//  Created by Jacobo Tapia de la Rosa on 1/4/21.
//  Copyright © 2021 Jacobo Tapia. All rights reserved.
//

#import "DrawingCanvasEncoderObject.h"

@implementation DrawingCanvasEncoderObject

- (id)initWithOvals:(NSArray<Oval *> *)ovals backgroundColor:(NSColor *)color
{
    if (!(self = [super init]))
        return nil;

    _ovals = ovals;
    _backgroundColor = color;
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    NSArray<Oval *> *ovals = [coder decodeObjectForKey:@"ovals"];
    NSColor *color = [coder decodeObjectForKey:@"backgroundColor"];
    return [self initWithOvals:ovals backgroundColor:color];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_ovals forKey:@"ovals"];
    [coder encodeObject:_backgroundColor forKey:@"backgroundColor"];
}

+ (BOOL)supportsSecureCoding
{
    return YES;
}

@end
