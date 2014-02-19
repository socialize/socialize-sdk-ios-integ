//
//  STIntegListViewController.m
//  SocializeInteg
//
//  Created by David Jedeikin on 2/18/14.
//  Copyright (c) 2014 ShareThis. All rights reserved.
//

#import "STIntegListViewController.h"

static NSString *CellIdentifier = @"CellIdentifier";

static NSString *kSectionIdentifier = @"kSectionIdentifier";
static NSString *kSectionTitle = @"kSectionTitle";
static NSString *kSectionRows = @"kSectionRows";

static NSString *kRowExecutionBlock = @"kRowExecutionBlock";
static NSString *kRowText = @"kRowText";
static NSString *kRowIdentifier = @"kRowIdentifier";

// Sections
NSString *kConfigSection = @"kConfigSection";
NSString *kUserSection = @"kUserSection";
NSString *kShareSection = @"kShareSection";
NSString *kCommentSection = @"kCommentSection";
NSString *kLikeSection = @"kLikeSection";
NSString *kFacebookSection = @"kFacebookSection";
NSString *kTwitterSection = @"kTwitterSection";
NSString *kSmartAlertsSection = @"kSmartAlertsSection";
NSString *kActionBarSection = @"kActionBarSection";
NSString *kButtonsExampleSection = @"kButtonsExampleSection";

// Rows
NSString *kShowLinkDialogRow = @"kShowLinkDialogRow";
NSString *kShowUserProfileRow = @"kShowUserProfileRow";
NSString *kShowCommentComposerRow = @"kShowCommentComposerRow";
NSString *kShowCommentsListRow = @"kShowCommentsListRow";
NSString *kLinkToFacebookRow = @"kLinkToFacebookRow";
NSString *kLinkToTwitterRow = @"kLinkToTwitterRow";
NSString *kLikeEntityRow = @"kLikeEntityRow";
NSString *kShowShareRow = @"kShowShareRow";
NSString *kHandleDirectURLSmartAlertRow = @"kHandleDirectURLSmartAlertRow";
NSString *kHandleDirectEntitySmartAlertRow = @"kHandleDirectEntitySmartAlertRow";
NSString *kShowActionBarExampleRow = @"kShowActionBarExampleRow";
NSString *kShowButtonsExampleRow = @"kShowButtonsExampleRow";

static STIntegListViewController *sharedSampleListViewController;

@interface STIntegListViewController ()
@property (nonatomic, strong) NSArray *sections;
@end

@implementation STIntegListViewController

@synthesize sections = sections_;
@synthesize entity = entity_;


+ (STIntegListViewController*)sharedSampleListViewController {
    if (sharedSampleListViewController == nil) {
        sharedSampleListViewController = [[STIntegListViewController alloc] init];
    }
    
    return sharedSampleListViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sections = [self createSections];
}

- (id<SZEntity>)entity {
    if (entity_ == nil) {
        entity_ = [SZEntity entityWithKey:@"Something" name:@"Something"];
    }
    return entity_;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self.sections objectAtIndex:section] objectForKey:kSectionRows] count];
}

- (NSDictionary*)sectionDataForSection:(NSUInteger)section {
    return [self.sections objectAtIndex:section];
}

- (NSDictionary*)rowDataForIndexPath:(NSIndexPath*)indexPath {
    NSDictionary *section = [self sectionDataForSection:indexPath.section];
    NSDictionary *data = [[section objectForKey:kSectionRows] objectAtIndex:indexPath.row];
    
    return data;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *rowData = [self rowDataForIndexPath:indexPath];
    cell.textLabel.text = [rowData objectForKey:kRowText];
    
    return cell;
}

- (NSUInteger)indexForSectionIdentifier:(NSString*)identifier {
    for (int i = 0; i < [self.sections count]; i++) {
        NSDictionary *section = [self.sections objectAtIndex:i];
        if ([[section objectForKey:kSectionIdentifier] isEqualToString:identifier]) {
            return i;
        }
    }
    
    return NSNotFound;
}

- (NSIndexPath*)indexPathForRowIdentifier:(NSString*)identifier {
    for (int s = 0; s < [self.sections count]; s++) {
        NSDictionary *section = [self.sections objectAtIndex:s];
        
        NSArray *rows = [section objectForKey:kSectionRows];
        for (int r = 0; r < [rows count]; r++) {
            NSDictionary *row = [rows objectAtIndex:r];
            
            if ([[row objectForKey:kRowIdentifier] isEqualToString:identifier]) {
                return [NSIndexPath indexPathForRow:r inSection:s];
            }
        }
    }
    
    return nil;
}

- (NSArray*)createSections {
    // General
    NSMutableArray *configRows = [NSMutableArray array];
    [configRows addObject:[self rowWithText:@"Wipe Auth Data" executionBlock:^{
        [[Socialize sharedSocialize] removeAuthenticationInfo];
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    }]];
    
    // User Utilities
    NSMutableArray *userRows = [NSMutableArray array];
    [userRows addObject:[self rowWithIdentifier:kShowLinkDialogRow text:@"Show Link Dialog" executionBlock:^{
        [SZUserUtils showLinkDialogWithViewController:self completion:nil cancellation:nil];
    }]];
    
    [userRows addObject:[self rowWithIdentifier:kShowUserProfileRow text:@"Show User Profile" executionBlock:^{
        id<SocializeFullUser> user = [SZUserUtils currentUser];
        [SZUserUtils showUserProfileInViewController:self user:user completion:nil];
    }]];
    
    [userRows addObject:[self rowWithText:@"Show User Settings" executionBlock:^{
        [SZUserUtils showUserSettingsInViewController:self completion:nil];
    }]];
    
    // Share Utilities
    NSMutableArray *shareRows = [NSMutableArray array];
    [shareRows addObject:[self rowWithIdentifier:kShowShareRow text:@"Show Share Dialog" executionBlock:^{
        SZShareOptions *options = [[SZShareOptions alloc] init];
        options.willShowSMSComposerBlock = ^(SZSMSShareData *smsData) {
            NSLog(@"Sharing SMS");
        };
        
        options.willShowEmailComposerBlock = ^(SZEmailShareData *emailData) {
            NSLog(@"Sharing Email");
        };
        
        options.willRedirectToPinterestBlock = ^(SZPinterestShareData *pinData) {
            NSLog(@"Sharing pin");
        };
        
        options.willAttemptPostingToSocialNetworkBlock = ^(SZSocialNetwork network, SZSocialNetworkPostData *postData) {
            NSLog(@"Posting to %d", network);
        };
        
        options.didSucceedPostingToSocialNetworkBlock = ^(SZSocialNetwork network, id result) {
            NSLog(@"Posted %@ to %d", result, network);
        };
        
        options.didFailPostingToSocialNetworkBlock = ^(SZSocialNetwork network, NSError *error) {
            NSLog(@"Failed posting to %d", network);
        };
        
        [SZShareUtils showShareDialogWithViewController:self options:options entity:self.entity completion:nil cancellation:nil];
        
    }]];

    
    NSMutableArray *commentRows = [NSMutableArray array];
    [commentRows addObject:[self rowWithIdentifier:kShowCommentsListRow text:@"Show Comments List" executionBlock:^{
        SZCommentOptions* options = [SZCommentUtils userCommentOptions];
        options.text = @"Hello world";
        
        SZCommentsListViewController *comments = [[SZCommentsListViewController alloc] initWithEntity:self.entity];
        comments.completionBlock = ^{
            
            // Dismiss however you want here
            [self dismissViewControllerAnimated:NO completion:nil];
        };
        comments.commentOptions = options;
        
        // Present however you want here
        [self presentViewController:comments animated:NO completion:nil];
        
        
        
    }]];
    
    [commentRows addObject:[self rowWithIdentifier:kShowCommentComposerRow text:@"Show Comment Composer" executionBlock:^{
        [SZCommentUtils showCommentComposerWithViewController:self entity:self.entity completion:nil cancellation:nil];
    }]];
    
    NSMutableArray *likeRows = [NSMutableArray array];
    [likeRows addObject:[self rowWithIdentifier:kLikeEntityRow text:@"Like an Entity" executionBlock:^{
        SZLikeOptions *options = [SZLikeUtils userLikeOptions];
        //        options.willAttemptPostToSocialNetworkBlock = ^(SZSocialNetwork network, SZSocialNetworkPostData *postData) {
        //            postData.path = @"me/feed";
        //            [postData.params setObject:@"blah" forKey:@"description"];
        //        };
        //
        [SZLikeUtils likeWithViewController:self options:options entity:self.entity success:nil failure:nil];
    }]];
    
//    NSMutableArray *actionBarRows = [NSMutableArray array];
//    [actionBarRows addObject:[self rowWithIdentifier:kShowActionBarExampleRow text:@"Show Action Bar Example" executionBlock:^{
//        ActionBarExampleViewController *actionBarExample = [[ActionBarExampleViewController alloc] initWithEntity:self.entity];
//        SZNavigationController *nav = [[SZNavigationController alloc] initWithRootViewController:actionBarExample];
//        [self presentViewController:nav animated:YES completion:nil];
//    }]];
//    
//    NSMutableArray *buttonsRows = [NSMutableArray array];
//    [buttonsRows addObject:[self rowWithIdentifier:kShowButtonsExampleRow text:@"Show Button Examples" executionBlock:^{
//        ButtonExampleViewController *buttonsExample = [[ButtonExampleViewController alloc] initWithEntity:self.entity];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:buttonsExample];
//        [self presentViewController:nav animated:YES completion:nil];
//    }]];
    
    NSArray *sections = [NSArray arrayWithObjects:
                         [self sectionWithIdentifier:kConfigSection
                                               title:@"Configuration"
                                                rows:configRows],
                         
                         [self sectionWithIdentifier:kUserSection
                                               title:@"User Utilities"
                                                rows:userRows],
                         
                         [self sectionWithIdentifier:kShareSection
                                               title:@"Share Utilities"
                                                rows:shareRows],
                         
                         [self sectionWithIdentifier:kCommentSection
                                               title:@"Comment Utilities"
                                                rows:commentRows],
                         
                         [self sectionWithIdentifier:kLikeSection
                                               title:@"Like Utilities"
                                                rows:likeRows],
                         
//                         [self sectionWithIdentifier:kActionBarSection
//                                               title:@"Action Bar Utilities"
//                                                rows:actionBarRows],
//                         
//                         [self sectionWithIdentifier:kButtonsExampleSection
//                                               title:@"Buttons Example"
//                                                rows:buttonsRows],
                         
                         nil];

    return sections;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary *sectionData = [self sectionDataForSection:section];
    return [sectionData objectForKey:kSectionTitle];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *rowData = [self rowDataForIndexPath:indexPath];
    void (^executionBlock)() = [rowData objectForKey:kRowExecutionBlock];
    executionBlock();
}

- (NSDictionary*)rowWithText:(NSString*)text executionBlock:(void(^)())executionBlock {
    return [self rowWithIdentifier:@"undefined" text:text executionBlock:executionBlock];
}


- (NSDictionary*)rowWithIdentifier:(NSString*)identifier text:(NSString*)text executionBlock:(void(^)())executionBlock {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            identifier, kRowIdentifier,
            text, kRowText,
            [executionBlock copy], kRowExecutionBlock,
            nil];
}

- (NSDictionary*)sectionWithIdentifier:(NSString*)identifier title:(NSString*)title rows:(NSArray*)rows {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            identifier, kSectionIdentifier,
            title, kSectionTitle,
            rows, kSectionRows,
            nil];
}

@end
