//
//  Top100PerformanceTests.m
//  Top100PerformanceTests
//
//  Created by Todor Brachkov on 2/10/15.
//  Copyright (c) 2015 Todor Brachkov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ContextsManager.h"

@interface Top100PerformanceTests : XCTestCase

@end

@implementation Top100PerformanceTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testExample
{
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample
{
    [self measureBlock:^{
       
        for (int i = 0 ; i <10000; i++)
        {
            const char *number = [[NSString stringWithFormat:@"Top100 - %d", i] UTF8String];

            dispatch_queue_t privateQueue = dispatch_queue_create(number, NULL);
            
            dispatch_async(privateQueue, ^{
                
                [[ContextsManager sharedManager] getContext];
            });
        }
    }];
}

@end
