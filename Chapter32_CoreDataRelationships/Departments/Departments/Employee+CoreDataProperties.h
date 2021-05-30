//
//  Employee+CoreDataProperties.h
//  Departments
//
//  Created by Jacobo Tapia on 5/30/21.
//
//

#import "Employee+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Employee (CoreDataProperties)

+ (NSFetchRequest<Employee *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *firstName;
@property (nullable, nonatomic, copy) NSString *lastName;
@property (nullable, nonatomic, retain) Department *department;

@property (nonatomic, readonly, copy) NSString *fullName;

@end

NS_ASSUME_NONNULL_END
