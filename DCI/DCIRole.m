//
//  DCIRole.m
//  
//
//  Created by Mike Laster on 6/21/11.
//

#import "DCIRole.h"

#import "DCIContext.h"

@implementation DCIRole

@synthesize context;

- (id)role:(Role)inRole {
    return [self.context objectForRole:inRole];
}

@end
