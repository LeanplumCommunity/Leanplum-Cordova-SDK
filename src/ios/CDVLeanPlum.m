#import "CDVLeanPlum.h"
#import "LeanPlum.h"

@implementation CDVLeanPlum

@synthesize callback;
@synthesize callbackId;
@synthesize notificationMessage;

- (void) define:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* name = [command.arguments objectAtIndex:0];
    id value = [command.arguments objectAtIndex:1];

    if([value isKindOfClass:[NSString class]]){
        [LPVar define:name withString:value];
    }

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)start:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{

        __block CDVPluginResult* pluginResult = nil;

        [self setup];

        if ([command.arguments count] > 0){
            [Leanplum startWithUserId:[command.arguments objectAtIndex:0] responseHandler:^(BOOL success) {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }];
        }else{
            // Starts a new session and updates the app from Leanplum.
            [Leanplum startWithResponseHandler:^(BOOL success) {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }];
        }
    }];
}

- (void) setup
{
    NSString *appId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"APP_ID"];

#ifdef DEBUG
    NSString *devKey = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"DEVELOPMENT_KEY"];
    LEANPLUM_USE_ADVERTISING_ID;
    [Leanplum setAppId:appId withDevelopmentKey:devKey];
#else
    NSString *prodKey = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"PRODUCTION_KEY"];
    [Leanplum setAppId:appId withProductionKey:prodKey];
#endif

    // Syncs all the files between your main bundle and Leanplum.
    // This allows you to swap out and A/B test any resource file
    // in your project in realtime.
    [Leanplum syncResources];

    // Tracks all screens in your app as states in Leanplum.
    [Leanplum trackAllAppScreens];
}


- (void) track:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;

    if ([command.arguments count] == 1){
        [Leanplum track:[command.arguments objectAtIndex:0]];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];

    }
    else if([command.arguments count] > 1 && [[command.arguments objectAtIndex:1] isKindOfClass:[NSDictionary class]]){

        [Leanplum track:[command.arguments objectAtIndex:0] withParameters:[command.arguments objectAtIndex:1]];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


- (void)registerPush:(CDVInvokedUrlCommand*)command
{
    self.callbackId = command.callbackId;

    NSMutableDictionary* options = [command.arguments objectAtIndex:0];

    UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeNone;
    id badgeArg = [options objectForKey:@"badge"];
    id soundArg = [options objectForKey:@"sound"];
    id alertArg = [options objectForKey:@"alert"];

    if ([badgeArg isKindOfClass:[NSString class]])
    {
        if ([badgeArg isEqualToString:@"true"])
            notificationTypes |= UIRemoteNotificationTypeBadge;
    }
    else if ([badgeArg boolValue])
        notificationTypes |= UIRemoteNotificationTypeBadge;

    if ([soundArg isKindOfClass:[NSString class]])
    {
        if ([soundArg isEqualToString:@"true"])
            notificationTypes |= UIRemoteNotificationTypeSound;
    }
    else if ([soundArg boolValue])
        notificationTypes |= UIRemoteNotificationTypeSound;

    if ([alertArg isKindOfClass:[NSString class]])
    {
        if ([alertArg isEqualToString:@"true"])
            notificationTypes |= UIRemoteNotificationTypeAlert;
    }
    else if ([alertArg boolValue])
        notificationTypes |= UIRemoteNotificationTypeAlert;

    self.callback = [options objectForKey:@"callback"];

    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];

}

- (void)unregisterPush:(CDVInvokedUrlCommand*)command;
{
    self.callbackId = command.callbackId;

    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
}

- (void)notificationReceived
{
    NSLog(@"Notification received");

    if (self.notificationMessage && self.callback)
    {
        NSMutableString *jsonStr = [NSMutableString stringWithString:@"{"];

        [self parseDictionary:self.notificationMessage intoJSON:jsonStr];

        [jsonStr appendString:@"}"];

        NSLog(@"Msg: %@", jsonStr);

        NSString * jsCallBack = [NSString stringWithFormat:@"%@(%@);", self.callback, jsonStr];
        [self.webView stringByEvaluatingJavaScriptFromString:jsCallBack];

        self.notificationMessage = nil;
    }

}

-(void)parseDictionary:(NSDictionary *)inDictionary intoJSON:(NSMutableString *)jsonString
{
    NSArray *keys = [inDictionary allKeys];
    NSString *key;

    for (key in keys)
    {
        id thisObject = [inDictionary objectForKey:key];

        if ([thisObject isKindOfClass:[NSDictionary class]])
            [self parseDictionary:thisObject intoJSON:jsonString];
        else if ([thisObject isKindOfClass:[NSString class]])
            [jsonString appendFormat:@"\"%@\":\"%@\",",
             key,
             [[[[inDictionary objectForKey:key]
                stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"]
               stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""]
              stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"]];
        else {
            [jsonString appendFormat:@"\"%@\":\"%@\",", key, [inDictionary objectForKey:key]];
        }
    }
}

@end
