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

    NSUInteger row = [self _addEmployees:@[ [[Employee alloc] init] ]];
    [_tableView editColumn:0 row:row withEvent:nil select:YES];
}

- (NSUInteger)_addEmployees:(NSArray<Employee *> *)employees
{
    for (Employee *e in employees)
        [self _startObservingEmployee:e];

    NSUndoManager *undoManager = self.undoManager;

    if (employees.count == 1) {
        [[undoManager prepareWithInvocationTarget:self] _removeEmployees:@[ employees.firstObject ]];

        if (!undoManager.isUndoing)
            [undoManager setActionName:@"Add Employee"];
    } else {
        [[undoManager prepareWithInvocationTarget:self] _removeEmployees:employees];

        if (!undoManager.isUndoing)
            [undoManager setActionName:@"Add Employees"];
    }

    [_employees addObjectsFromArray:employees];
    [_employees sortUsingDescriptors:_tableView.sortDescriptors];
    [_tableView reloadData];

    return employees.count == 1 ? [_employees indexOfObject:employees.firstObject] : -1;
}

- (IBAction)removeEmployee:(id)sender
{
    NSIndexSet *selectedRows = _tableView.selectedRowIndexes;
    NSAssert(selectedRows.count > 0, @"Table View should have a selected item");
    [self _removeEmployees:[_employees objectsAtIndexes:selectedRows]];
}

- (void)_removeEmployees:(NSArray<Employee *> *)employees
{
    for (Employee *e in employees)
        [self _stopObservingEmployee:e];

    NSUndoManager *undoManager = self.undoManager;

    if (employees.count == 1) {
        [[undoManager prepareWithInvocationTarget:self] _addEmployees:@[ employees.firstObject ]];

        if (!undoManager.isUndoing)
            [undoManager setActionName:@"Remove Employee"];
    } else {
        [[undoManager prepareWithInvocationTarget:self] _addEmployees:employees];

        if (!undoManager.isUndoing)
            [undoManager setActionName:@"Remove Employees"];
    }

    [_employees removeObjectsAtIndexes:_tableView.selectedRowIndexes];
    [_tableView reloadData];
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

// MARK: Setting changed notifications

- (void)_tableBackgroundColorDidChange
{
    _tableView.backgroundColor = [PreferencesController preferenceBackgroundColor];
}

@end
