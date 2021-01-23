//
//  DepartmentViewController.h
//  Departments
//
//  Created by Jacobo Tapia de la Rosa on 1/23/21.
//

#import "ManagingViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DepartmentViewController : ManagingViewController

- (id)initWithObjectContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END
