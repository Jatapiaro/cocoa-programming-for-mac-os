//
//  ManagingViewController.m
//  Departments
//
//  Created by Jacobo Tapia de la Rosa on 1/23/21.
//

#import "ManagingViewController.h"

@interface ManagingViewController ()
@end

@implementation ManagingViewController

- (id)initWithTitle:(NSString *)title objectContext:(NSManagedObjectContext *)objectContext
{
    if (!(self = [super init]))
        return nil;

    self.title = title;
    _managedObjectContext = objectContext;

    return self;
}

@end
