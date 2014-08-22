#import <Cordova/CDV.h>

@interface CDVLeanPlum : CDVPlugin

@property (nonatomic, strong) NSDictionary *notificationMessage;

@property (nonatomic, copy) NSString *callbackId;
@property (nonatomic, copy) NSString *callback;

- (void) start:(CDVInvokedUrlCommand*)command;
- (void) track:(CDVInvokedUrlCommand*)command;

- (void)registerPush:(CDVInvokedUrlCommand*)command;
- (void)unregisterPush:(CDVInvokedUrlCommand*)command;

- (void)notificationReceived;

@end
