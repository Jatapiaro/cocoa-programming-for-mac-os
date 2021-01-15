//
//  NSMutableArrayExtras.h
//  ManualRaiseMan
//
//  Created by Jacobo Tapia on 8/30/20.
//  Copyright © 2020 Jacobo Tapia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (NSMutableArrayExtras)

- (NSIndexSet *)indexesOfObjectsInArray:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
