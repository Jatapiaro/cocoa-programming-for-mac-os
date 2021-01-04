//
//  Document.h
//  OvalDrawing
//
//  Created by Jacobo Tapia on 24/10/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DrawingCanvas.h"

@interface Document : NSDocument

@property (nonatomic, strong) DrawingCanvas *drawingCanvas;

@end

