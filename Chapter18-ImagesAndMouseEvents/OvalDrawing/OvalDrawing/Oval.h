//
//  Oval.h
//  OvalDrawing
//
//  Created by Jacobo Tapia on 31/10/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface Oval : NSBezierPath

- (instancetype)initWithRect:(NSRect)rect;

@property (nonatomic, readonly) CGFloat xOrigin;
@property (nonatomic, readonly) CGFloat yOrigin;
@property (nonatomic, readonly) CGFloat xFinal;
@property (nonatomic, readonly) CGFloat yFinal;

@property (nonatomic, readonly) CGPoint bottomLeadingCorner;
@property (nonatomic, readonly) CGPoint bottomTrailingCorner;
@property (nonatomic, readonly) CGPoint topLeadingCorner;
@property (nonatomic, readonly) CGPoint topTrailingCorner;

- (BOOL)isInRect:(NSRect)rect;

@end

NS_ASSUME_NONNULL_END
