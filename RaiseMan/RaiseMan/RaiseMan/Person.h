//
//  Person.h
//  RaiseMan
//
//  Created by Jacobo Tapia on 19/07/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject <NSSecureCoding>

@property (copy) NSString *name;
@property float expectedRaise;

@end

NS_ASSUME_NONNULL_END
