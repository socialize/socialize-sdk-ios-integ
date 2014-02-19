//
//  KIFUITestActor+SocializeInteg.m
//  SocializeInteg
//
//  Created by David Jedeikin on 2/18/14.
//  Copyright (c) 2014 ShareThis. All rights reserved.
//

#import "KIFUITestActor+SocializeInteg.h"
#import "STIntegListViewController.h"
#import <KIF/UIApplication-KIFAdditions.h>
#import <KIF/UIAccessibilityElement-KIFAdditions.h>
#import <KIF/CGGeometry-KIFAdditions.h>
#import <KIF/UIWindow-KIFAdditions.h>

@implementation KIFUITestActor (SocializeInteg)

- (void)popNavigationControllerToIndex:(NSInteger)index {
    NSLog(@"Reset nav to level %d.", index);
    [self runBlock:^KIFTestStepResult(NSError *__autoreleasing *error) {
        BOOL successfulReset = YES;
        
        [[[STIntegListViewController sharedSampleListViewController] navigationController] popToRootViewControllerAnimated:NO];
        // Do the actual reset for your app. Set successfulReset = NO if it fails.
        KIFTestCondition(successfulReset, error, @"Failed to reset the application.");
        return KIFTestStepResultSuccess;
    }];
}

- (void)checkAccessibilityLabel:(NSString *)label hasValue:(NSString *)hasValue {
    NSLog(@"Check value accessibility label: %@ has value: %@", label, hasValue);
    
    [self runBlock:^KIFTestStepResult(NSError *__autoreleasing *error) {
        UIAccessibilityElement *element = [[UIApplication sharedApplication] accessibilityElementWithLabel:label accessibilityValue:nil traits:UIAccessibilityTraitNone];
        UIView *view = (UIView*)[UIAccessibilityElement viewContainingAccessibilityElement:element];
        NSString *elementValue = nil;
        if ([view isKindOfClass:[UIButton class]]) {
            elementValue = [(UIButton *)view currentTitle];
        } else {
            //assume it's a UILabel
            elementValue = ((UILabel *)view).text;
        }
        if ( [elementValue isEqualToString:hasValue] ) {
            return KIFTestStepResultSuccess;
        } else {
            NSString *description = [NSString stringWithFormat:@"View with accessibility label \"%@\" has value \"%@\" but expected \"%@\"", label, elementValue, hasValue];
            *error = [[NSError alloc] initWithDomain:@"KIFTest" code:KIFTestStepResultFailure
                                            userInfo:[NSDictionary dictionaryWithObjectsAndKeys:description, NSLocalizedDescriptionKey, nil]];
            return KIFTestStepResultWait;
        }
    }];
}

- (void)initializeTest {
    [self waitForTimeInterval:0.25];
    [[NSNotificationCenter defaultCenter] postNotificationName:SocializeShouldDismissAllNotificationControllersNotification object:nil];
    [self waitForTimeInterval:0.25];
    
    [self popNavigationControllerToIndex:0];
    [self waitForViewWithAccessibilityLabel:@"tableView"];
    
    
//    [[SZTestHelper sharedTestHelper] removeAuthenticationInfo];
    [SZTwitterUtils unlink];
    [SZFacebookUtils unlink];
    [[STIntegListViewController sharedSampleListViewController] setEntity:nil];
}


- (UIView*)viewWithAccessibilityLabel:(NSString*)label {
    UIAccessibilityElement *element = [[UIApplication sharedApplication] accessibilityElementWithLabel:label accessibilityValue:nil traits:UIAccessibilityTraitNone];
    UIView *view = (UIView*)[UIAccessibilityElement viewContainingAccessibilityElement:element];
    return view;
}

- (void)scrollTableViewWithAccessibilityLabel:(NSString*)label
                             toRowAtIndexPath:(NSIndexPath*)indexPath
                               scrollPosition:(UITableViewScrollPosition)scrollPosition
                                     animated:(BOOL)animated {
    NSLog(@"Scroll UITableView %@ to indexPath %@", label, indexPath);
    [self runBlock:^KIFTestStepResult(NSError *__autoreleasing *error) {
        UITableView *tableView = (UITableView*)[self viewWithAccessibilityLabel:label];
        KIFTestCondition([tableView isKindOfClass:[UITableView class]], error, @"Element with label %@ not UITableView", label);
        
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
        
        return KIFTestStepResultSuccess;
    }];
}


- (void)scrollAndTapRowInTableViewWithAccessibilityLabel:(NSString*)tableViewLabel atIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Tap row %d in tableView with label %@", [indexPath row], tableViewLabel);
    
    [self runBlock:^KIFTestStepResult(NSError *__autoreleasing *error) {
        UIAccessibilityElement *element = [[UIApplication sharedApplication] accessibilityElementWithLabel:tableViewLabel accessibilityValue:nil traits:UIAccessibilityTraitNone];
        
        KIFTestCondition(element, error, @"View with label %@ not found", tableViewLabel);
        UITableView *tableView = (UITableView*)[UIAccessibilityElement viewContainingAccessibilityElement:element];
        
        KIFTestCondition([tableView isKindOfClass:[UITableView class]], error, @"Specified view is not a UITableView");
        
        KIFTestCondition(tableView, error, @"Table view with label %@ not found", tableViewLabel);
        
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        CGRect cellFrame = [cell.contentView convertRect:[cell.contentView frame] toView:tableView];
        [tableView tapAtPoint:CGPointCenteredInRect(cellFrame)];
        
        return KIFTestStepResultSuccess;
    }];
}

- (void)verifyActionBarLikesAtCount:(NSInteger)count {
    NSString *countString = [NSString stringWithFormat:@"%d", count];
    [self checkAccessibilityLabel:@"like button" hasValue:countString];
}

- (void)openLinkDialogExample {
    NSIndexPath *indexPath = [[STIntegListViewController sharedSampleListViewController] indexPathForRowIdentifier:kShowLinkDialogRow];
    [self scrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView"  atIndexPath:indexPath];
}

- (void)openActionBarExample {
    NSIndexPath *indexPath = [[STIntegListViewController sharedSampleListViewController] indexPathForRowIdentifier:kShowActionBarExampleRow];
    [self scrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView"  atIndexPath:indexPath];
}

- (void)showUserProfile {
    NSIndexPath *indexPath = [[STIntegListViewController sharedSampleListViewController] indexPathForRowIdentifier:kShowUserProfileRow];
    [self scrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView"  atIndexPath:indexPath];
}

- (void)openEditProfile {
    [self tapViewWithAccessibilityLabel:@"Settings"];
}

- (void)showButtonExample {
    NSIndexPath *indexPath = [[STIntegListViewController sharedSampleListViewController] indexPathForRowIdentifier:kShowButtonsExampleRow];
    [self scrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView"  atIndexPath:indexPath];
}

- (void)showLinkToFacebook {
    NSIndexPath *indexPath = [[STIntegListViewController sharedSampleListViewController] indexPathForRowIdentifier:kLinkToFacebookRow];
    [self scrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView"  atIndexPath:indexPath];
}

- (void)wipeAuthData {
    NSIndexPath *indexPath = [[STIntegListViewController sharedSampleListViewController] indexPathForRowIdentifier:@"Wipe Auth Data"];
    [self scrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView"  atIndexPath:indexPath];
}

- (void)showLinkToTwitter {
    NSIndexPath *indexPath = [[STIntegListViewController sharedSampleListViewController] indexPathForRowIdentifier:kLinkToTwitterRow];
    [self scrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView"  atIndexPath:indexPath];
}

- (void)showLikeEntityRow {
    NSIndexPath *indexPath = [[STIntegListViewController sharedSampleListViewController] indexPathForRowIdentifier:kLikeEntityRow];
    [self scrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView"  atIndexPath:indexPath];
}

- (void)showShareDialog {
    NSIndexPath *indexPath = [[STIntegListViewController sharedSampleListViewController] indexPathForRowIdentifier:kShowShareRow];
    [self scrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView"  atIndexPath:indexPath];
}

- (void)showDirectUrlNotifications {
    NSIndexPath *indexPath = [[STIntegListViewController sharedSampleListViewController] indexPathForRowIdentifier:kHandleDirectURLSmartAlertRow];
    [self scrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView"  atIndexPath:indexPath];
}

- (void)showCommentComposer {
    NSIndexPath *indexPath = [[STIntegListViewController sharedSampleListViewController] indexPathForRowIdentifier:kShowCommentComposerRow];
    [self scrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView"  atIndexPath:indexPath];
}

- (void)showCommentsList {
    NSIndexPath *indexPath = [[STIntegListViewController sharedSampleListViewController] indexPathForRowIdentifier:kShowCommentsListRow];
    [self scrollAndTapRowInTableViewWithAccessibilityLabel:@"tableView"  atIndexPath:indexPath];
}

@end
