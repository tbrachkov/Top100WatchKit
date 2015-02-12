//
//  Application+Delete.m
//  Top100
//
//  Created by Todor Brachkov on 2/11/15.
//  Copyright (c) 2015 Todor Brachkov. All rights reserved.
//

#import "Application+Delete.h"

@implementation Application (Delete)

+ (void)deleteObjectsInManagedObjectContext:(NSManagedObjectContext *) context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Application"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]];
    request.predicate = nil;
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    for (Application *application in result)
    {
        [context deleteObject:application];
    }
}

@end
