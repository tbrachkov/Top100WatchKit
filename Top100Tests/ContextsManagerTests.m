//
//  ContextsManagerTests.m
//  Top100
//
//  Created by Todor Brachkov on 2/12/15.
//  Copyright (c) 2015 Todor Brachkov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ContextsManagerTests.h"
#import "Application.h"
#import "Application+Create.h"
#import "Application+Delete.h"
#import "Constants.h"

@implementation ContextsManagerTests

- (void)setUp
{
    self.persistentStack = [ContextsManager sharedManager];
}

- (void)testInitializer
{
    XCTAssertNotNil(self.persistentStack, @"Should have a persistent stack");
}

- (void)testManagedObjectContext
{
    XCTAssertNotNil(self.persistentStack.getContext, @"Should have a managed object context");
    XCTAssertNotNil(self.persistentStack.getContext.persistentStoreCoordinator, @"Should have a persistent store coordinator");
    NSPersistentStore* store = self.persistentStack.getContext.persistentStoreCoordinator.persistentStores[0];
    XCTAssertNotNil(store, @"Should have a persistent store");
}

-(void)importApps
{
    NSParameterAssert(self.persistentStack);
    NSParameterAssert(self.persistentStack.getContext);
    
    NSManagedObjectContext * context = self.persistentStack.getContext;
    [context performBlockAndWait:^{
        
        id json = [self jsonObjectFromURL:kFilesUrl];
      
        NSDictionary *feed = [json objectForKey:@"feed"];
        NSArray *apps = [feed objectForKey:@"entry"];
        
        int index = 0;
        
        [Application deleteObjectsInManagedObjectContext:self.persistentStack.getContext];
        
        for (NSDictionary *app in apps) {
            index++;
            [Application withAppFromTheStore:app withManagedObjectContext:self.persistentStack.getContext atIndex:index];
        }
        NSError * error = nil;
        [context obtainPermanentIDsForObjects:context.insertedObjects.allObjects error:&error];
        NSAssert2(nil == error, @"Error obtaining pernament ID's: %@, %@", error, error.userInfo);
        
        [context save:&error];
        NSAssert2(nil == error, @"Error saving context: %@, %@", error, error.userInfo);
    }];

}

- (void)testImportApps
{
    [self importApps];
    
    NSManagedObjectContext * context = self.persistentStack.getContext;
    
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Application"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]];
    fetchRequest.predicate = nil;
    
    NSError *error = nil;
    NSArray * fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects == nil)
    {
        NSAssert2(nil == error, @"Error while fetching objects: %@, %@", error, error.userInfo);
    }
    
    XCTAssertTrue(100 == fetchedObjects.count, @"Fetched objects count must be equal 100");
    
    for (Application * app in fetchedObjects)
    {
        XCTAssertNotNil(app.name, @"Should have a value");
        XCTAssertNotNil(app.image, @"Should have a value");
        XCTAssertNotNil(app.price, @"Should have a value");
        XCTAssertNotNil(app.category, @"Should have a value");
        XCTAssertNotNil(app.releaseDate, @"Should have a value");

    }
}


@end
