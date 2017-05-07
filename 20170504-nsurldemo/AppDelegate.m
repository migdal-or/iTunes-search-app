//
//  AppDelegate.m
//  20170504-nsurldemo
//
//  Created by iOS-School-1 on 04/05/2017.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//
// NUD = NsUrlDemo :)

#import "AppDelegate.h"
#import "NUDNavigationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window = window;
    NUDNavigationController *viewController = [NUDNavigationController new];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:82.0/255.0
                                                                  green:176.0/255.0
                                                                   blue:243.0/255.0
                                                                  alpha:1.0]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor whiteColor] }];
    [[UINavigationBar appearance] setTranslucent:NO];

    viewController.view.frame = window.frame;
	
    window.rootViewController = viewController;

    [window makeKeyAndVisible];
    
    

    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent; //from https://github.com/andrefilimono/ItunesSearcher/blob/master/ItunesSearcher/ISFAppDelegate.m
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
