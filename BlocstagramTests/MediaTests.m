//
//  MediaTests.m
//  Blocstagram
//
//  Created by Matt Maher on 12/31/14.
//  Copyright (c) 2014 Matt Maher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Media.h"

@interface MediaTests : XCTestCase

@end

@implementation MediaTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testThatInitializationWorks {
    NSDictionary *sourceDictionary = @{@"id": @"8675309",
                                       @"url" : @"http://www.example.com/example.jpg"};
    Media *testMedia = [[Media alloc] initWithDictionary:sourceDictionary];
    
    XCTAssertEqualObjects(testMedia.idNumber, sourceDictionary[@"id"], @"The ID number should be equal");
    XCTAssertEqualObjects(testMedia.mediaURL, sourceDictionary[@"user_has_liked"], @"The url should be equal");
    XCTAssertEqualObjects(testMedia.mediaURL, sourceDictionary[@"count"], @"The url should be equal");
    XCTAssertEqualObjects(testMedia.mediaURL, sourceDictionary[@"data"], @"The url should be equal");
    XCTAssertEqualObjects(testMedia.mediaURL, sourceDictionary[@"caption"], @"The url should be equal");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
