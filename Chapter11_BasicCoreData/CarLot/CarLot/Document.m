//
//  Document.m
//  CarLot
//
//  Created by Jacobo Tapia on 23/07/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import "Document.h"

@interface Document ()

@end

@implementation Document

- (instancetype)init {
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

+ (BOOL)autosavesInPlace {
    return YES;
}


- (NSString *)windowNibName {
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}


// MARK: Custom Actions
- (IBAction)createNewCar:(id)sender
{
    NSWindow *window = _tableView.window;
    BOOL editingEnded = [window makeFirstResponder:window];

    // Try to end any editing that is taking place
    if (!editingEnded) {
        NSLog(@"Unable to end editing");
        return;
    }

    NSUndoManager *undoManager = self.undoManager;
    // Has an edit occured already in this event
    if (undoManager.groupingLevel > 0) {
        [undoManager endUndoGrouping];
        [undoManager beginUndoGrouping];
    }

    id car = [_carsArrayController newObject];
    [_carsArrayController addObject:car];
    [_carsArrayController rearrangeObjects];
    NSInteger row = [_carsArrayController.arrangedObjects indexOfObject:car];

    [_tableView editColumn:0 row:row withEvent:nil select:YES];
}

@end
