//
//  Document.h
//  ManualRiseMan
//
//  Created by Jacobo Tapia on 16/07/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Document : NSDocument <NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *tableView;
@property (readonly, copy) NSMutableArray *employees;

- (IBAction)addEmployee:(id)sender;

@end

