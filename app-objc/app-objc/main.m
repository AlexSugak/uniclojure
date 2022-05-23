//
//  main.m
//  app-objc
//
//  Created by Sasha Suhak on 21.05.2022.
//

#import <Foundation/Foundation.h>
#import <CLJMRuntime/CLJMRuntime.h>
#import <objc/runtime.h>
#import "cljm_DOT_core.h"
#import "common_DOT_lib.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSString *name = @"Objective C";
        id result = ((id (^)(id, id, ...))[(CLJMFunction *)[common_DOT_lib_SLASH_hello value] block])(name, nil);
        
        NSLog(@"%@", result);;
    }
    return 0;
}
