//
//  NSAlertExtras.m
//  ManualRaiseMan
//
//  Created by Jacobo Tapia on 8/31/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import "NSAlertExtras.h"

@implementation NSAlert (NSAlertExtras)

+ (instancetype)alertWithMessageText:(NSString *)messageText defaultButton:(NSString *)defaultButton alternateButton:(NSString *)alternateButton otherButton:(NSString *)otherButton informativeTextWithFormat:(NSString *)informativeText
{
    NSAlert *alert = [[self.class alloc] init];

    if (messageText)
        alert.messageText = messageText;

    if (defaultButton)
        [alert addButtonWithTitle:defaultButton];

    if (alternateButton)
        [alert addButtonWithTitle:alternateButton];

    if (otherButton)
        [alert addButtonWithTitle:otherButton];

    if (informativeText)
        alert.informativeText = informativeText;

    return alert;
}

@end
