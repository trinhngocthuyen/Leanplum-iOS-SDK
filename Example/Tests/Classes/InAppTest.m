//
//  InAppTest.m
//  Leanplum-SDK_Tests
//
//  Created by Alexis Oyama on 2/22/18.
//  Copyright © 2018 Leanplum. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <FBSnapshotTestCase/FBSnapshotTestCase.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <OHHTTPStubs/OHPathHelpers.h>
#import "LeanplumHelper.h"
#import "AppDelegate.h"

@interface A_InAppTest : FBSnapshotTestCase

@end

@implementation A_InAppTest

- (void)setUp {
    [super setUp];
    [LeanplumHelper setup_method_swizzling];
    // Enable it to record the images and as a safety, tests will fail.
//    self.recordMode = YES;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    [LeanplumHelper clean_up];
    [OHHTTPStubs removeAllStubs];
}

- (void)test_alert {
    XCTAssert([LeanplumHelper start_production_test_with_response_file:@"start_inapp_response.json"]);
    [Leanplum track:@"ShowAlert"];
    [self verifyApplicationTopView];
}

- (void)verifyApplicationTopView {
    // Wait for the UI to process.
    XCTestExpectation *uiExpectation = [self expectationWithDescription:@"ui"];
    NSOperationQueue *q = [NSOperationQueue new];
    [q addOperationWithBlock:^{
        [NSThread sleepForTimeInterval:0.4];
        [uiExpectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:1 handler:nil];
    sleep(0.4);
    
    UIView *view = [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
    FBSnapshotVerifyView(view, nil);
    
}

@end
