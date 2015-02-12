//
//  JSONFromURL.m
//  Top100
//
//  Created by Todor Brachkov on 2/12/15.
//  Copyright (c) 2015 Todor Brachkov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "JSONFromURL.h"

@implementation JSONFromURL

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (id)jsonObjectFromURL:(NSString *)URL {
    NSParameterAssert(URL);
    id json = [NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
    return [NSJSONSerialization JSONObjectWithData:json options:kNilOptions error:nil];
}

@end
