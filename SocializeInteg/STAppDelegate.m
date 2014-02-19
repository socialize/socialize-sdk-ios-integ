//
//  STAppDelegate.m
//  SocializeInteg
//
//  Created by David Jedeikin on 2/18/14.
//  Copyright (c) 2014 ShareThis. All rights reserved.
//

#import "STAppDelegate.h"
#import "STIntegListViewController.h"
#import <Socialize/Socialize.h>

@implementation STAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    [Socialize storeOGLikeEnabled:YES];
    [Socialize storeAnonymousAllowed:YES];
    [Socialize storeConsumerKey:@"976421bd-0bc9-44c8-a170-bd12376123a3"];
    [Socialize storeConsumerSecret:@"2bf36ced-b9ab-4c5b-b054-8ca975d39c14"];
    [SZTwitterUtils setConsumerKey:@"ZWxJ0zIK73n5HKwGLHolQ" consumerSecret:@"3K1LTY39QM9DPAqJzSZAD3L2EBEXXvuCdtTRr8NDd8"];
    [SZFacebookUtils setAppId:@"268891373224435"];
    
    STIntegListViewController *listView = [STIntegListViewController sharedSampleListViewController];
    self.window.rootViewController = listView;
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [Socialize handleOpenURL:url];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
