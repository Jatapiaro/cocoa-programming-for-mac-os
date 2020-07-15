//
//  AppDelegate.h
//  KvcFun
//
//  Created by Jacobo Tapia on 15/07/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (readwrite, assign) int fido;

- (void)setFido:(int)fido;
- (int)fido;
- (IBAction)incrementFido:(id)sender;

@end

