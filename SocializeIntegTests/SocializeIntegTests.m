//
//  SocializeIntegTests.m
//  SocializeIntegTests
//
//  Created by David Jedeikin on 2/18/14.
//  Copyright (c) 2014 ShareThis. All rights reserved.
//

#import "KIFUITestActor+SocializeInteg.h"
#import "STIntegListViewController.h"
#import "StringHelper.h"
#import <XCTest/XCTest.h>
#import <KIF/UIApplication-KIFAdditions.h>
#import <KIF/UIAccessibilityElement-KIFAdditions.h>
#import <KIF/CGGeometry-KIFAdditions.h>
#import <KIF/UIWindow-KIFAdditions.h>


static NSString *UUIDString() {
    CFUUIDRef	uuidObj = CFUUIDCreate(nil);
    NSString	*uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    return uuidString;
}

static NSString *TestAppKIFTestControllerRunID = nil;

@interface SocializeIntegTests : XCTestCase

@end

@implementation SocializeIntegTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testActionBar {
    NSString *entityKey = [SocializeIntegTests testURL:[NSString stringWithFormat:@"%s/entity1", sel_getName(_cmd)]];
    id<SZEntity> entity = [SZEntity entityWithKey:entityKey name:@"Test"];
    [[STIntegListViewController sharedSampleListViewController] setEntity:entity];
    
//    [tester openActionBarExample];
}


+ (NSString*)runID {
    if (TestAppKIFTestControllerRunID == nil) {
        NSString *uuid = UUIDString();
        NSString *sha1 = [uuid sha1];
        NSString *runID = [sha1 substringToIndex:8];
        
        TestAppKIFTestControllerRunID = runID;
    }
    
    return TestAppKIFTestControllerRunID;
}

+ (NSString*)testURL:(NSString*)suffix {
    return [NSString stringWithFormat:@"http://itest.%@/%@", [self runID], suffix];
}

@end
