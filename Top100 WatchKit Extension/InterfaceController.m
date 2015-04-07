//
//  InterfaceController.m
//  Top100 WatchKit Extension
//
//  Created by Todor Brachkov on 3/29/15.
//  Copyright (c) 2015 Todor Brachkov. All rights reserved.
//

#import "InterfaceController.h"
#import "ApplicationRowController.h"

@import DataShareKit;

@interface InterfaceController()

@property (weak, nonatomic) IBOutlet WKInterfaceTable *tableView;
@property (strong, nonatomic) NSArray* topApplications;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    
    NSManagedObjectContext* moc = [[ContextsManager sharedManager] getContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Application"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]];
    request.predicate = nil;
    
    NSError *error;
    self.topApplications = [moc executeFetchRequest:request error:&error];
    if (error || !self.topApplications)
    {
        NSLog(@"Error in retrieving data!");
    }

    
    [self.tableView setNumberOfRows:self.topApplications.count withRowType:@"ApplicationCell"];
    
    NSInteger index = 0;

    for (Application* application in self.topApplications)
    {
        ApplicationRowController *cell = [self.tableView rowControllerAtIndex:index];
        [cell.applicationTitleLabel setText:application.title];
        [cell.applicationDetailLabel setText:application.summary];

        index++;
    }

}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    NSUserDefaults* sharedUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.mentormate.Top100"];
    NSLog(@"Saved date: %@", [[sharedUserDefaults objectForKey:@"DateAppStart"]description]);
    
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex
{
    // Push detail view with selected quote
    [self pushControllerWithName:@"DetailInterfaceController" context:[self.topApplications objectAtIndex:rowIndex]];
}


@end



