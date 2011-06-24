//
//  Environment.m
//  DynTest
//
//  Created by Mike Laster on 6/22/11.
//

#import "DCIEnvironment.h"

@implementation DCIEnvironment

@synthesize activeContexts;

+ (DCIEnvironment *)defaultEnvironment {
    static DCIEnvironment*_defaultEnvironment = nil;
    
    if (_defaultEnvironment == nil) {
        _defaultEnvironment = [[[self class] alloc] init];
    }
    
    return _defaultEnvironment;
}

- (id)init {
    self = [super init];
    
    if (self != nil) {
        activeContexts = [[NSMutableSet alloc] init];
    }
    
    return self;
}

- (void)dealloc {
    [activeContexts release];
    activeContexts = nil;
    [super dealloc];
}

- (void)registerContext:(DCIContext *)inContext {
    [self.activeContexts addObject:inContext];
}

- (void)unregisterContext:(DCIContext *)inContext {
    [self.activeContexts removeObject:inContext];
}

@end
