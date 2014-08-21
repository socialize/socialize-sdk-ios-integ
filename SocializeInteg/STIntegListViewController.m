//
//  STIntegListViewController.m
//  SocializeInteg
//
//  Created by David Jedeikin on 2/18/14.
//  Copyright (c) 2014 ShareThis. All rights reserved.
//

#import "STIntegListViewController.h"
#import "ActionBarExampleViewController.h"
#import "ButtonExampleViewController.h"
#import "SZFacebookUtils.h"

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
NSString *kSupportIssuesSection = @"kSupportIssuesSection";

// Rows
NSString *kShowLinkDialogRow = @"kShowLinkDialogRow";
NSString *kShowUserProfileRow = @"kShowUserProfileRow";
NSString *kShowCommentComposerRow = @"kShowCommentComposerRow";
NSString *kShowCommentsListRow = @"kShowCommentsListRow";
NSString *kLinkToFacebookRow = @"kLinkToFacebookRow";
NSString *kLinkToTwitterRow = @"kLinkToTwitterRow";
NSString *kLikeEntityRow = @"kLikeEntityRow";
NSString *kShowShareRow = @"kShowShareRow";
NSString *kCustomEntityRow = @"kCustomEntityRow";
NSString *kHandleDirectURLSmartAlertRow = @"kHandleDirectURLSmartAlertRow";
NSString *kHandleDirectEntitySmartAlertRow = @"kHandleDirectEntitySmartAlertRow";
NSString *kShowActionBarExampleRow = @"kShowActionBarExampleRow";
NSString *kShowButtonsExampleRow = @"kShowButtonsExampleRow";
NSString *kSupportIssueRow = @"kSupportIssueRow";

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
    self.tableView.accessibilityLabel = @"tableView";
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 20, 320, 460);
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
    
    [shareRows addObject:[self rowWithIdentifier:kCustomEntityRow text:@"Create Custom Entity" executionBlock:^{
        [self createEntityWithCustomPageInfo];
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
    
    NSMutableArray *actionBarRows = [NSMutableArray array];
    [actionBarRows addObject:[self rowWithIdentifier:kShowActionBarExampleRow text:@"Show Action Bar Example" executionBlock:^{
        ActionBarExampleViewController *actionBarExample = [[ActionBarExampleViewController alloc] initWithEntity:self.entity];
        SZNavigationController *nav = [[SZNavigationController alloc] initWithRootViewController:actionBarExample];
        [self presentViewController:nav animated:YES completion:nil];
    }]];
    
    NSMutableArray *buttonsRows = [NSMutableArray array];
    [buttonsRows addObject:[self rowWithIdentifier:kShowButtonsExampleRow text:@"Show Button Examples" executionBlock:^{
        ButtonExampleViewController *buttonsExample = [[ButtonExampleViewController alloc] initWithEntity:self.entity];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:buttonsExample];
        [self presentViewController:nav animated:YES completion:nil];
    }]];
    
    NSMutableArray *supportIssueRows = [NSMutableArray array];
    [supportIssueRows addObject:[self rowWithIdentifier:kSupportIssueRow text:@"Support Issue" executionBlock:^{
        [self supportTest];
    }]];
    
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
                         
                         [self sectionWithIdentifier:kActionBarSection
                                               title:@"Action Bar Utilities"
                                                rows:actionBarRows],
                         
                         [self sectionWithIdentifier:kButtonsExampleSection
                                               title:@"Buttons Example"
                                                rows:buttonsRows],
                         
                         [self sectionWithIdentifier:kSupportIssuesSection
                                               title:@"Support Issues"
                                                rows:supportIssueRows],
                         
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


- (void)createEntityWithCustomPageInfo {
    SZEntity *entity = [SZEntity entityWithKey:@"my_key" name:@"An Entity"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"Some title for the page, if you don't want to use the entity name", @"szsd_title",
                            @"Description text on the page if there is no URL to parse", @"szsd_description",
                            @"http://the_url_to_your_thumbnail_image", @"szsd_thumb",
                            nil];
     
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    NSAssert(error == nil, @"Error writing json: %@", [error localizedDescription]);
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    entity.meta = jsonString;
    
    [SZEntityUtils addEntity:entity
                     success:^(id<SZEntity> serverEntity) {
                         NSLog(@"Successfully updated entity meta: %@", [serverEntity meta]);
    }
                     failure:^(NSError *error) {
                         NSLog(@"Failure: %@", [error localizedDescription]);
    }];
}

//Various support test operations
- (void)supportTest {
    UIImage *image = [UIImage imageNamed:@"FurryCautte.png"];
    NSData *imageData = UIImagePNGRepresentation(image);
    
    NSDictionary *paramss = @{
                              @"status": @"twitter test post",
                              @"media[]": imageData
                              };
    [SZTwitterUtils postWithViewController:self
                                      path:@"1.1/statuses/update_with_media.json"
                                    params:paramss
                                 multipart:YES
                                   success:^(id result) {
        NSLog(@"Posted");
    }
                                   failure:^(NSError *error) {
        NSLog(@"Failed %@", [error localizedDescription]); 
    }];
    
    
//    //set to date 30 days in future (preferred for FB access token)
//    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
//    [dateComponents setDay:30];
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
//
//    [SZFacebookUtils linkWithAccessToken:[self facebookAccessToken]
//                          expirationDate:newDate
//                                 success:^(id user) {
//        SZUserSettings *settings = [SZUserUtils currentUserSettings];
////        UIImage *newImage = img;
////        settings.profileImage = newImage;
//        settings.bio = @"I love this app!";
//        settings.firstName = @"David";
//        settings.lastName = @"Jedeikin";
//        
//        [SZUserUtils saveUserSettings:settings
//                              success:^(SZUserSettings *settings, id updatedUser) {
//            
//                              }
//                              failure:^(NSError *error) {
//                                  NSLog(@"Broke: %@", [error localizedDescription]); //<--this is where i get the above response 
//                              }]; 
//    } failure:^(NSError *error) {
//        NSLog(@"FAIL!!");
//    }];
}

-(NSDictionary*)authInfoFromConfig {
    NSBundle * bundle =  [NSBundle bundleForClass:[self class]];
    NSString * configPath = [bundle pathForResource:@"SocializeApiInfo" ofType:@"plist"];
    NSDictionary * configurationDictionary = [[NSDictionary alloc]initWithContentsOfFile:configPath];
    return  [configurationDictionary objectForKey:@"Socialize API info"];
}

- (NSString*)facebookAccessToken {
    NSDictionary *apiInfo = [self authInfoFromConfig];
    return [apiInfo objectForKey:@"facebookToken"];
}

@end
