//
//  Department+CoreDataProperties.h
//  Departments
//
//  Created by Jacobo Tapia on 5/30/21.
//
//

#import "Department+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Department (CoreDataProperties)

+ (NSFetchRequest<Department *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) Employee *employees;
@property (nullable, nonatomic, retain) Employee *manager;

- (void)addEmployeesObject:(Employee *)object;
- (void)removeEmployeesObject:(Employee *)object;

@end

NS_ASSUME_NONNULL_END
