//
//  main.m
//  DynTest
//
//  Created by Mike Laster on 6/20/11.
//

#import <Foundation/Foundation.h>
#import "UseCaseOne.h"

int main (int argc, const char * argv[]){
    @autoreleasepool {
        UseCaseOne *useCase = [[[UseCaseOne alloc] init] autorelease];

        NSLog(@"useCase: %@", useCase);
        [useCase trigger];
    }

    return 0;
}

