//
//  ContextsManager.h
//  Top100
//
//  Created by Todor Brachkov on 2/12/15.
//  Copyright (c) 2015 Todor Brachkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ContextsManager : NSObject

+ (ContextsManager*)sharedManager;

-(NSManagedObjectContext *)getContext;
-(BOOL)saveContext:(NSManagedObjectContext *)aContext error:(NSError **)error;

@end
