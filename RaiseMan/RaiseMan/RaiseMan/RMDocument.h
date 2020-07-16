//
//  RMDocument.h
//  RaiseMan
//
//  Created by Jacobo Tapia on 16/07/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RMDocument : NSDocument

@property (nonatomic, copy) NSMutableArray *employees;

- (void)setEmployees:(NSMutableArray *)employees;

@end

