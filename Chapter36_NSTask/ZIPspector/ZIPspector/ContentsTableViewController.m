//
//  ContentsTableViewController.m
//  ZIPspector
//
//  Created by Jacobo Tapia de la Rosa on 7/5/21.
//

#import "ContentsTableViewController.h"

@interface ContentsTableViewController () <NSTableViewDataSource, NSTableViewDelegate>
@property (weak, nonatomic) IBOutlet NSTableView *contentsTableView;
@end

@implementation ContentsTableViewController

- (void)setFilenames:(NSArray<NSString *> *)filenames
{
    _filenames = [filenames copy];
    [_contentsTableView reloadData];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return _filenames.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return _filenames[row];
}

@end
