//
//  ViewController.m
//  WeatherApp
//
//  Created by Tejaswini Subraveti on 6/07/2015.
//  Copyright (c) 2015 Tejaswini Subraveti. All rights reserved.
//
// sky image from https://niried.files.wordpress.com/2014/07/blue1web.jpg?w=360&h=360&crop=1
// SkyIcons open source github project https://github.com/zachwaugh/cocoa-skycons
// AFNetworking open source github
// SVProgressHud open source pods

#import "ViewController.h"
#import "SKYIconView.h"
#import "WeatherAppDataDownloader.h"

#define ICON_SIZE 96

@interface ViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelLocation;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeZone;
@property (weak, nonatomic) IBOutlet UILabel *labelTemp;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;

@property (strong, nonatomic) CLLocationManager     *locationManager;

@property (strong) NSMutableArray *icons;

@property (strong, nonatomic) CLGeocoder                    *geocoder;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.geocoder = [[CLGeocoder alloc]init];
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    self.locationManager.distanceFilter = 3000;
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

- (void)updateUIwithWeather:(WeatherModel *)weather {
    
    //    NSArray *types = @[@"SKYClearDay", @"SKYClearNight", @"SKYPartlyCloudyDay", @"SKYPartlyCloudyNight", @"SKYCloudy", @"SKYRain", @"SKYSleet", @"SKYSnow", @"SKYWind", @"SKYFog"];
    NSArray *weatherApptypes = @[@"clear-day", @"clear-night", @"partly-cloudy-day", @"partly-cloudy-night", @"cloudy", @"rain", @"sleet", @"snow", @"wind", @"fog"];
    self.labelLocation.text = weather.summary;
    self.labelTimeZone.text = weather.timeZone;
    self.labelTemp.text = weather.temperature;
    NSInteger index = [weatherApptypes indexOfObject:weather.icon];
    UIView *container = self.view;
    CGRect frame = CGRectMake((self.view.frame.size.width - ICON_SIZE)/2, (self.view.frame.size.height - ICON_SIZE)/2 - ICON_SIZE, ICON_SIZE, ICON_SIZE);
    
    SKYIconType type = index;
    SKYIconView *icon = [[SKYIconView alloc] initWithFrame:frame];
    icon.type = type;
    [container addSubview:icon];
    [self.icons addObject:icon];
    
}
#pragma mark CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if([CLLocationManager locationServicesEnabled]){
        
        NSLog(@"Location Services Enabled");
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
            
        }
    }
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // Send the user to the Settings for this app
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.locationManager stopUpdatingLocation];
    [SVProgressHUD showWithStatus:@"Loading Forecast data"];
    [self.geocoder reverseGeocodeLocation:[locations lastObject] completionHandler:^(NSArray *placemarks, NSError *error) {
        if(error){
            NSLog(@"%@", [error localizedDescription]);
        }
        
        CLPlacemark *placemark = [placemarks lastObject];
        
        NSString *startAddressString = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                        placemark.subThoroughfare, placemark.thoroughfare,
                                        placemark.postalCode, placemark.locality,
                                        placemark.administrativeArea,
                                        placemark.country];
        
        self.labelAddress.text = startAddressString;
    }];
    
    [[WeatherAppDataDownloader sharedDownloader]dataForLocation:[locations lastObject] completion:^(WeatherModel *weather, NSError *error) {
        [SVProgressHUD dismiss];
        if (weather) {
            // Success
            [self updateUIwithWeather:weather];
        } else {
            // Failure
        }
    }];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //  If the local weather view has no data and a location could not be determined, show a failure message
    self.labelLocation.text = @"Location fetch failed";
}
@end
