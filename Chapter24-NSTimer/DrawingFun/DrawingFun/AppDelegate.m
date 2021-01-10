//
//  AppDelegate.m
//  DrawingFun
//
//  Created by Jacobo Tapia on 9/20/20.
//

#import "AppDelegate.h"
#import "StretchView.h"

@interface AppDelegate ()
@property (strong) IBOutlet NSWindow *window;
@property (weak, nonatomic) IBOutlet StretchView *stretchView;
@property (weak, nonatomic) IBOutlet NSSlider *opacitySlider;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

// MARK: Actions

- (IBAction)showOpenPanel:(id)sender
{
    __block NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.allowedFileTypes = NSImage.imageTypes;
    openPanel.allowsMultipleSelection = NO;

    [openPanel beginSheetModalForWindow:_window completionHandler:^(NSModalResponse result) {
        if (result != NSModalResponseOK)
            return;

        NSImage *image = [[NSImage alloc] initWithContentsOfURL:openPanel.URL];
        self->_stretchView.image = image;
        openPanel = nil; // prevent strong ref cycle
    }];
}

- (IBAction)changeViewOpacity:(NSSlider *)sender
{
    _stretchView.opacity = sender.floatValue;
}

@end
