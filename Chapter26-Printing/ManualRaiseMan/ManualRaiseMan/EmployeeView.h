//
//  EmployeeView.h
//  ManualRaiseMan
//
//  Created by Jacobo Tapia de la Rosa on 1/12/21.
//  Copyright © 2021 Jacobo Tapia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Employee;

NS_ASSUME_NONNULL_BEGIN

@interface EmployeeView : NSView

- (id)initWithEmployees:(NSArray<Employee *> *)employees;

@end

NS_ASSUME_NONNULL_END
