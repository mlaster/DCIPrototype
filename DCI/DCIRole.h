//
//  DCIRole.h
//  
//
//  Created by Mike Laster on 6/21/11.
//

#import <Foundation/Foundation.h>
#import "DCIContext.h"

@interface DCIRole : NSObject

@property (atomic,assign) DCIContext *context;

- (id)role:(Class)inRole;

@end
