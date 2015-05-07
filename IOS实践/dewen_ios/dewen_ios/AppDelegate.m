//
//  AppDelegate.m
//  dewen_ios
//
//  Created by 王超 on 15/4/19.
//  Copyright (c) 2015年 com.sk80. All rights reserved.
//

#import "AppDelegate.h"
#import "DWMainViewController.h"
#import "DWItemsViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
  
    
    //设置全局导航条风格和颜色
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1]];
    [[UINavigationBar appearance] setTintColor:[UIColor grayColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}];
    //设置tabbar颜色
//    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]];
//    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:212/255.0 green:52/255.0 blue:23/255.0 alpha:1]];
    
    //DWQuestionsViewController *questionsController = [[DWQuestionsViewController alloc] init];
    //UINavigationController *questionNavController = [[UINavigationController alloc] initWithRootViewController:questionsController];
    //setup center view
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[[DWItemsViewController alloc] init]];
    //视图切换主控制器
    DWMainViewController *mainViewController = [[DWMainViewController alloc] initWithCenterController:navController];
    
    self.window.rootViewController = mainViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
