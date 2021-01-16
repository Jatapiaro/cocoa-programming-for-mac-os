//
//  Course.m
//  RanchForecast
//
//  Created by Jacobo Tapia de la Rosa on 1/14/21.
//

#import "Course.h"

@implementation Course

- (instancetype)init
{
    return [self initWithTitle:@"" url:[[NSURL alloc] initWithString:@""] startDate:[NSDate now]];
}

- (id)initWithTitle:(NSString *)title url:(NSURL *)url startDate:(NSDate *)startDate
{
    if (!(self = [super init]))
        return nil;

    _title = [title copy];
    _url = url;
    _urlRequest = [NSURLRequest requestWithURL:_url];
    _nextStartDate = startDate;

    return self;
}

@end
