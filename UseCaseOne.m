//
//  UseCaseOne.m
//  DynTest
//
//  Created by Mike Laster on 6/22/11.
//

#import "UseCaseOne.h"

#import "ModelClass.h"
#import "Plain.h"
#import "DCIRolePlayer.h"
#import "RoleOne.h"
#import "RoleTwo.h"

@implementation UseCaseOne

- (void)execute {
    ModelClass *modelObject1 = [[[ModelClass alloc] init] autorelease];
    id modelObject2 = [[[Plain alloc] init] autorelease];
    NSString *retValue = nil;
    
    [DCIRolePlayer makeRolePlayer:[Plain class]];
        
    [self assignRole:Role(RoleOne) toObject:modelObject1];
    [self assignRole:Role(RoleTwo) toObject:modelObject2];
    NSLog(@"role1: %@", modelObject1);
    NSLog(@"role2: %@", modelObject2);

    retValue = [[self objectForRole:Role(RoleOne)] stepOne:@"Argument"];
    NSLog(@"retValue: [%@]", retValue);
}

@end
