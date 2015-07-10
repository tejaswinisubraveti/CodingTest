//
//  WeatherAppTestCases.m
//  WeatherApp
//
//  Created by Tejaswini Subraveti on 9/07/2015.
//  Copyright (c) 2015 Tejaswini Subraveti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "WeatherAppDataDownloader.h"
#import <CoreLocation/CoreLocation.h>

@interface WeatherAppTestCases : XCTestCase

@end

@implementation WeatherAppTestCases

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testService {
    XCTestExpectation *downloadExpectation = [self expectationWithDescription:@"service success"];

    [[WeatherAppDataDownloader sharedDownloader]dataForLocation:[[CLLocation alloc] initWithLatitude:37.332331 longitude:-122.031219] completion:^(WeatherModel *weather, NSError *error) {
        if (weather) {
            // Success
            XCTAssert(1);
            [downloadExpectation fulfill];
        } else {
            XCTFail(@"Expectation Failed with error: %@", error);
            // Failure
        }
    }];

    
    // The test will pause here, running the run loop, until the timeout is hit
    // or all expectations are fulfilled.
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        if(error)
        {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}
@end
