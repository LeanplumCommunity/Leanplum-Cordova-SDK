//
//  AppDelegate+notification.h
//  LeanPlum
//
//  Created by Telerik Inc.
//
//

#import "AppDelegate+notification.h"
#import "CDVLeanPlum.h"

@implementation AppDelegate (notification)

- (id) getCommandInstance:(NSString*)className
{
    return [self.viewController getCommandInstance:className];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

    NSLog(@"didReceiveNotification");

    // Get application state for iOS4.x+ devices, otherwise assume active
    UIApplicationState appState = UIApplicationStateActive;
    if ([application respondsToSelector:@selector(applicationState)]) {
        appState = application.applicationState;
    }

    if (appState == UIApplicationStateActive) {

        CDVLeanPlum *leanplumHandler = [self getCommandInstance:@"LeanPlum"];

        leanplumHandler.notificationMessage = userInfo;
        [leanplumHandler notificationReceived];
    }
}


@end
