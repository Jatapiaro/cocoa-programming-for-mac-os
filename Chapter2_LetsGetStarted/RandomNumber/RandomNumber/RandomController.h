//
//  RandomController.h
//  RandomNumber
//
//  Created by Jacobo Tapia on 09/07/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface RandomController : NSObject {
    IBOutlet NSTextField *_textField;
}

- (IBAction)seed:(id)sender;
- (IBAction)generate:(id)sender;

@end

NS_ASSUME_NONNULL_END
