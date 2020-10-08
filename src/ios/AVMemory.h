#import <Cordova/CDV.h>

@interface AVMemory : CDVPlugin

- (void) getmemory:(CDVInvokedUrlCommand*)command;
- (void) isMemorySafe:(CDVInvokedUrlCommand*)command;

@end