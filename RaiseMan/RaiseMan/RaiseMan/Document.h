//
//  Document.h
//  RaiseMan
//
//  Created by Jacobo Tapia on 19/07/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class Person;

@interface Document : NSDocument

@property (nonatomic, copy) NSMutableArray *employees;

@end

