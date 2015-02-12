//
//  ContextsManagerTests.h
//  Top100
//
//  Created by Todor Brachkov on 2/12/15.
//  Copyright (c) 2015 Todor Brachkov. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ContextsManager.h"
#import "JSONFromURL.h"

@interface ContextsManagerTests : JSONFromURL

@property (nonatomic, strong) ContextsManager* persistentStack;

@end
