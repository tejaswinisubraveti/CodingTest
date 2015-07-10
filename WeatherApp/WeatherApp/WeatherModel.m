//
//  WeatherModel.m
//  WeatherApp
//
//  Created by Tejaswini Subraveti on 9/07/2015.
//  Copyright (c) 2015 Tejaswini Subraveti. All rights reserved.
//

#import "WeatherModel.h"

@implementation WeatherModel

- (void)assignWithWeatherData: (NSDictionary *)weatherData {
    NSDictionary *currentData = weatherData[@"currently"];
    self.icon = currentData[@"icon"];
    self.summary = currentData[@"summary"];
    self.temperature = [currentData[@"temperature"] stringValue];
    self.timeZone = weatherData[@"timezone"];
}

@end