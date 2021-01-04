//
//  Document.m
//  OvalDrawing
//
//  Created by Jacobo Tapia on 24/10/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import "Document.h"
#import "DrawingDocumentWindowController.h"
#import "Oval.h"
#import "DrawingCanvasEncoderObject.h"

@implementation Document {
    DrawingCanvasEncoderObject *_encoderObject;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error if you return nil.
    // Alternatively, you could remove this method and override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    // Create NSData object from the employees array

    return [NSKeyedArchiver archivedDataWithRootObject:_drawingCanvas.encoderHelperObject requiringSecureCoding:NO error:nil];
}


- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error if you return NO.

    DrawingCanvasEncoderObject *loadedData = nil;
    @try {
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:data error:nil];
        NSSet *classes = [NSSet setWithObjects:NSMutableArray.class, DrawingCanvasEncoderObject.class, Oval.class, NSColor.class, nil];
        loadedData = [unarchiver decodeObjectOfClasses:classes forKey:NSKeyedArchiveRootObjectKey];
        [unarchiver finishDecoding];
    } @catch (NSException *exception) {
        NSLog(@"Exception = %@", exception);
        NSDictionary *dictionary = @{
            @"The data is corrupted": NSLocalizedFailureReasonErrorKey,
        };
        *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:dictionary];
        return NO;
    }

    _encoderObject = loadedData;
    return YES;
}

// MARK: Custom Window Controllers

- (void)makeWindowControllers
{
    DrawingDocumentWindowController *windowController = [[DrawingDocumentWindowController alloc] initWithWindowNibName:self.windowNibName];
    [self addWindowController:windowController];
}

// MARK: Extra

- (void)setDrawingCanvas:(DrawingCanvas *)drawingCanvas
{
    _drawingCanvas = drawingCanvas;
    if (_encoderObject) {
        [_drawingCanvas loadDataFromEncoder:_encoderObject];
        _encoderObject = nil;
    }
}

@end
