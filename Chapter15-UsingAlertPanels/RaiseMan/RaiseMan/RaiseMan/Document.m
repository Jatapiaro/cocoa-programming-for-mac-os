//
//  Document.m
//  RaiseMan
//
//  Created by Jacobo Tapia on 19/07/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import "Document.h"
#import "Person.h"
#import "PreferenceController.h"
#import "AppConstants.h"

static void *RMDocumentKVOContext;

@interface Document ()

@end

@implementation Document

- (instancetype)init {

    if (self = [super init])
        _employees = [NSMutableArray array];

    NSNotificationCenter *notificationCenter = NSNotificationCenter.defaultCenter;
    [notificationCenter addObserver:self selector:@selector(_handleTableBackgroundColorChanged) name:TableBackgroundColorChangedNotificationKey object:nil];

    return self;
}

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)windowControllerDidLoadNib:(NSWindowController *)windowController
{
    [super windowControllerDidLoadNib:windowController];
    [self _handleTableBackgroundColorChanged];
}

+ (BOOL)autosavesInPlace {
    return YES;
}

- (NSString *)windowNibName {
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error if you return nil.
    // Alternatively, you could remove this method and override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.

    // End editing
    [_tableView.window endEditingFor:nil];

    // Create NSData object from the employees array
    return [NSKeyedArchiver archivedDataWithRootObject:_employees requiringSecureCoding:NO error:nil];
}


- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error if you return NO.
    // Alternatively, you could remove this method and override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you do, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.

    NSMutableArray *loadedData = nil;
    @try {
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:data error:nil];
        NSSet *classes = [NSSet setWithObjects:NSMutableArray.class, Person.class, nil];
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

    // By adding self.employees we will call the setter
    self.employees = loadedData;
    return YES;
}

// MARK: Employees Management

- (void)setEmployees:(NSMutableArray *)employees
{
    if (_employees == employees)
        return;

    for (Person *p in _employees)
        [self _stopObservingPerson:p];

    _employees = employees;

    for (Person *p in _employees)
        [self _startObservingPerson:p];
}

// MARK: KVC Implementations

- (void)insertObject:(Person *)person inEmployeesAtIndex:(NSUInteger)index
{
    NSUndoManager *undoManager = self.undoManager;
    [[undoManager prepareWithInvocationTarget:self] removeObjectFromEmployeesAtIndex:index];

    if (!undoManager.undoing)
        [undoManager setActionName:@"Add Person"];

    [self _startObservingPerson:person];
    [_employees insertObject:person atIndex:index];
}

- (void)removeObjectFromEmployeesAtIndex:(NSUInteger)index
{
    NSUndoManager *undoManager = self.undoManager;
    Person *person = [_employees objectAtIndex:index];
    [[undoManager prepareWithInvocationTarget:self] insertObject:person inEmployeesAtIndex:index];

    if (!undoManager.undoing)
        [undoManager setActionName:@"Remove Person"];

    [self _stopObservingPerson:person];
    [_employees removeObjectAtIndex:index];
}

- (void)_startObservingPerson:(Person *)person
{
    [person addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionOld context:&RMDocumentKVOContext];
    [person addObserver:self forKeyPath:@"expectedRaise" options:NSKeyValueObservingOptionOld context:&RMDocumentKVOContext];
}

- (void)_stopObservingPerson:(Person *)person
{
    [person removeObserver:self forKeyPath:@"name" context:&RMDocumentKVOContext];
    [person removeObserver:self forKeyPath:@"expectedRaise" context:&RMDocumentKVOContext];
}

- (void)_changeKeyPath:(NSString *)keyPath ofObject:(id)object toValue:(id)newValue
{
    [object setValue:newValue forKey:keyPath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{

    // If the context doesnt match, the message
    // must be intended for the super class
    if (context != &RMDocumentKVOContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }

    NSUndoManager *undoManager = self.undoManager;
    id oldValue = [change objectForKey:NSKeyValueChangeOldKey];

    if (oldValue == [NSNull null])
        oldValue = nil;

    [[undoManager prepareWithInvocationTarget:self] _changeKeyPath:keyPath ofObject:object toValue:oldValue];
    [undoManager setActionName:@"Edit"];
}

// MARK: Actions

- (void)createEmployee:(id)sender
{
    NSWindow *window = _tableView.window;
    BOOL editingEnded = [window makeFirstResponder:window];

    // Try to end any editing that is taking place
    if (!editingEnded) {
        NSLog(@"Unable to end editing");
        return;
    }

    NSUndoManager *undoManager = self.undoManager;

    // Has an edut occured already in this event
    if (undoManager.groupingLevel > 0) {
        // Close the last group
        [undoManager endUndoGrouping];
        //Open a new group
        [undoManager beginUndoGrouping];
    }

    // Create the object
    Person *p = [_employeeController newObject];
    // Add it to the content array
    [_employeeController addObject:p];

    // Re-sort in case the user has a sorted column
    [_employeeController rearrangeObjects];

    // Get the sorted array
    NSArray *array = _employeeController.arrangedObjects;
    NSUInteger row = [array indexOfObject:p];

    NSLog(@"Starting edit of %@ in row %lu", p, row);

    // Begin the edit in the first column
    [_tableView editColumn:0 row:row withEvent:nil select:YES];
}

- (void)removeEmployee:(id)sender
{
    NSArray<Person *> *selectedEmployees = _employeeController.selectedObjects;
    NSAlert *alert = [self _createAlertWithMessageText:@"Do you really want to remove this people" defaultButton:@"Remove" alternateButton:@"Cancel" otherButton:@"Keep, but no raise" informativeTextWithFormat:[NSString stringWithFormat:@"%@ people will be removed", @(selectedEmployees.count)]];

    // Block implicitly retains 'self'; explicitly mention 'self' to indicate this is intended behavior
    [alert beginSheetModalForWindow:_tableView.window completionHandler:^(NSModalResponse returnCode) {
        if (NSAlertFirstButtonReturn == returnCode)
            [self->_employeeController remove:nil];

        if (NSAlertThirdButtonReturn == returnCode) {
            for (Person *p in selectedEmployees)
                p.expectedRaise = 0;

            [self->_employeeController rearrangeObjects];
        }
    }];
}

- (NSAlert *)_createAlertWithMessageText:(NSString *)messageText defaultButton:(NSString *)defaultButton alternateButton:(NSString *)alternateButton otherButton:(NSString *)otherButton informativeTextWithFormat:(NSString *)informativeText
{
    NSAlert *alert = [[NSAlert alloc] init];

    if (messageText)
        alert.messageText = messageText;

    if (defaultButton)
        [alert addButtonWithTitle:defaultButton];

    if (alternateButton)
        [alert addButtonWithTitle:alternateButton];

    if (otherButton)
        [alert addButtonWithTitle:otherButton];

    if (informativeText)
        alert.informativeText = informativeText;

    return alert;
}

// MARK: Notifications for settings

- (void)_handleTableBackgroundColorChanged
{
    _tableView.backgroundColor = [PreferenceController preferenceTableBackgroundColor];
}

// Unused, just for book porpuses of passing a user info dict

- (void)_handleTableBackgroundColorChangedNotification:(NSNotification *)notification
{
    _tableView.backgroundColor = [notification.userInfo objectForKey:@"color"];
}

@end
