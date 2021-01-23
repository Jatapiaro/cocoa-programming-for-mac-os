//
//  DepartmentViewController.m
//  Departments
//
//  Created by Jacobo Tapia de la Rosa on 1/23/21.
//

#import "DepartmentViewController.h"

@interface DepartmentViewController ()
@end

@implementation DepartmentViewController

- (instancetype)initWithObjectContext:(NSManagedObjectContext *)context
{
    return [super initWithTitle:@"Departments" objectContext:context];
}

@end
