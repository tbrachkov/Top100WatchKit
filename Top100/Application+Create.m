//
//  Application+Create.m
//  Top100
//
//  Created by Todor Brachkov on 2/11/15.
//  Copyright (c) 2015 Todor Brachkov. All rights reserved.
//

#import "Application+Create.h"

@implementation Application (Create)

+ (Application *)withAppFromTheStore:(NSDictionary *)appDictionary withManagedObjectContext:(NSManagedObjectContext *)context atIndex:(int)index
{
    Application *app = nil;
    
    NSAssert(appDictionary != nil, @"appDictionary is nil");

    NSString *idAppDict = [[[appDictionary objectForKey:@"id"] objectForKey:@"attributes"] objectForKey:@"im:id"];
    NSAssert(idAppDict != nil, @"idApp is nil");
    NSString *idApp = idAppDict;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Application"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"appID = %@", idApp];
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if (!result || ([result count] > 1))
    {
        
    }
    else if (![result count])
    {
        app = [NSEntityDescription insertNewObjectForEntityForName:@"Application" inManagedObjectContext:context];
        
        app.appID = idApp;
        app.index = [[NSNumber alloc] initWithInt:index];

        NSString *nameDict = [[appDictionary objectForKey:@"im:name"] objectForKey:@"label"];
        NSAssert(nameDict != nil, @"nameDict is nil");
        app.name = nameDict;
        
        NSString *imageDict = [[[appDictionary objectForKey:@"im:image"] objectAtIndex:0] objectForKey:@"label"];
        NSAssert(imageDict != nil, @"imageDict is nil");
        app.image = imageDict;
        
        NSString *summaryDict = [[appDictionary objectForKey:@"summary"] objectForKey:@"label"];
        NSAssert(summaryDict != nil, @"summaryDict is nil");
        app.summary = summaryDict;
        
        NSString *priceDict = [[appDictionary objectForKey:@"im:price"] objectForKey:@"label"];
        NSAssert(priceDict != nil, @"priceDict is nil");
        app.price = priceDict;
        
        NSString *contentTypeDict = [[[appDictionary objectForKey:@"im:contentType"] objectForKey:@"attributes"] objectForKey:@"label"];
        NSAssert(contentTypeDict != nil, @"contentTypeDict is nil");
        app.contentType = contentTypeDict;
        
        NSString *titleDict = [[appDictionary objectForKey:@"title"] objectForKey:@"label"];
        NSAssert(titleDict != nil, @"titleDict is nil");
        app.title = titleDict;
        
        NSString *artistDict = [[appDictionary objectForKey:@"im:artist"] objectForKey:@"label"];
        NSAssert(artistDict != nil, @"artistDict is nil");
        app.artist = artistDict;
        
        NSString *categoryDict = [[[appDictionary objectForKey:@"category"] objectForKey:@"attributes"] objectForKey:@"label"];
        NSAssert(categoryDict != nil, @"categoryDict is nil");
        app.category = categoryDict;
        
        NSString *releaseDateDict = [[[appDictionary objectForKey:@"im:releaseDate"] objectForKey:@"attributes"] objectForKey:@"label"];
        NSAssert(releaseDateDict != nil, @"releaseDateDict is nil");
        app.releaseDate = releaseDateDict;
    }
    else
    {
        app = [result lastObject];
    }
    
    return app;
}

@end
