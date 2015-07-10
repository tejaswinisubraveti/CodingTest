//
//  WeatherModel.h
//  WeatherApp
//
//  Created by Tejaswini Subraveti on 9/07/2015.
//  Copyright (c) 2015 Tejaswini Subraveti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherModel : NSObject

@property (strong, nonatomic) NSString      *icon;
@property (strong, nonatomic) NSString      *summary;
@property (strong, nonatomic) NSString      *temperature;
@property (strong, nonatomic) NSString      *timeZone;

- (void)assignWithWeatherData: (NSDictionary *)weatherData;

@end
