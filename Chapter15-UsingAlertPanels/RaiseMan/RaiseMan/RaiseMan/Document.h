//
//  Document.h
//  RaiseMan
//
//  Created by Jacobo Tapia on 19/07/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class Person;

@interface Document : NSDocument

@property (nonatomic, weak) IBOutlet NSTableView *tableView;
@property (nonatomic, weak) IBOutlet NSArrayController *employeeController;
@property (nonatomic, copy) NSMutableArray *employees;

- (void)setEmployees:(NSMutableArray *)employees;

- (IBAction)createEmployee:(id)sender;
- (IBAction)removeEmployee:(id)sender;

@end

