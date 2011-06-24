//
//  MyMixin.m
//  DynTest
//
//  Created by Mike Laster on 6/20/11.
//

#import "RoleOne.h"

#import "RoleTwo.h"

@implementation RoleOne

- (NSString *)stepOne:(NSString *)inString {
    return [NSString stringWithFormat:@"(1:%@)",[[self role:Role(RoleTwo)] stepTwo:inString]];
}

@end
