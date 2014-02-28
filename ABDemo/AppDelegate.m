//
//  AppDelegate.m
//  ABDemo
//
//  Created by Chris on 2/4/14.
//  Copyright (c) 2014 Kii Corporation. All rights reserved.
//

#import "AppDelegate.h"

#import <KiiSDK/Kii.h>
#import <KiiAnalytics/KiiAnalytics.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    [Kii beginWithID:@"f948b012"
              andKey:@"433095b4e5190ef25e94953efc2c3150"
             andSite:kiiSiteUS];

    
    [KiiAnalytics beginWithID:@"f948b012"
                       andKey:@"433095b4e5190ef25e94953efc2c3150"
                      andSite:kiiAnalyticsSiteUS];
    
    NSError* error = nil;
    
    // try to authenticate
    [KiiUser authenticateSynchronous:@"testuser"
                        withPassword:@"password"
                            andError:&error];
    
    // if error, try to register
    if(error != nil) {
        KiiUser *u = [KiiUser userWithUsername:@"testuser" andPassword:@"password"];
        [u performRegistrationSynchronous:&error];
    }

    return YES;
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
