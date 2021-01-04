//
//  PreferencesController.h
//  ManualRaiseMan
//
//  Created by Jacobo Tapia on 01/08/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface PreferencesController : NSWindowController

@property (nonatomic, weak) IBOutlet NSColorWell *colorWell;
@property (nonatomic, weak) IBOutlet NSButton *checkBox;

-(IBAction)changeBackgroundColor:(id)sender;
-(IBAction)changeNewEmptyDocument:(id)sender;

@end

NS_ASSUME_NONNULL_END
