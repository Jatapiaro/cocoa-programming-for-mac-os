//
//  ManagingViewController.h
//  Departments
//
//  Created by Jacobo Tapia de la Rosa on 1/23/21.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface ManagingViewController : NSViewController

- (id)initWithTitle:(NSString *)title objectContext:(NSManagedObjectContext *)objectContext;

@property (readonly) NSManagedObjectContext *managedObjectContext;

@end

NS_ASSUME_NONNULL_END
