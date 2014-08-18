/********* CDVLeanPlum.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import "LeanPlum.h"

@interface CDVLeanPlum : CDVPlugin 

- (void) define:(CDVInvokedUrlCommand*)command;

@end

@implementation CDVLeanPlum

- (id) initWithWebView:(UIWebView*)theWebView
{
    self = [super initWithWebView:theWebView];
    if (self) {
        // todo check domain whitelist to give devs a helpful error message
        [self setupLeanPlum];
    }
    return self;
}

- (void) setupLeanPlum
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

      // Starts a new session and updates the app from Leanplum.
      [Leanplum start];
}


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

@end
