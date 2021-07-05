//
//  ContentsTableViewController.h
//  ZIPspector
//
//  Created by Jacobo Tapia de la Rosa on 7/5/21.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContentsTableViewController : NSViewController
@property (nonatomic, copy) NSArray<NSString *> *filenames;
@end

NS_ASSUME_NONNULL_END
