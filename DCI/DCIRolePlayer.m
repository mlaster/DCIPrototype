//
//  RolePlayer.m
//  
//
//  Created by Mike Laster on 6/21/11.
//

#import "DCIRolePlayer.h"

#import <objc/runtime.h>
#import "DCIContext.h"

const char *_DCI_CONTEXT_KEY = "_dci_context";
const char *_DCI_ROLES_KEY = "_dci_roles";

@interface DCIRolePlayer()

- (BOOL)respondsToSelector:(SEL)aSelector ignoreRoles:(BOOL)ignoreRoles;
- (BOOL)validateMethod:(Method)inMethod;

@end

@implementation DCIRolePlayer

+ (BOOL)makeRolePlayer:(Class)inClass {
    BOOL retValue = YES;
    Method *methods = NULL;
    unsigned int methodCount = 0;
    
    methods = class_copyMethodList(self,&methodCount);
    
    for (unsigned int i = 0; i < methodCount; i++) {
        Method method = methods[i];
        BOOL success = NO;
        
        success = class_addMethod(inClass, method_getName(method), method_getImplementation(method), method_getTypeEncoding(method));
        if (success == NO) {
            retValue = NO;
        }
    }
    
    class_addProtocol(inClass, @protocol(DCIRolePlayer));
        
    return retValue;
}

- (BOOL)respondsToSelector:(SEL)aSelector ignoreRoles:(BOOL)ignoreRoles {
    NSMutableArray *roles = objc_getAssociatedObject(self, &_DCI_ROLES_KEY);
    __block BOOL retValue = [super respondsToSelector:aSelector];
    
    if (ignoreRoles == NO && retValue == NO) {
        [roles enumerateObjectsUsingBlock:^(Class roleClass, NSUInteger idx, BOOL *stop) {
            if ([roleClass instancesRespondToSelector:aSelector]) {
                retValue = YES;
                *stop = YES;
                NSLog(@"TRACE: Role %@ implements %@", roleClass, NSStringFromSelector(aSelector));
            }
        }];
    }
    
    return retValue;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [self respondsToSelector:aSelector ignoreRoles:YES];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMutableArray *roles = objc_getAssociatedObject(self, &_DCI_ROLES_KEY);
    __block NSMethodSignature *retValue = nil;
    
    retValue = [super methodSignatureForSelector:aSelector];
    
    if (retValue == NULL) {
        [roles enumerateObjectsUsingBlock:^(Class roleClass, NSUInteger idx, BOOL *stop) {
            if ([roleClass instancesRespondToSelector:aSelector]) {
                retValue = [roleClass instanceMethodSignatureForSelector:aSelector];
                *stop = YES;
            }
        }];
    }

#if 0
    if (retValue != NULL) {
        
        NSLog(@"MethodSignature for %@:", NSStringFromSelector(aSelector));
        NSLog(@"  arguments: %lu", [retValue numberOfArguments]);

        for (NSUInteger i = 0; i < [retValue numberOfArguments]; i++) {
            NSLog(@"    Arg #%lu: %s", i, [retValue getArgumentTypeAtIndex:i]);
        }
        NSLog(@"  returnLength: %lu", [retValue methodReturnLength]);
        NSLog(@"  returnType: %s", [retValue methodReturnType]);
              
    }
#endif
    return retValue;
}

// Where the magic happens.  This is uglier than I like, but I haven't figured
// out how to actually dynamically call a function with variable arguments when
// it doesn't take a va_list param

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSMutableArray *roles = objc_getAssociatedObject(self, &_DCI_ROLES_KEY);
    NSMethodSignature *msig = [anInvocation methodSignature];
    __block id result = nil;
    
    [roles enumerateObjectsUsingBlock:^(Class roleClass,NSUInteger idx, BOOL *stop) {
        
        if ([roleClass instancesRespondToSelector:[anInvocation selector]]) {
            IMP imp = [roleClass instanceMethodForSelector:[anInvocation selector]];
            NSUInteger argCount = [msig numberOfArguments];
            void *arg2,*arg3,*arg4,*arg5,*arg6,*arg7,*arg8 = NULL;
            
            [anInvocation retainArguments];            
            
            switch (argCount) {
                case 9: [anInvocation getArgument:&arg8 atIndex:8];
                case 8: [anInvocation getArgument:&arg7 atIndex:7];
                case 7: [anInvocation getArgument:&arg6 atIndex:6];
                case 6: [anInvocation getArgument:&arg5 atIndex:5];
                case 5: [anInvocation getArgument:&arg4 atIndex:4];
                case 4: [anInvocation getArgument:&arg3 atIndex:3];
                case 3: [anInvocation getArgument:&arg2 atIndex:2];
                case 2:
                    break;
                default:
                    [NSException raise:NSInternalInconsistencyException format:@"Too many arguments: %lu", argCount];
                    break;
            }
            
            if ([msig methodReturnLength] == 0) {
                switch (argCount) {
                    case 2:
                        imp([anInvocation target],[anInvocation selector]);
                        break;
                    case 3:
                        imp([anInvocation target],[anInvocation selector],arg2);
                        break;
                    case 4:
                        imp([anInvocation target],[anInvocation selector],arg2,arg3);
                        break;
                    case 5:
                        imp([anInvocation target],[anInvocation selector],arg2,arg3,arg4);
                        break;
                    case 6:
                        imp([anInvocation target],[anInvocation selector],arg2,arg3,arg4,arg5);
                        break;
                    case 7:
                        imp([anInvocation target],[anInvocation selector],arg2,arg3,arg4,arg5,arg6);
                        break;
                    case 8:
                        imp([anInvocation target],[anInvocation selector],arg2,arg3,arg4,arg5,arg6,arg7);
                        break;
                    case 9:
                        imp([anInvocation target],[anInvocation selector],arg2,arg3,arg4,arg5,arg6,arg7,arg8);
                        break;
                    default:
                        [NSException raise:NSInternalInconsistencyException format:@"Too many arguments: %lu", argCount];
                        break;
                }
            } else {
                switch (argCount) {
                    case 2:
                        result = imp([anInvocation target],[anInvocation selector]);
                        break;
                    case 3:
                        result = imp([anInvocation target],[anInvocation selector],arg2);
                        break;
                    case 4:
                        result = imp([anInvocation target],[anInvocation selector],arg2,arg3);
                        break;
                    case 5:
                        result = imp([anInvocation target],[anInvocation selector],arg2,arg3,arg4);
                        break;
                    case 6:
                        result = imp([anInvocation target],[anInvocation selector],arg2,arg3,arg4,arg5);
                        break;
                    case 7:
                        result = imp([anInvocation target],[anInvocation selector],arg2,arg3,arg4,arg5,arg6);
                        break;
                    case 8:
                        result = imp([anInvocation target],[anInvocation selector],arg2,arg3,arg4,arg5,arg6,arg7);
                        break;
                    case 9:
                        result = imp([anInvocation target],[anInvocation selector],arg2,arg3,arg4,arg5,arg6,arg7,arg8);
                        break;
                    default:
                        [NSException raise:NSInternalInconsistencyException format:@"Too many arguments: %lu", argCount];
                        break;
                }
            }
            if (strncmp([msig methodReturnType], @encode(id), 1) == 0) {
                [result retain];
            }
            *stop = YES;
            [anInvocation setReturnValue:&result];
        }
    }];
    if (strncmp([msig methodReturnType], @encode(id), 1) == 0) {
        [result autorelease];
    }
}

- (BOOL)validateMethod:(Method)inMethod {
    __block BOOL retValue = NO;
    NSMutableArray *roles = objc_getAssociatedObject(self, &_DCI_ROLES_KEY);
    unsigned int argCount = method_getNumberOfArguments(inMethod);
    SEL selector = method_getName(inMethod);
    char argType = '?';
    
    method_getArgumentType(inMethod, 0, &argType, sizeof(argType));
    if (argType == @encode(id)[0]) {
        method_getArgumentType(inMethod, 1, &argType, sizeof(argType));
        if (argType == @encode(SEL)[0]) {
            retValue = YES;
        } else {
            NSLog(@"ERROR: Method %@ does not appear to be a valid selector!", NSStringFromSelector(selector));
            retValue = NO;
        }
    }
    
    if (retValue == YES) {
        for (unsigned int i = 2; i < argCount; i++) {
            method_getArgumentType(inMethod, i, &argType, sizeof(argType));
            if (argType != @encode(id)[0]) {
                retValue = NO;
                NSLog(@"ERROR: Argument %u of selector %@ is type '%c', not '%c'!", i, NSStringFromSelector(selector), argType, @encode(id)[0]);
                break;
            }
        }
    }
    
    // Make sure not already implemented
    if ([self respondsToSelector:selector ignoreRoles:YES]) {
        retValue = NO;
        NSLog(@"ERROR: %@ already implemenents selector %@", [self class], NSStringFromSelector(selector));
    }
    
    if (retValue == YES) {
        [roles enumerateObjectsUsingBlock:^(Class roleClass,NSUInteger idx, BOOL *stop) {
            if ([roleClass instancesRespondToSelector:selector]) {
                NSLog(@"ERROR: Role %@ already implemenents selector %@", roleClass, NSStringFromSelector(selector));
                retValue = NO;
                *stop = YES;
            }
        }];
    }

    return retValue;
}

- (NSString *)description {
    NSString *retValue = [super description];
    NSArray *roles = objc_getAssociatedObject(self, &_DCI_ROLES_KEY);
    __block NSMutableArray *roleNames = [NSMutableArray array];
    
    [roles enumerateObjectsUsingBlock:^(Class roleClass,NSUInteger idx, BOOL *stop) {
        [roleNames addObject:[roleClass description]];
    }];

    if ([roleNames count] > 0) {
        retValue = [NSString stringWithFormat:@"%@{%@}", retValue, [roleNames componentsJoinedByString:@","]];

    }

    return retValue;
}

- (void)setContext:(DCIContext *)inContext {
    objc_setAssociatedObject(self, &_DCI_CONTEXT_KEY, inContext, OBJC_ASSOCIATION_ASSIGN);
}

- (DCIContext *)context {
    DCIContext *retValue = nil;
    retValue = objc_getAssociatedObject(self, &_DCI_CONTEXT_KEY);
    return retValue;
}

- (BOOL)addRole:(Class)inRole {
    BOOL retValue = NO;
    Method *methods = NULL;
    unsigned int methodCount = 0;
    NSMutableArray *roles = objc_getAssociatedObject(self, &_DCI_ROLES_KEY);
    BOOL isValid = YES;
    
    methods = class_copyMethodList(inRole,&methodCount);

    // Validate that all methods in the role are of the correct type (only id args are supported)
    for (unsigned int i = 0; i < methodCount; i++) {
        Method method = methods[i];
        isValid = [self validateMethod:method];
        
        if (isValid == NO) {
            break;
        }
    }

    if (isValid) {
        if (roles == nil) {
            roles = [[NSMutableArray alloc] init];
            objc_setAssociatedObject(self, &_DCI_ROLES_KEY, roles, OBJC_ASSOCIATION_RETAIN);
        }
        
        NSLog(@"TRACE: AddRole:%@", inRole);
        [roles addObject:inRole];
        retValue = YES;
    }
    free(methods);
    
    return retValue;
}

- (void)removeRole:(Class)inRole {
    NSMutableArray *roles = objc_getAssociatedObject(self, &_DCI_ROLES_KEY);

    [roles removeObject:inRole];
}

- (BOOL)playsRole:(Class)inRole {
    NSMutableArray *roles = objc_getAssociatedObject(self, &_DCI_ROLES_KEY);

    return [roles containsObject:inRole];
}

@end
