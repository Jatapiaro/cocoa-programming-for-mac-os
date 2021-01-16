//
//  ScheduleFetcher.m
//  RanchForecast
//
//  Created by Jacobo Tapia de la Rosa on 1/14/21.
//

#import "ScheduleFetcher.h"

#import "Course.h"

@implementation ScheduleFetcherResponse

- (instancetype)init
{
    return [self initWithResult:ScheduleFetcherResultFailure error:[NSError errorWithDomain:@"ScheduleFetcher" code:1 userInfo:[NSDictionary dictionaryWithObject:@"Bad init" forKey:NSLocalizedDescriptionKey]]];
}

- (id)initWithResult:(ScheduleFetcherResult)result error:(NSError *)error
{
    if (!(self = [super init]))
        return nil;

    _result = result;
    _error = error;

    return self;
}

@end

@implementation ScheduleFetcher {
    NSURLSession *_session;
    NSURL *_url;
    NSMutableArray<Course *> *_courses;
}

- (instancetype)init
{
    if (!(self = [super init]))
        return nil;

    _session = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration];
    _url = [[NSURL alloc] initWithString:@"https://api.npoint.io/103c08eec5963d55792e"];
    _courses = [NSMutableArray array];

    return self;
}

// MARK: Fetching Operation

- (void)fetchCoursesWithCompletionHandler:(void(^)(ScheduleFetcherResponse *))completionHandler
{
    NSURLRequest *request = [NSURLRequest requestWithURL:_url];

    NSURLSessionDataTask *dataTask = [_session dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse * response, NSError *error) {

        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse) {
            NSInteger statusCode = httpResponse.statusCode;
            if (statusCode == 200)
                [self _completeFetchOperationWithResponse:[self _resultFromData:data] completionHandler:completionHandler];
            else {
                NSError *operationError = [self _errorWithCode:1 localizedDescription:[NSString stringWithFormat:@"Bad status code %ld.", statusCode]];
                ScheduleFetcherResponse *response = [[ScheduleFetcherResponse alloc] initWithResult:ScheduleFetcherResultFailure error:operationError];
                [self _completeFetchOperationWithResponse:response completionHandler:completionHandler];
            }
        } else {
            NSError *operationError = [self _errorWithCode:1 localizedDescription:@"Unexpected response object."];
            ScheduleFetcherResponse *response = [[ScheduleFetcherResponse alloc] initWithResult:ScheduleFetcherResultFailure error:operationError];
            [self _completeFetchOperationWithResponse:response completionHandler:completionHandler];
        }
    }];
    [dataTask resume];
}

- (void)_completeFetchOperationWithResponse:(ScheduleFetcherResponse *)response completionHandler:(void(^)(ScheduleFetcherResponse *))completionHandler
{
    // We do this since NSURLSessionDataTask calls its completion hanlder in a different queue rather than the
    // main one.
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        completionHandler(response);
    }];
}

- (NSError *)_errorWithCode:(NSInteger)code localizedDescription:(NSString *)description
{
    return [NSError errorWithDomain:@"ScheduleFetcher" code:code userInfo:[NSDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey]];
}

// MARK: Parsing Operations

- (NSArray<Course *> *)courses
{
    return _courses.copy;
}

- (ScheduleFetcherResponse *)_resultFromData:(NSData *)data
{
    NSError *error;
    NSDictionary *topLevelDictionary = [NSJSONSerialization
                                        JSONObjectWithData:data
                                        options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves
                                        error:&error];

    _courses = [NSMutableArray array];
    if (!topLevelDictionary)
        return [[ScheduleFetcherResponse alloc] initWithResult:ScheduleFetcherResultFailure error:error];

    NSArray<NSDictionary *> *courseDicts = [topLevelDictionary objectForKey:@"courses"];
    if (!courseDicts)
        return [[ScheduleFetcherResponse alloc] initWithResult:ScheduleFetcherResultFailure error:error];;

    for (NSDictionary *courseDict in courseDicts)
        [_courses addObject:[self _courseFromDictionary:courseDict]];

    return [[ScheduleFetcherResponse alloc] initWithResult:ScheduleFetcherResultSuccess error:error];
}

- (Course *)_courseFromDictionary:(NSDictionary *)dictionary
{
    NSString *title = [dictionary objectForKey:@"title"];
    NSString *urlString = [dictionary objectForKey:@"url"];

    // Upcoming is an array of dicts
    NSArray *upcomingArray = [dictionary objectForKey:@"upcoming"];
    NSDictionary *nextUpcomingDictionary = upcomingArray.firstObject;
    NSString *nextUpcomingDateString = [nextUpcomingDictionary objectForKey:@"start_date"];

    NSURL *url = [NSURL URLWithString:urlString];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *nextStartDate = [dateFormatter dateFromString:nextUpcomingDateString];

    return [[Course alloc] initWithTitle:title url:url startDate:nextStartDate];
}

@end
