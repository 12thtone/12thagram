//
//  ComposeCommentViewTests.m
//  Blocstagram
//
//  Created by Matt Maher on 12/31/14.
//  Copyright (c) 2014 Matt Maher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ComposeCommentView.h"

@interface ComposeCommentViewTests : XCTestCase

@end

@implementation ComposeCommentViewTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testThatComposeCommentViewYesTextWorks {
    ComposeCommentView *testComment = [[ComposeCommentView alloc] init];
    testComment.text = @"Text?";
    XCTAssertTrue(testComment.isWritingComment == YES, @"There is a problem.");
}

- (void)testThatComposeCommentViewNoTextWorks {
    ComposeCommentView *testComment = [[ComposeCommentView alloc] init];
    testComment.text = nil;
    XCTAssertTrue(testComment.isWritingComment == NO, @"There is a problem.");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
