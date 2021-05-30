//
//  Department+CoreDataProperties.m
//  Departments
//
//  Created by Jacobo Tapia on 5/30/21.
//
//

#import "Department+CoreDataProperties.h"

@implementation Department (CoreDataProperties)

+ (NSFetchRequest<Department *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Department"];
}

@dynamic name;
@dynamic employees;
@dynamic manager;

- (void)addEmployeesObject:(Employee *)object
{
    [self _changeEmployeesValueWithEmployee:object mutation:NSKeyValueUnionSetMutation];
}

- (void)removeEmployeesObject:(Employee *)object
{
    Employee *manager = self.manager;
    if (manager == object)
        self.manager = nil;
    
    [self _changeEmployeesValueWithEmployee:object mutation:NSKeyValueMinusSetMutation];
}

- (void)_changeEmployeesValueWithEmployee:(Employee *)employee mutation:(NSKeyValueSetMutationKind)mutation
{
    NSSet *set = [NSSet setWithObject:employee];
    [self willChangeValueForKey:@"employees" withSetMutation:mutation usingObjects:set];
    
    id keyPrimitive = [self primitiveValueForKey:@"employees"];
    if (mutation == NSKeyValueUnionSetMutation)
        [keyPrimitive addObject:employee];
    else
        [keyPrimitive removeObject:employee];
    
    [self didChangeValueForKey:@"employees" withSetMutation:mutation usingObjects:set];
}


@end
