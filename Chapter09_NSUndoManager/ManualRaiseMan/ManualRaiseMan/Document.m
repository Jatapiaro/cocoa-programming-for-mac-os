//
//  Document.m
//  ManualRaiseMan
//
//  Created by Jacobo Tapia on 16/07/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import "Document.h"
#import "Employee.h"

static NSString * const nameColumnIdentifier =  @"name";
static NSString * const expectedRaiseColumnIdentifier = @"expectedRaise";

static void *RMDocumentKVOContext;

@interface Document ()
@end

@implementation Document

- (instancetype)init {
    self = [super init];

    if (self) {
        _employees = [NSMutableArray array];
    }

    return self;
}

- (void)awakeFromNib
{
    [self _configureTableViewColumnsSortDescriptors];
}

- (void)_configureTableViewColumnsSortDescriptors
{
    NSTableColumn *nameTableColumn = [_tableView tableColumnWithIdentifier:nameColumnIdentifier];
    NSTableColumn *expectedRaiseTableColumn = [_tableView tableColumnWithIdentifier:expectedRaiseColumnIdentifier];

    NSSortDescriptor *nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nameColumnIdentifier ascending:YES selector:@selector(caseInsensitiveCompare:)];
    NSSortDescriptor *expectedRaiseSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:expectedRaiseColumnIdentifier ascending:YES selector:@selector(compare:)];

    nameTableColumn.sortDescriptorPrototype = nameSortDescriptor;
    expectedRaiseTableColumn.sortDescriptorPrototype = expectedRaiseSortDescriptor;
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

// MARK: NSTableViewDataSource

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    Employee *employee = [_employees objectAtIndex:row];
    return [employee valueForKey:tableColumn.identifier];
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    Employee *employee = [_employees objectAtIndex:row];
    [employee setValue:object forKey:tableColumn.identifier];

    [_employees replaceObjectAtIndex:row withObject:employee];
    [tableView reloadData];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return _employees.count;
}

- (void)tableView:(NSTableView *)tableView sortDescriptorsDidChange:(NSArray<NSSortDescriptor *> *)oldDescriptors
{
    [_employees sortUsingDescriptors:tableView.sortDescriptors];
    [tableView reloadData];
}

// MARK: NSTableViewDelegate

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSInteger selectedRow = _tableView.selectedRow;
    _removeButton.enabled = selectedRow != -1;
}

// MARK: Button Actions

- (IBAction)addEmployee:(id)sender
{
    NSWindow *window = _tableView.window;
    BOOL editingEnded = [window makeFirstResponder:window];

    if (!editingEnded) {
        NSLog(@"Unable to end editing");
        return;
    }

    NSUndoManager *undoManager = self.undoManager;

    //Has an edit already occurred in this event?
    if (undoManager.groupingLevel > 0) {
        [undoManager endUndoGrouping];
        [undoManager beginUndoGrouping];
    }

    NSUInteger row = [self _addEmployee:[[Employee alloc] init]];
    [_tableView editColumn:0 row:row withEvent:nil select:YES];
}

- (NSUInteger)_addEmployee:(Employee *)employee
{
    [self _startObservingEmployee:employee];

    NSUndoManager *undoManager = self.undoManager;
    [[undoManager prepareWithInvocationTarget:self] _removeEmployee:employee];

    if (!undoManager.isUndoing)
        [undoManager setActionName:@"Add Employee"];

    [_employees addObject:employee];
    [_employees sortUsingDescriptors:_tableView.sortDescriptors];
    [_tableView reloadData];

    return [_employees indexOfObject:employee];
}

- (void)_removeEmployee:(Employee *)employee
{
    [self _stopObservingEmployee:employee];

    NSUndoManager *undoManager = self.undoManager;
    [[undoManager prepareWithInvocationTarget:self] _addEmployee:employee];

    if (!undoManager.isUndoing)
        [undoManager setActionName:@"Remove Employee"];

    [_employees removeObject:employee];
    [_tableView reloadData];
}

- (IBAction)removeEmployee:(id)sender
{
    NSInteger selectedRow = _tableView.selectedRow;
    NSAssert(selectedRow != -1, @"Table View should have a selected item");
    [self _removeEmployee:[_employees objectAtIndex:selectedRow]];
}

// MARK: Key Value Observing

- (void)_startObservingEmployee:(Employee *)employee
{
    [employee addObserver:self forKeyPath:nameColumnIdentifier options:NSKeyValueObservingOptionOld context:&RMDocumentKVOContext];
    [employee addObserver:self forKeyPath:expectedRaiseColumnIdentifier options:NSKeyValueObservingOptionOld context:&RMDocumentKVOContext];
}

- (void)_stopObservingEmployee:(Employee *)employee
{
    [employee removeObserver:self forKeyPath:nameColumnIdentifier context:&RMDocumentKVOContext];
    [employee removeObserver:self forKeyPath:expectedRaiseColumnIdentifier context:&RMDocumentKVOContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (context != &RMDocumentKVOContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }

    NSUndoManager *undoManager = self.undoManager;
    id oldValue = [change objectForKey:NSKeyValueChangeOldKey];

    if (oldValue == [NSNull null])
        oldValue = nil;

    [[undoManager prepareWithInvocationTarget:self] changeKeyPath:keyPath ofObject:object toValue:oldValue];
    [undoManager setActionName:@"Edit Employee"];
}

- (void)changeKeyPath:(NSString *)keyPath ofObject:(id)object toValue:(id)value
{
    [object setValue:value forKey:keyPath];
    [_tableView reloadData];
}

@end
