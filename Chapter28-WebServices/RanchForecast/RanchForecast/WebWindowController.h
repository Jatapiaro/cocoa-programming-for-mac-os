//
//  WebWindowController.h
//  RanchForecast
//
//  Created by Jacobo Tapia de la Rosa on 1/15/21.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebWindowController : NSWindowController

- (void)showWindowAsSheetFromWindow:(NSWindow *)window withRequest:(NSURLRequest *)request;
- (IBAction)closeWebView:(NSButton *)sender;

@end

NS_ASSUME_NONNULL_END
