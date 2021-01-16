//
//  ColorFormatter.m
//  TypingTutor
//
//  Created by Jacobo Tapia de la Rosa on 1/15/21.
//

#import "ColorFormatter.h"
#import <Cocoa/Cocoa.h>

@implementation ColorFormatter {
    NSColorList *_colorList;
}

- (instancetype)init
{
    if (!(self = [super init]))
        return nil;

    _colorList = [NSColorList colorListNamed:@"Apple"];

    return self;
}

- (NSString *)_firstColorKeyForPartialString:(NSString *)partialString
{
    if (!partialString.length)
        return nil;

    for (NSString *color in _colorList.allKeys) {
        NSRange whereFound = [color rangeOfString:partialString options:NSCaseInsensitiveSearch];

        if (whereFound.location == 0 && whereFound.length > 0)
            return color;
    }

    return nil;
}

- (NSString *)stringForObjectValue:(id)obj
{
    if (![obj isKindOfClass:NSColor.class])
        return nil;

    // Convert to an RGB color space
    NSColor *color = [obj colorUsingColorSpace:NSColorSpace.genericRGBColorSpace];

    // Get components as floats between 0 and 1
    CGFloat red, green, blue;
    [color getRed:&red green:&green blue:&blue alpha:nil];

    // Initialize the distance to something large
    float minDistance = 3.0;
    NSString *closestKey = nil;

    for (NSString *key in _colorList.allKeys) {
        NSColor *c = [_colorList colorWithKey:key];
        CGFloat r, g, b;
        [c getRed:&r green:&g blue:&b alpha:nil];

        // How far apart are color and c
        float dist = pow(red - r, 2) + pow(green - g, 2) + pow(blue - b, 2);

        // Is this the closes yet
        if (dist < minDistance) {
            minDistance = dist;
            closestKey = key;
        }
    }

    return closestKey;
}

- (NSAttributedString *)attributedStringForObjectValue:(id)obj withDefaultAttributes:(NSDictionary<NSAttributedStringKey,id> *)attrs
{
    NSString *match = [self stringForObjectValue:obj];
    if (!match)
        return nil;

    NSDictionary<NSAttributedStringKey,id> *attributes = [NSMutableDictionary dictionaryWithDictionary:attrs];
    [attributes setValue:obj forKey:NSForegroundColorAttributeName];

    return [[NSAttributedString alloc] initWithString:match attributes:attributes];
}

- (BOOL)getObjectValue:(out id  _Nullable __autoreleasing *)obj forString:(NSString *)string errorDescription:(out NSString * _Nullable __autoreleasing *)error
{
    NSString *matchingKey = [self _firstColorKeyForPartialString:string];
    if (matchingKey) {
        *obj = [_colorList colorWithKey:matchingKey];
        return YES;
    }

    if (error)
        *error = [NSString stringWithFormat:@"%@ is not a color", string];

    return NO;
}

/*- (BOOL)isPartialStringValid:(NSString *)partialString newEditingString:(NSString * _Nullable __autoreleasing *)newString errorDescription:(NSString * _Nullable __autoreleasing *)error
{
    if (!partialString.length)
        return YES;

    NSString *match = [self _firstColorKeyForPartialString:partialString];
    if (match)
        return YES;

    if (error)
        *error = @"No such color";

    return NO;
}*/

- (BOOL)isPartialStringValid:(NSString * _Nonnull __autoreleasing *)partialStringPtr proposedSelectedRange:(NSRangePointer)proposedSelRangePtr originalString:(NSString *)origString originalSelectedRange:(NSRange)origSelRange errorDescription:(NSString * _Nullable __autoreleasing *)error
{
    NSString *partialString = *partialStringPtr;
    if (!partialString.length)
        return YES;

    NSString *match = [self _firstColorKeyForPartialString:partialString];
    if (!match)
        return NO;

    // If this would not move the beggining of a selection it is a delete
    if (origSelRange.location == proposedSelRangePtr->location)
        return YES;

    // If partial string is shorter than the match, provide the match
    // and set the selection
    if (match.length != partialString.length) {
        proposedSelRangePtr->location = partialString.length;
        proposedSelRangePtr->length = match.length - proposedSelRangePtr->length;
        *partialStringPtr = match;

        return NO;
    }

    return YES;
}

@end
