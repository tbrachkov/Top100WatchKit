//
//  Application+Delete.h
//  Top100
//
//  Created by Todor Brachkov on 2/11/15.
//  Copyright (c) 2015 Todor Brachkov. All rights reserved.
//

#import "Application.h"

@interface Application (Delete)

+ (void)deleteObjectsInManagedObjectContext:(NSManagedObjectContext *) context;

@end
