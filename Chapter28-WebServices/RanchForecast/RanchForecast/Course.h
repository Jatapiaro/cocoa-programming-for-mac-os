//
//  Course.h
//  RanchForecast
//
//  Created by Jacobo Tapia de la Rosa on 1/14/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Course : NSObject

@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly) NSURL *url;
@property (nonatomic, readonly) NSDate *nextStartDate;
@property (nonatomic, readonly) NSURLRequest *urlRequest;

- (id)initWithTitle:(NSString *)title url:(NSURL *)url startDate:(NSDate *)startDate NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
