//
//  Document.m
//  ManualRaiseMan
//
//  Created by Jacobo Tapia on 16/07/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import "Document.h"
#import "Employee.h"
#import "PreferencesController.h"
#import "AppDefaults.h"
#import "NSMutableArrayExtras.h"
#import "NSAlertExtras.h"

static NSString * const nameColumnIdentifier =  @"name";
static NSString * const expectedRaiseColumnIdentifier = @"expectedRaise";

static void *RMDocumentKVOContext;

@interface Document ()
@end

@implementation Document

- (instancetype)init {
    if (self = [super init]) {
        _employees = [NSMutableArray array];
    }

    NSNotificationCenter *notificationCenter = NSNotificationCenter.defaultCenter;
    [notificationCenter addObserver:self selector:@selector(_tableBackgroundColorDidChange) name:MRMTableBackgroundColorDidChangeNotificationKey object:nil];

    return self;
}

- (void)setEmployees:(NSMutableArray *)employees
{
    if (_employees == employees)
        return;

    for (Employee *e in _employees)
        [self _stopObservingEmployee:e];

    _employees = employees;
    for (Employee *e in employees)
        [self _startObservingEmployee:e];
}

- (void)windowControllerDidLoadNib:(NSWindowController *)windowController
{
    [super windowControllerDidLoadNib:windowController];
    [self _configureTableViewColumnsSortDescriptors];

    [self _tableBackgroundColorDidChange];
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

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // End editing
    [_tableView.window endEditingFor:nil];
    return [NSKeyedArchiver archivedDataWithRootObject:_employees requiringSecureCoding:NO error:nil];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    NSMutableArray *loadedData;
    @try {
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:data error:nil];
        NSSet *classes = [NSSet setWithObjects:NSMutableArray.class, Employee.class, nil];
        loadedData = [unarchiver decodeObjectOfClasses:classes forKey:NSKeyedArchiveRootObjectKey];
    } @catch (NSException *exception) {
        NSLog(@"Exception = %@", exception);
        NSDictionary *dictionary = @{
            @"The data is corrupted": NSLocalizedFailureReasonErrorKey,
        };
        *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:dictionary];
        return NO;
    }
    self.employees = loadedData;
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
    [_employees sortUsingDescriptors:_tableView.sortDescriptors];
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
    if (!self._editingEnded) {
        NSLog(@"Unable to end editing");
        return;
    }

    [self _addEmployee:[[Employee alloc] init]];
}

- (void)_addEmployee:(Employee *)employee
{
    [self _prepareGroupingLevel];

    [self _startObservingEmployee:employee];
    [_employees addObject:employee];
    [_employees sortUsingDescriptors:_tableView.sortDescriptors];

    NSInteger row = [_employees indexOfObject:employee];
    [[self.undoManager prepareWithInvocationTarget:self] _removeEmployees:@[ employee ] atIndexes:[NSIndexSet indexSetWithIndex:row]];

    if (!self.undoManager.isUndoing)
        [self.undoManager setActionName:@"Add employee"];

    [_tableView reloadData];
    [_tableView editColumn:0 row:row withEvent:nil select:YES];
}

- (void)_addEmployees:(NSArray<Employee *>*)employees atIndexes:(NSIndexSet *)indexes
{
    [self _prepareGroupingLevel];

    for(Employee *employee in employees)
        [self _startObservingEmployee:employee];

    NSIndexSet *indexesToRemove = indexes;
    if (_tableView.sortDescriptors.count) {
        [_employees addObjectsFromArray:employees];
        [_employees sortUsingDescriptors:_tableView.sortDescriptors];

        indexesToRemove = [_employees indexesOfObjectsInArray:employees];
    } else
        [_employees insertObjects:employees atIndexes:indexes];

    [[self.undoManager prepareWithInvocationTarget:self] _removeEmployees:employees atIndexes:indexesToRemove];
    if (!self.undoManager.isUndoing)
        [self.undoManager setActionName:employees.count == 1 ? @"Add employee" : @"Add employees"];

    [_tableView reloadData];
}

- (IBAction)removeEmployee:(id)sender
{
    NSIndexSet *selectedRows = _tableView.selectedRowIndexes;
    if (!selectedRows.count)
        return;

    NSArray<Employee *> *removedEmployees = [_employees objectsAtIndexes:selectedRows];

    NSAlert *alert = [NSAlert alertWithMessageText:NSLocalizedString(@"REMOVE_MSG", @"Remove message") defaultButton:NSLocalizedString(@"REMOVE", @"Remove") alternateButton:NSLocalizedString(@"CANCEL", @"Cancel") otherButton:NSLocalizedString(@"KEEP", @"Keep but not raise") informativeTextWithFormat:[NSString stringWithFormat:NSLocalizedString(@"REMOVE_INF", @"%d people will be removed."), selectedRows.count]];

    [alert beginSheetModalForWindow:_tableView.window completionHandler:^(NSModalResponse returnCode) {
        if (NSAlertFirstButtonReturn == returnCode) {
            [self _removeEmployees:removedEmployees atIndexes:selectedRows];
            [self->_tableView deselectAll:nil];
        }

        if (NSAlertThirdButtonReturn == returnCode) {
            for (Employee *employee in removedEmployees)
                employee.expectedRaise = 0;

            [self->_tableView reloadDataForRowIndexes:selectedRows columnIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)]];
            [self->_tableView deselectAll:nil];
        }
    }];
}

- (void)_removeEmployees:(NSArray<Employee *>*)employees atIndexes:(NSIndexSet *)indexes
{
    if (!self._editingEnded) {
        NSLog(@"Unable to end editing");
        return;
    }

    [self _prepareGroupingLevel];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [self _stopObservingEmployee:[_employees objectAtIndex:idx]];
    }];

    [_employees removeObjectsAtIndexes:indexes];

    [[self.undoManager prepareWithInvocationTarget:self] _addEmployees:employees atIndexes:indexes];
    if (!self.undoManager.isUndoing)
        [self.undoManager setActionName:employees.count == 1 ? @"Remove employee" : @"Remove employees"];

    [_tableView reloadData];
}

- (BOOL)_editingEnded
{
    NSWindow *window = _tableView.window;
    return [window makeFirstResponder:window];
}

- (void)_prepareGroupingLevel
{
    NSUndoManager *undoManager = self.undoManager;

    // Has an edit already occurred in this event?
    if (undoManager.groupingLevel > 0) {
        [undoManager endUndoGrouping];
        [undoManager beginUndoGrouping];
    }
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

    if (_tableView.sortDescriptors.count) {
        [_employees sortUsingDescriptors:_tableView.sortDescriptors];
        [_tableView reloadData];
    }
}

- (void)changeKeyPath:(NSString *)keyPath ofObject:(id)object toValue:(id)value
{
    [object setValue:value forKey:keyPath];
    [_tableView reloadData];
}

// MARK: Setting changed notifications

- (void)_tableBackgroundColorDidChange
{
    _tableView.backgroundColor = [PreferencesController preferenceBackgroundColor];
}

@end
