//
//  EmployeesViewController.m
//  Departments
//
//  Created by Jacobo Tapia de la Rosa on 1/23/21.
//

#import "EmployeesViewController.h"

@interface EmployeesViewController ()

@end

@implementation EmployeesViewController

- (instancetype)initWithObjectContext:(NSManagedObjectContext *)context
{
    return [super initWithTitle:@"Employees" objectContext:context];
}

@end
