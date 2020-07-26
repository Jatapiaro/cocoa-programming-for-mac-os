//
//  Document.h
//  CarLot
//
//  Created by Jacobo Tapia on 23/07/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CarArrayController.h"

@interface Document : NSPersistentDocument

@property (weak) IBOutlet NSTableView *tableView;
@property (strong) IBOutlet CarArrayController *carsArrayController;

- (IBAction)createNewCar:(id)sender;

@end
