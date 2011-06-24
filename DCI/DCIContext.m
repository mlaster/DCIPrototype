//
//  Context.m
//  DynTest
//
//  Created by Mike Laster on 6/22/11.
//

#import "DCIContext.h"

#import "DCIEnvironment.h"
#import "DCIRolePlayer.h"

@interface DCIContext()

@property(atomic,readwrite) DCIEnvironment* environment;
@property(atomic,retain,readwrite) NSMutableDictionary *roleMap;

@end

@implementation DCIContext

@synthesize environment;
@synthesize roleMap;

- (id)init {
    return [self initWithEnvironment:[DCIEnvironment defaultEnvironment]];
}

- (id)initWithEnvironment:(DCIEnvironment *)inEnvironment {
    self = [super init];
    
    if (self != nil) {
        environment = [inEnvironment retain];
        roleMap = [[NSMutableDictionary alloc] init];
        [self.environment registerContext:self];
    }
    
    return self;
}

- (void)dealloc {
    [environment release];
    environment = nil;
    [roleMap release];
    roleMap = nil;
    [super dealloc];
}

- (void)assignRole:(Role)inRole toObject:(id <DCIRolePlayer>)inRolePlayer {
    BOOL success = NO;
    
    if ([self.roleMap objectForKey:inRole] == nil) {
        if (inRolePlayer.context != nil) {
            if (inRolePlayer.context != self) {
                [NSException raise:NSInternalInconsistencyException
                            format:@"Role Player %@ already has a context: %@", inRolePlayer.context];
            }
        } else {
            inRolePlayer.context = self;
        }
        
        NSParameterAssert(inRolePlayer.context == self);

        success = [inRolePlayer addRole:inRole];
        if (success) {
            
            [self.roleMap setObject:inRolePlayer forKey:inRole];
        } else {
            [NSException raise:NSInternalInconsistencyException
                        format:@"Failed to assign role of %@ to %@", inRole, inRolePlayer];
        }
    } else {
        [NSException raise:NSInternalInconsistencyException
                    format:@"The role of %@ is already played by %@", inRole, [self.roleMap objectForKey:inRole]];
    }
}

- (id)objectForRole:(Role)inRole {
    return [self.roleMap objectForKey:inRole];
}

- (void)trigger {
    @autoreleasepool {
        @try {
            [self execute];
        }
        @finally {
            for (Class role in self.roleMap) {
                DCIRolePlayer *player = [self.roleMap objectForKey:role];
                
                [player removeRole:role];
                player.context = nil;                
            }
            
            [self.roleMap removeAllObjects];
            [self.environment unregisterContext:self];
        }
    }
}

- (void)execute {
    [NSException raise:NSInternalInconsistencyException format:@"Subclassers must implement %@", NSStringFromSelector(_cmd)];
}

@end
