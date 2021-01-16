//
//  TutorController.h
//  TypingTutor
//
//  Created by Jacobo Tapia de la Rosa on 1/10/21.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface TutorController : NSViewController

- (IBAction)stopGo:(NSButton *)sender;
- (IBAction)showSpeedSheet:(id)sender;
- (IBAction)endSpeedSheet:(id)sender;

@end

NS_ASSUME_NONNULL_END
