//
//  Document.m
//  RaiseMan
//
//  Created by Jacobo Tapia on 19/07/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import "Document.h"
#import "Person.h"

static void *RMDocumentKVOContext;

@interface Document ()

@end

@implementation Document

- (instancetype)init {

    self = [super init];
    if (self)
        _employees = [NSMutableArray array];

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


- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error if you return nil.
    // Alternatively, you could remove this method and override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    [NSException raise:@"UnimplementedMethod" format:@"%@ is unimplemented", NSStringFromSelector(_cmd)];
    return nil;
}


- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error if you return NO.
    // Alternatively, you could remove this method and override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you do, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    [NSException raise:@"UnimplementedMethod" format:@"%@ is unimplemented", NSStringFromSelector(_cmd)];
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


@end
