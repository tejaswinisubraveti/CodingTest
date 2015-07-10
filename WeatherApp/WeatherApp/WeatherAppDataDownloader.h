//
//  WeatherAppDownloader.h
//  WeatherApp
//
//  Created by Tejaswini Subraveti on 9/07/2015.
//  Copyright (c) 2015 Tejaswini Subraveti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherModel.h"
#import <CoreLocation/CoreLocation.h>
typedef void (^WeatherAppDataDownloadCompletion)(WeatherModel *model, NSError *error);

@interface WeatherAppDataDownloader : NSObject

+ (WeatherAppDataDownloader *)sharedDownloader;

- (void)dataForLocation:(CLLocation *)location completion:(WeatherAppDataDownloadCompletion)completion;

@end
