//
//  EmployeeView.m
//  ManualRaiseMan
//
//  Created by Jacobo Tapia de la Rosa on 1/12/21.
//  Copyright © 2021 Jacobo Tapia. All rights reserved.
//

#import "EmployeeView.h"
#import "Employee.h"

@implementation EmployeeView {
    NSArray *_employees;
    NSMutableDictionary *_attributes;
    float _lineHeight;
    NSRect _pageRect;
    NSInteger _linesPerPage;
    NSInteger _currentPage;
}

- (id)initWithEmployees:(NSArray<Employee *> *)employees
{
    if (!(self = [super initWithFrame:NSMakeRect(0, 0, 700, 700)]))
        return nil;

    _employees = [employees copy];

    NSFont *font = [NSFont fontWithName:@"Monaco" size:12.0];
    _attributes = [NSMutableDictionary dictionaryWithObject:font forKey:NSFontAttributeName];

    _lineHeight = font.capHeight * 1.7;

    return self;
}

- (BOOL)knowsPageRange:(NSRangePointer)range
{
    NSPrintOperation *printOperation = NSPrintOperation.currentOperation;
    NSPrintInfo *printInfo = printOperation.printInfo;

    // Where I can Draw
    _pageRect = printInfo.imageablePageBounds;

    NSRect newFrame;
    newFrame.origin = NSZeroPoint;
    newFrame.size = printInfo.paperSize;
    self.frame = newFrame;

    // How many lines per page
    _linesPerPage = _pageRect.size.height / _lineHeight;

    // Pages are 1-based
    range->location = 1;

    // How many pages will take
    range->length = _employees.count / _linesPerPage;
    if (_employees.count % _linesPerPage)
        range->length = range->length + 1;

    return YES;
}

- (NSRect)rectForPage:(NSInteger)page
{
    // Note the current page
    _currentPage = page - 1;

    // Return the same page rect everytime
    return _pageRect;
}

- (BOOL)isFlipped
{
    return YES;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSRect nameRect;
    NSRect raiseRect;

    raiseRect.size.height = nameRect.size.height = _lineHeight;
    nameRect.origin.x = _pageRect.origin.x;
    nameRect.size.width = 200.0;

    raiseRect.origin.x = NSMaxX(nameRect);
    raiseRect.size.width = 100;

    for (NSInteger i = 0; i < _linesPerPage; i++) {
        NSInteger index = (_currentPage * _linesPerPage) + i;
        if (index >= _employees.count)
            break;

        Employee *e = _employees[index];

        // Draw index and name
        nameRect.origin.y = _pageRect.origin.y + (i * _lineHeight);
        NSString *nameString = [NSString stringWithFormat:@"%ld %@", (long)index, e.name];
        [nameString drawInRect:nameRect withAttributes:_attributes];

        raiseRect.origin.y = nameRect.origin.y;
        NSString *raiseString = [NSString stringWithFormat:@"%4.1f%%", e.expectedRaise];
        [raiseString drawInRect:raiseRect withAttributes:_attributes];
    }

    // Divide current page rect in two
    
    NSRect pageNumberRect;
    NSRect rem;
    NSDivideRect(_pageRect, &pageNumberRect, &rem, _lineHeight, NSMaxYEdge);

    NSString *currentPageString = [NSString stringWithFormat:@"Page %li", (long)_currentPage];
    NSSize currentPageStringSize = [currentPageString sizeWithAttributes:_attributes];

    NSRect currentPageNumberRect = pageNumberRect;
    pageNumberRect.origin.x = NSMaxX(currentPageNumberRect) - currentPageStringSize.width;

    [currentPageString drawInRect:pageNumberRect withAttributes:_attributes];
}

@end
