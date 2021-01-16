//
//  WebWindowController.m
//  RanchForecast
//
//  Created by Jacobo Tapia de la Rosa on 1/15/21.
//

#import "WebWindowController.h"

#import <WebKit/WKWebView.h>
#import <WebKit/WKNavigationDelegate.h>

static void *RanchForecastContext;

@interface WebWindowController () <WKNavigationDelegate>
@property (nonatomic, weak) IBOutlet WKWebView *webView;
@property (nonatomic, weak) IBOutlet NSProgressIndicator *progress;
@end

@implementation WebWindowController {
    NSWindow *_presentingWindow;
}

- (NSNibName)windowNibName
{
    return @"WebWindowController";
}

- (void)windowDidLoad
{
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:&RanchForecastContext];
}

- (void)dealloc
{
    [_webView removeObserver:self forKeyPath:@"estimatedProgresss" context:&RanchForecastContext];
}

- (void)showWindowAsSheetFromWindow:(NSWindow *)window withRequest:(NSURLRequest *)request
{
    _presentingWindow = window;
    [_presentingWindow beginSheet:self.window completionHandler:nil];
    [_webView loadRequest:request];
}

- (void)closeWebView:(NSButton *)sender
{
    if (!_presentingWindow)
        return;

    [_presentingWindow endSheet:self.window];
    _presentingWindow = nil;
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    _progress.doubleValue = 0;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    _progress.doubleValue = 1;
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    _progress.doubleValue = 0;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (&RanchForecastContext != context)
        return;

    NSNumber *newValue = [object valueForKey:keyPath];
    if (!newValue)
        return;

    _progress.doubleValue = newValue.doubleValue;
}

@end
