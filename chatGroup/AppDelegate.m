//
//  AppDelegate.m
//  chatGroup
//
//  Created by sijie.jiang on 2020/3/23.
//  Copyright © 2020 sijie.jiang. All rights reserved.
//

#import "AppDelegate.h"
#import "UsersListViewController.h"

#define APP_ID @"dWNLhmf8CVlqChrGepvqp5Cw-gzGzoHsz"
#define APP_KEY @"8AnI2TacgxCFohhMwv0AGnOw"
#define SERVER_URL @"https://dwnlhmf8.lc-cn-n1-shared.com"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [AVOSCloud setApplicationId:APP_ID
                      clientKey:APP_KEY
                serverURLString:SERVER_URL];
    [AVOSCloud setAllLogsEnabled:YES];
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
