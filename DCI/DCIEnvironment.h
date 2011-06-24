//
//  Environment.h
//  DynTest
//
//  Created by Mike Laster on 6/22/11.
//

#import <Foundation/Foundation.h>

@class DCIContext;

@interface DCIEnvironment : NSObject

@property(retain,atomic) NSMutableSet *activeContexts;

+ (DCIEnvironment *)defaultEnvironment;

- (void)registerContext:(DCIContext *)inContext;
- (void)unregisterContext:(DCIContext *)inContext;

@end
