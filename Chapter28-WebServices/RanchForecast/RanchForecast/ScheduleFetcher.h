//
//  ScheduleFetcher.h
//  RanchForecast
//
//  Created by Jacobo Tapia de la Rosa on 1/14/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ScheduleFetcherResult) {
    ScheduleFetcherResultSuccess,
    ScheduleFetcherResultFailure,
};

@interface ScheduleFetcherResponse : NSObject

@property (nonatomic, readonly) ScheduleFetcherResult result;
@property (nonatomic, readonly) NSError *error;

- (id)initWithResult:(ScheduleFetcherResult)result error:(NSError *)error NS_DESIGNATED_INITIALIZER;

@end

@class Course;
@interface ScheduleFetcher : NSObject

@property (nonatomic, readonly, copy) NSArray<Course *> *courses;
- (void)fetchCoursesWithCompletionHandler:(void(^)(ScheduleFetcherResponse *))completionHandler;

@end

NS_ASSUME_NONNULL_END
