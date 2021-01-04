//
//  Document.m
//  ManualRaiseMan
//
//  Created by Jacobo Tapia on 16/07/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import "Document.h"
#import "Employee.h"

const NSString *nameColumnIdentifier = @"name";
const NSString *expectedRaiseColumnIdentifier = @"expectedRaise";

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
    [_employees addObject:[[Employee alloc] init]];
    [_tableView reloadData];
}

- (IBAction)removeEmployee:(id)sender
{
    NSInteger selectedRow = _tableView.selectedRow;
    NSAssert(selectedRow != -1, @"Table View should have a selected item");
    [_employees removeObjectAtIndex:selectedRow];
    [_tableView reloadData];
}

@end
