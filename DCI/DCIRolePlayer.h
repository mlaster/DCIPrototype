//
//  RolePlayer.h
//  
//
//  Created by Mike Laster on 6/21/11.
//

#import <Foundation/Foundation.h>

@class DCIContext;

@protocol DCIRolePlayer

- (void)setContext:(DCIContext *)inContext;
- (DCIContext *)context;

- (BOOL)addRole:(Class)inRole;
- (void)removeRole:(Class)inRole;

- (BOOL)playsRole:(Class)inRole;

@end

@interface DCIRolePlayer : NSObject <DCIRolePlayer>


@end

@interface DCIRolePlayer(Context)

// Use this to make any class behave like a RolePlayer
+ (BOOL)makeRolePlayer:(Class)inClass;


@end
