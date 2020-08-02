//
//  PreferenceController.h
//  RaiseMan
//
//  Created by Jacobo Tapia on 01/08/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface PreferenceController : NSWindowController

@property (nonatomic, weak) IBOutlet NSColorWell *colorWell;
@property (nonatomic, weak) IBOutlet NSButton *checkbox;

+ (NSColor *)preferenceTableBackgroundColor;
+ (void)setPreferenceTableBackgroundColor:(NSColor *)color;
+ (BOOL)preferenceEmptyDocument;
+ (void)setPreferenceEmptyDocument:(BOOL)emptyDocument;

- (IBAction)changeBackgroundColor:(id)sender;
- (IBAction)changeNewEmptyDocument:(id)sender;
- (IBAction)resetUserPreferences:(id)sender;

@end

NS_ASSUME_NONNULL_END
