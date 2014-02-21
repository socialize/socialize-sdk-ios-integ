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
#import "TestAppHelper.h"

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

- (void)setUp {
    [super setUp];
    
    [Socialize storeUIErrorAlertsDisabled:YES];
    [Socialize storeLocationSharingDisabled:YES];
    
    [tester initializeTest];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testActionBar {
    NSString *entityKey = [SocializeIntegTests testURL:[NSString stringWithFormat:@"%s/entity1", sel_getName(_cmd)]];
    id<SZEntity> entity = [SZEntity entityWithKey:entityKey name:@"Test"];
    [[STIntegListViewController sharedSampleListViewController] setEntity:entity];
    
    [tester openActionBarExample];

    [tester tapViewWithAccessibilityLabel:@"comment button"];
    [tester tapViewWithAccessibilityLabel:@"Close"];
    
    [tester tapViewWithAccessibilityLabel:@"views button"];
    [tester tapViewWithAccessibilityLabel:@"Cancel"];
    
    [tester tapViewWithAccessibilityLabel:@"share button"];
    [tester tapViewWithAccessibilityLabel:@"Cancel"];
    
    [tester tapViewWithAccessibilityLabel:@"like button"];
    [tester tapViewWithAccessibilityLabel:@"Skip"];
    [tester verifyActionBarLikesAtCount:1];
    [tester tapViewWithAccessibilityLabel:@"like button"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SocializeAuthenticatedUserDidChangeNotification object:[SZUserUtils currentUser]];
    
    [tester waitForViewWithAccessibilityLabel:@"In progress"];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"In progress"];
    [tester tapViewWithAccessibilityLabel:@"Cancel"];
}

- (void)testLikeButton {
    // Set up a test entity
    NSString *entityKey = [TestAppHelper testURL:[NSString stringWithFormat:@"%s/entity1", sel_getName(_cmd)]];
    id<SZEntity> entity = [SZEntity entityWithKey:entityKey name:@"Test"];
    [[STIntegListViewController sharedSampleListViewController] setEntity:entity];
    
    [tester showButtonExample];
    
    [tester tapViewWithAccessibilityLabel:@"like button"];
    [tester tapViewWithAccessibilityLabel:@"Skip"];
    
    [tester verifyActionBarLikesAtCount:1];
    
    [tester tapViewWithAccessibilityLabel:@"like button"];
    [tester tapViewWithAccessibilityLabel:@"Done"];
}

- (void) testLikeNoAuth {
    [tester showLikeEntityRow];
    [tester tapViewWithAccessibilityLabel:@"Skip"];
    [tester waitForViewWithAccessibilityLabel:@"tableView"];
}

- (void) testLikeTwitterAuth {
    [tester showLikeEntityRow];
    [tester tapViewWithAccessibilityLabel:@"Twitter"];
    [tester authWithTwitter];
    
    [tester tapViewWithAccessibilityLabel:@"Like"];
    [tester waitForViewWithAccessibilityLabel:@"tableView"];
}

- (void) testShareTwitterAuth {
    [tester showShareDialog];
    [tester setOn:YES forSwitchWithAccessibilityLabel:@"Twitter Switch"];
    [tester authWithTwitter];
    [tester tapViewWithAccessibilityLabel:@"Continue"];
    [tester waitForViewWithAccessibilityLabel:@"Comment Entry"];
    //unite test using date-time to avoid failed duplicate Twitter updates
    NSDate *date = [NSDate date];
    NSString *dateStr = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
    [tester enterText:[NSString stringWithFormat:@"Share to Twitter: %@", dateStr] intoViewWithAccessibilityLabel:@"Comment Entry"];
    [tester tapViewWithAccessibilityLabel:@"Continue"];
    [tester waitForViewWithAccessibilityLabel:@"tableView"];
}

- (void) testComposeCommentNoAuth {
    [tester showCommentComposer];
    [tester enterText:@"Anonymous Comment"  intoViewWithAccessibilityLabel:@"Comment Entry"];
    [tester tapViewWithAccessibilityLabel:@"Continue"];
    [tester tapViewWithAccessibilityLabel:@"Skip"];
    [tester waitForViewWithAccessibilityLabel:@"tableView"];
}

//convenience methods

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
