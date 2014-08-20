//
//  AppDelegate+notification.h
//  LeanPlum
//
//  Created by Telerik Inc.
//
//

#import "AppDelegate.h"

@interface AppDelegate (notification)

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;

- (id) getCommandInstance:(NSString*)className;

@end
