//
//  TypingTutorNSStringExtras.m
//  TypingTutor
//
//  Created by Jacobo Tapia de la Rosa on 1/8/21.
//

#import "TypingTutorNSStringExtras.h"

@implementation NSString (TypingTutorNSStringExtras)

- (NSString *)tt_firstLetter
{
    if (!self.length)
        return @" ";

    if (self.length < 2)
        return self;

    return [self substringWithRange:NSMakeRange(0, 1)];
}

@end
