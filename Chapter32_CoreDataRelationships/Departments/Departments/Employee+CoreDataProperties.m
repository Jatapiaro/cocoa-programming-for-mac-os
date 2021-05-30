//
//  Employee+CoreDataProperties.m
//  Departments
//
//  Created by Jacobo Tapia on 5/30/21.
//
//

#import "Employee+CoreDataProperties.h"

@implementation Employee (CoreDataProperties)

+ (NSFetchRequest<Employee *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
}

@dynamic firstName;
@dynamic lastName;
@dynamic department;

- (NSString *)fullName
{
    if (!self.lastName)
        return self.firstName;
    
    if (!self.firstName)
        return self.lastName;
    
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

+ (NSSet<NSString *> *)keyPathsForValuesAffectingFullName
{
    return [NSSet setWithObjects:@"lastName", @"firstName", nil];
}

@end
