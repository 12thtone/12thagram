//
//  mediaItemHeightTests.m
//  Blocstagram
//
//  Created by Matt Maher on 12/31/14.
//  Copyright (c) 2014 Matt Maher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Media.h"
#import "MediaTableViewCell.h"

@interface mediaItemHeightTests : XCTestCase

@end

@implementation mediaItemHeightTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testHeightForMediaItem {
    UIImage *testImage = [UIImage imageNamed:@"placeholder.jpg"];
    CGFloat height = testImage.size.height;
    NSLog(@"%f", height);
    
    XCTAssertTrue(height == testImage.size.width), @"The height and width are not equal.";
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
