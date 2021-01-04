//
//  PreferencesController.m
//  ManualRaiseMan
//
//  Created by Jacobo Tapia on 01/08/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import "PreferencesController.h"
#import "UserDefaults.h"

@interface PreferencesController ()

@end

@implementation PreferencesController

-(id)init
{
    self = [self initWithWindowNibName:@"PreferencesPanel"];

    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self _loadUserDefaults];
}

// MARK: User Preferences Management

+ (NSColor *)preferenceBackgroundColor
{
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    NSData *colorAsData = [defaults objectForKey:MRMTableBackgroundColorPreferenceKey];

    return [NSKeyedUnarchiver unarchivedObjectOfClass:NSColor.class fromData:colorAsData error:nil];
}

+ (void)setPreferenceBackgroundColor:(NSColor *)color
{
    NSData *colorAsData = [NSKeyedArchiver archivedDataWithRootObject:color requiringSecureCoding:NO error:nil];
    [NSUserDefaults.standardUserDefaults setObject:colorAsData forKey:MRMTableBackgroundColorPreferenceKey];
}

+ (BOOL)preferenceOpenUntitledDocument
{
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;

    return [defaults boolForKey:MRMOpenUntitledDocumentPreferenceKey];
}

+ (void)setPreferenceOpenUntitledDocument:(BOOL)untitledDocument
{
    [NSUserDefaults.standardUserDefaults setBool:untitledDocument forKey:MRMOpenUntitledDocumentPreferenceKey];
}

- (void)_loadUserDefaults
{
    _colorWell.color = [PreferencesController preferenceBackgroundColor];
    _checkBox.state = [PreferencesController preferenceOpenUntitledDocument];
}

// MARK: Actions

- (void)changeBackgroundColor:(id)sender
{
    NSColor *color = _colorWell.color;
    [PreferencesController setPreferenceBackgroundColor:color];
}

- (void)changeNewEmptyDocument:(id)sender
{
    NSControlStateValue state = _checkBox.state;
    NSLog(@"State: %ld", state);
    [PreferencesController setPreferenceOpenUntitledDocument:state];
}

- (void)resetUserDefaults:(id)sender
{
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;

    [defaults removeObjectForKey:MRMTableBackgroundColorPreferenceKey];
    [defaults removeObjectForKey:MRMOpenUntitledDocumentPreferenceKey];
    [self _loadUserDefaults];
}

@end
