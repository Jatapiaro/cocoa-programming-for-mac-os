//
//  Employee.h
//  ManualRaiseMan
//
//  Created by Jacobo Tapia on 16/07/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Employee : NSObject <NSSecureCoding>

@property (readwrite, copy) NSString *name;
@property (readwrite) float expectedRaise;

@end

NS_ASSUME_NONNULL_END
