//
//  KIFUITestActor+SocializeInteg.h
//  SocializeInteg
//
//  Created by David Jedeikin on 2/18/14.
//  Copyright (c) 2014 ShareThis. All rights reserved.
//

#import <KIF/KIF.h>

@interface KIFUITestActor (SocializeInteg)

- (void)popNavigationControllerToIndex:(NSInteger)index;
- (void)checkAccessibilityLabel:(NSString *)label hasValue:(NSString *)hasValue;
- (void)initializeTest;
- (UIView*)viewWithAccessibilityLabel:(NSString*)label;
- (void)scrollTableViewWithAccessibilityLabel:(NSString*)label
                             toRowAtIndexPath:(NSIndexPath*)indexPath
                               scrollPosition:(UITableViewScrollPosition)scrollPosition
                                     animated:(BOOL)animated;
- (void)scrollAndTapRowInTableViewWithAccessibilityLabel:(NSString*)tableViewLabel atIndexPath:(NSIndexPath *)indexPath;
- (void)verifyActionBarLikesAtCount:(NSInteger)count;
- (void)openLinkDialogExample;
- (void)openActionBarExample;
- (void)showUserProfile;
- (void)openEditProfile;
- (void)showButtonExample;
- (void)showLinkToFacebook;
- (void)wipeAuthData;
- (void)showLinkToTwitter;
- (void)showLikeEntityRow;
- (void)showShareDialog;
- (void)showDirectUrlNotifications;
- (void)showCommentComposer;
- (void)showCommentsList;

@end

@interface KIFUITestActor (Utils)
- (void)initializeTest;
- (void)authWithTwitter;
- (void)scrollAndTapRowInTableViewWithAccessibilityLabel:(NSString*)tableViewLabel atIndexPath:(NSIndexPath *)indexPath;
- (void)scrollTableViewWithAccessibilityLabel:(NSString*)label toRowAtIndexPath:(NSIndexPath*)indexPath scrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;
- (void)noCheckEnterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits;
@end