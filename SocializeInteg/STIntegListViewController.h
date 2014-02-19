//
//  STIntegListViewController.h
//  SocializeInteg
//
//  Created by David Jedeikin on 2/18/14.
//  Copyright (c) 2014 ShareThis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Socialize/Socialize.h>

extern NSString *kUserSection;
extern NSString *kShareSection;
extern NSString *kCommentSection;
extern NSString *kLikeSection;
extern NSString *kFacebookSection;
extern NSString *kTwitterSection;
extern NSString *kSmartAlertsSection;
extern NSString *kActionBarSection;

extern NSString *kShowLinkDialogRow;
extern NSString *kShowUserProfileRow;
extern NSString *kShowCommentComposerRow;
extern NSString *kShowCommentsListRow;
extern NSString *kLinkToFacebookRow;
extern NSString *kLinkToTwitterRow;
extern NSString *kLikeEntityRow;
extern NSString *kShowShareRow;
extern NSString *kHandleDirectURLSmartAlertRow;
extern NSString *kShowActionBarExampleRow;
extern NSString *kShowButtonsExampleRow;

@interface STIntegListViewController : UITableViewController

@property (nonatomic, retain) id<SZEntity> entity;

+ (STIntegListViewController*)sharedSampleListViewController;
- (NSUInteger)indexForSectionIdentifier:(NSString*)identifier;
- (NSIndexPath*)indexPathForRowIdentifier:(NSString*)identifier;

@end
