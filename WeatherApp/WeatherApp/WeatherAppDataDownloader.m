//
//  WeatherAppDownloader.m
//  WeatherApp
//
//  Created by Tejaswini Subraveti on 9/07/2015.
//  Copyright (c) 2015 Tejaswini Subraveti. All rights reserved.
//

#import "WeatherAppDataDownloader.h"

@interface WeatherAppDataDownloader()

@property (nonatomic) NSString      *key;

@end

@implementation WeatherAppDataDownloader


- (instancetype)init
{
    [NSException raise:@"SOLSingletonException" format:@"WeatherAppDataDownloader cannot be initialized using init"];
    return nil;
}

#pragma mark Initializing a WeatherAppDataDownloader

+ (WeatherAppDataDownloader *)sharedDownloader
{
    static WeatherAppDataDownloader *sharedDownloader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#warning Project bundle must contain a file name "API_KEY" containing a valid API key
        NSString *path = [[NSBundle mainBundle]pathForResource:@"API_KEY" ofType:@""];
        NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSString *apiKey = [content stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        sharedDownloader = [[WeatherAppDataDownloader alloc]initWithAPIKey:apiKey];
    });
    return sharedDownloader;
}

- (instancetype)initWithAPIKey:(NSString *)key
{
    if(self = [super init]) {
        self.key = key;
    }
    return self;
}

#pragma mark Using a SOLWundergroundDownloader

- (void)dataForLocation:(CLLocation *)location completion:(WeatherAppDataDownloadCompletion)completion
{
    //  Requests are not made if the (location and completion) or the delegate is nil
    if(!location || !completion) {
        return;
    }
    
    //  Turn on the network activity indicator in the status bar
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    //  Get the url request
    NSURLRequest *request = [self urlRequestForLocation:location];
    
    //  Make an asynchronous request to the url
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        WeatherModel *model = [[WeatherModel alloc]init];
        [model assignWithWeatherData:responseObject];
        completion(model, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completion(nil, error);
    }];
    [[NSOperationQueue mainQueue] addOperation:op];

//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:
//     ^ (NSURLResponse * response, NSData *data, NSError *connectionError) {
//         
//         //  Report connection errors as download failures to the delegate
//         if(connectionError) {
//             completion(nil, connectionError);
//         } else {
//             
//             //  Serialize the downloaded JSON document and return the weather data to the delegate
//             @try {
//                 NSDictionary *JSON = [self serializedData:data];
//                 SOLWeatherData *weatherData = [self dataFromJSON:JSON];
//                 if(placemark) {
//                     weatherData.placemark = placemark;
//                     completion(weatherData, connectionError);
//                 } else {
//                     //  Reverse geocode the given location in order to get city, state, and country
//                     [self.geocoder reverseGeocodeLocation:location completionHandler: ^ (NSArray *placemarks, NSError *error) {
//                         if(placemarks) {
//                             weatherData.placemark = [placemarks lastObject];
//                             completion(weatherData, error);
//                         } else if(error) {
//                             completion(nil, error);
//                         }
//                     }];
//                 }
//             }
//             
//             //  Report any failures during serialization as download failures to the delegate
//             @catch (NSException *exception) {
//                 completion(nil, [NSError errorWithDomain:@"SOLWundergroundDownloader Internal State Error" code:-1 userInfo:nil]);
//             }
//             
//             //  Always turn off the network activity indicator after requests are fulfilled
//             @finally {
//                 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//             }
//         }
//     }];
}

- (NSURLRequest *)urlRequestForLocation:(CLLocation *)location
{
    static NSString *baseURL =  @"https://api.forecast.io/forecast/";
    CLLocationCoordinate2D coordinates = location.coordinate;
    NSString *requestURL = [NSString stringWithFormat:@"%@%@/%f,%f", baseURL, self.key,
                            coordinates.latitude, coordinates.longitude];
    NSURL *url = [NSURL URLWithString:requestURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    return request;
}

@end

