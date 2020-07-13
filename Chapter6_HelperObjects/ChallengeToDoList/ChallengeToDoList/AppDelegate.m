//
//  AppDelegate.m
//  ChallengeToDoList
//
//  Created by Jacobo Tapia on 13/07/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (id)init
{
    self = [super init];

    if (self)
        _list = [NSMutableArray array];

    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)addToDo:(id)sender
{
    NSString *toDo = _textField.stringValue;
    if (toDo.length == 0)
        return;

    [_list addObject:toDo];
    _textField.stringValue = @"";
    [_tableView reloadData];
}

// MARK: NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return _list.count;
}

// MARK: NSTableViewDelegate

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return [_list objectAtIndex:row];
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    [_list replaceObjectAtIndex:row withObject:object];
}

@end
