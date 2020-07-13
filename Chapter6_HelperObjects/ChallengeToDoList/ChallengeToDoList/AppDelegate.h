//
//  AppDelegate.h
//  ChallengeToDoList
//
//  Created by Jacobo Tapia on 13/07/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTableViewDelegate, NSTableViewDataSource> {
    NSMutableArray<NSString *> *_list;
}

@property (weak) IBOutlet NSTextFieldCell *textField;
@property (weak) IBOutlet NSTableView *tableView;

- (IBAction)addToDo:(id)sender;

@end

