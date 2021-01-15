//
//  MainWindowController.m
//  RanchForecast
//
//  Created by Jacobo Tapia de la Rosa on 1/14/21.
//

#import "MainWindowController.h"

#import "Course.h"
#import "ScheduleFetcher.h"


@interface MainWindowController () <NSTableViewDataSource, NSTableViewDelegate>
@property (nonatomic, weak) IBOutlet NSTableView *coursesTable;
@end

@implementation MainWindowController {
    ScheduleFetcher *_scheduleFetcher;
    NSArray<Course *> *_courses;
}

- (NSNibName)windowNibName
{
    return @"MainWindowController";
}

- (void)windowDidLoad
{
    [super windowDidLoad];

    _coursesTable.target = self;
    _coursesTable.doubleAction = @selector(_openClass);
    [self _reloadData];
}

- (void)_openClass
{
    Course *course = _courses[_coursesTable.selectedRow];
    [NSWorkspace.sharedWorkspace openURL:course.url];
}

- (void)_reloadData
{
    if (!_scheduleFetcher)
        _scheduleFetcher = [[ScheduleFetcher alloc] init];

    [_scheduleFetcher fetchCoursesWithCompletionHandler:^(ScheduleFetcherResponse *response) {
        if (response.result == ScheduleFetcherResultSuccess) {
            self->_courses = self->_scheduleFetcher.courses;
            [self->_coursesTable reloadData];
        } else
            NSLog(@"Error: %@", response.error);
    }];
}

// MARK: NSTableViewDataSource and NSTableViewDelegate

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return _courses.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    BOOL isFirstColumn = tableColumn == tableView.tableColumns.firstObject;
    NSUserInterfaceItemIdentifier columnIdentifier =  isFirstColumn ? @"startDateCell" : @"titleCell";

    NSTableCellView *cellView = [tableView makeViewWithIdentifier:columnIdentifier owner:nil];
    Course *course = _courses[row];

    if (isFirstColumn)
        cellView.textField.objectValue = course.nextStartDate;
    else
        cellView.textField.stringValue = course.title;

    return cellView;
}

@end
