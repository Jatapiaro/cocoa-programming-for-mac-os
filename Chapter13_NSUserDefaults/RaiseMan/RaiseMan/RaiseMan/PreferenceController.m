//
//  PreferenceController.m
//  RaiseMan
//
//  Created by Jacobo Tapia on 01/08/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import "PreferenceController.h"
#import "UserDefaults.h"

@interface PreferenceController ()

@end

@implementation PreferenceController

- (id)init
{
    self = [super initWithWindowNibName:@"Preferences"];

    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self _loadDefaultsInPanel];
}

// MARK: User preferences

+ (NSColor *)preferenceTableBackgroundColor
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *colorAsData = [defaults objectForKey:TableBackgroundColorKey];

    return [NSKeyedUnarchiver unarchivedObjectOfClass:NSColor.class fromData:colorAsData error:nil];
}

+ (void)setPreferenceTableBackgroundColor:(NSColor *)color
{
    NSData *colorAsData = [NSKeyedArchiver archivedDataWithRootObject:color requiringSecureCoding:NO error:nil];
    [[NSUserDefaults standardUserDefaults] setObject:colorAsData forKey:TableBackgroundColorKey];
}

+ (BOOL)preferenceEmptyDocument
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:EmptyDocumentKey];
}

+ (void)setPreferenceEmptyDocument:(BOOL)emptyDocument
{
    [[NSUserDefaults standardUserDefaults] setBool:emptyDocument forKey:EmptyDocumentKey];
}

// MARK: Actions

- (void)changeBackgroundColor:(id)sender
{
    NSColor *color = _colorWell.color;
    NSLog(@"Color changed: %@ color", color);
    [PreferenceController setPreferenceTableBackgroundColor:color];
}

- (void)changeNewEmptyDocument:(id)sender
{
    NSControlStateValue state = _checkbox.state;
    NSLog(@"Checkbox changed: %ld color", state);
    [PreferenceController setPreferenceEmptyDocument:state];
}

- (void)resetUserPreferences:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:TableBackgroundColorKey];
    [defaults removeObjectForKey:EmptyDocumentKey];

    [self _loadDefaultsInPanel];
}

- (void)_loadDefaultsInPanel
{
    _colorWell.color = [PreferenceController preferenceTableBackgroundColor];
    _checkbox.state = [PreferenceController preferenceEmptyDocument];
}


@end
