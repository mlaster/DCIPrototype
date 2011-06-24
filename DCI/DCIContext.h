//
//  Context.h
//  DynTest
//
//  Created by Mike Laster on 6/22/11.
//

#import <Foundation/Foundation.h>

@class DCIEnvironment;
@protocol DCIRolePlayer;

@interface DCIContext : NSObject

typedef  Class Role;
#define Role(x) [x class]

@property(readonly,atomic) DCIEnvironment* environment;

- (id)initWithEnvironment:(DCIEnvironment *)inEnvironment;

- (void)assignRole:(Role)inRole toObject:(id <DCIRolePlayer>)inRolePlayer;

- (id)objectForRole:(Role)inRole;


- (void)trigger;
- (void)execute;

@end
