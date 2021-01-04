//
//  NSAlertExtras.h
//  ManualRaiseMan
//
//  Created by Jacobo Tapia on 8/31/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAlert (NSAlertExtras)

+ (instancetype)alertWithMessageText:(NSString *)messageText defaultButton:(NSString *)defaultButton alternateButton:(NSString *)alternateButton otherButton:(NSString *)otherButton informativeTextWithFormat:(NSString *)informativeText;

@end

NS_ASSUME_NONNULL_END
