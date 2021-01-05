//
//  BigLetterView.h
//  TypingTutor
//
//  Created by Jacobo Tapia de la Rosa on 1/4/21.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface BigLetterView : NSView

@property (nonatomic) NSColor *color;
@property (nonatomic, copy) NSString *string;

- (IBAction)savePDF:(id)sender;
- (IBAction)boldStateDidChange:(NSButton *)sender;
- (IBAction)italicStateDidChange:(NSButton *)sender;

@end

NS_ASSUME_NONNULL_END
