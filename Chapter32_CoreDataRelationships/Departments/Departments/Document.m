//
//  Document.m
//  Departments
//
//  Created by Jacobo Tapia de la Rosa on 1/23/21.
//

#import "Document.h"
#import "DepartmentViewController.h"
#import "EmployeesViewController.h"

@interface Document ()
@property (nonatomic, weak) IBOutlet NSBox *box;
@property (nonatomic, weak) IBOutlet NSPopUpButton *popUp;
@end

@implementation Document {
    NSMutableArray<ManagingViewController *> *_viewControllers;
}

- (instancetype)init {
    if (!(self = [super init]))
        return nil;

    _viewControllers = [NSMutableArray array];

    DepartmentViewController *departmentsViewController = [[DepartmentViewController alloc] initWithObjectContext:self.managedObjectContext];
    [_viewControllers addObject:departmentsViewController];

    EmployeesViewController *employeesViewController = [[EmployeesViewController alloc] initWithObjectContext:self.managedObjectContext];
    [_viewControllers addObject:employeesViewController];

    return self;
}

+ (BOOL)autosavesInPlace {
    return YES;
}

- (NSString *)windowNibName {
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)windowController
{
    NSMenu *menu = _popUp.menu;

    for (NSInteger i = 0; i < _viewControllers.count; i++) {
        NSViewController *vc = _viewControllers[i];
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:vc.title action:@selector(_changeViewController:) keyEquivalent:@""];
        item.tag = i;

        [menu addItem:item];
    }

    // Initially show the first view controller
    [self _displayViewController:_viewControllers.firstObject];
}

- (void)_changeViewController:(NSMenuItem *)sender
{
    [self _displayViewController:_viewControllers[sender.tag]];
}

- (void)_displayViewController:(ManagingViewController *)viewController
{
    // Try to end editing
    NSWindow *window = _box.window;
    BOOL ended = [window makeFirstResponder:window];
    if (!ended) {
        NSBeep();
        return;
    }

    NSView *view = viewController.view;

    // Compute the new window frame
    NSSize currentSize = _box.contentView.frame.size;
    NSSize newSize = view.frame.size;

    float deltaWidth = newSize.width - currentSize.width;
    float deltaHeight = newSize.width - currentSize.height;

    NSRect windowFrame = window.frame;
    windowFrame.size.height += deltaHeight;
    windowFrame.origin.y -= deltaHeight;
    windowFrame.size.width += deltaWidth;

    // Clear the box for resizing
    _box.contentView = nil;
    [window setFrame:windowFrame display:YES animate:YES];

    // Put the view in the box
    _box.contentView = view;
}

@end
