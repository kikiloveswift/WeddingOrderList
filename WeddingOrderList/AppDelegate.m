//
//  AppDelegate.m
//  WeddingOrderList
//
//  Created by kong on 16/10/6.
//  Copyright © 2016年 kong. All rights reserved.
//

#import "AppDelegate.h"
#import "AddOrderViewController.h"
#import "AllOrderListViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _navigationController = self.window.rootViewController;
    //3D-Touch
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f)
    {
        UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc] initWithType:@"添加" localizedTitle:@"添加"];
        UIApplicationShortcutItem *item2 = [[UIApplicationShortcutItem alloc] initWithType:@"总账单" localizedTitle:@"总账单"];
        [[UIApplication sharedApplication] setShortcutItems:@[item1, item2]];
    }
    
    return YES;
}
#pragma mark--3DTouch
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    if ([shortcutItem.localizedTitle isEqualToString:@"添加"])
    {
        AddOrderViewController *addVC = [[AddOrderViewController alloc] init];
        [_navigationController pushViewController:addVC animated:YES];
        return;
        
    }else if ([shortcutItem.localizedTitle isEqualToString:@"总账单"])
    {
        AllOrderListViewController *allOrderVC = [[AllOrderListViewController alloc] init];
        [_navigationController pushViewController:allOrderVC animated:YES];
        return;
    }
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
