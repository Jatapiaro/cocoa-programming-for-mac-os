//
//  AppController.h
//  RaiseMan
//
//  Created by Jacobo Tapia on 01/08/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cocoa/Cocoa.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppController : NSObject <NSApplicationDelegate>

- (IBAction)showAboutPanel:(id)sender;
- (IBAction)showPreferencePanel:(id)sender;

@end

NS_ASSUME_NONNULL_END
