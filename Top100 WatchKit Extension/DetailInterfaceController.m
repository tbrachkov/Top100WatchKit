//
//  DetailInterfaceController.m
//  Top100
//
//  Created by Todor Brachkov on 3/29/15.
//  Copyright (c) 2015 Todor Brachkov. All rights reserved.
//

#import "DetailInterfaceController.h"

@import DataShareKit;

@interface DetailInterfaceController()

@property (strong, nonatomic) Application* selectedApplication;

@property (weak, nonatomic) IBOutlet WKInterfaceImage *applicationImageView;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *applicationTitle;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *applicationDetails;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *applicationCategoryLabel;

@end


@implementation DetailInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    self.selectedApplication = context;
    
    self.applicationTitle.text = self.selectedApplication.title;
    self.applicationDetails.text = self.selectedApplication.summary;
    self.applicationCategoryLabel.text = self.selectedApplication.category;
    
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        NSURL *url = [NSURL URLWithString:self.selectedApplication.image];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage* appImage = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.applicationImageView setImage:appImage];
        });
    });


//    Create animated images
//    [self.spriteImageView setImageNamed:@"dragon-"];
//    [self.spriteImageView startAnimatingWithImagesInRange:NSMakeRange(0, 60) duration:1.0 repeatCount:0];
    
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}


- (IBAction)menuActionAdd {
   
    [self presentTextInputControllerWithSuggestions:@[@"Such App!", @"Much Fun!", @"Hate it!"] allowedInputMode:WKTextInputModeAllowEmoji completion:^(NSArray *results) {
        NSLog(@"Text Input Results: %@", results);
        
        if (results[0] != nil) {
            // Sends a non-nil result to the parent iOS application.
            BOOL didOpenParent = [WKInterfaceController openParentApplication:@{@"TextInput" : results[0]} reply:^(NSDictionary *replyInfo, NSError *error) {
                NSLog(@"Reply Info: %@", replyInfo);
                NSLog(@"Error: %@", [error localizedDescription]);
            }];
            
            NSLog(@"Did open parent application? %i", didOpenParent);
        }
    }];

    
}

- (IBAction)menuDeleteAction {

    NSManagedObjectContext* moc = [[ContextsManager sharedManager] getContext];
    [moc deleteObject:self.selectedApplication];
    
    [[ContextsManager sharedManager] saveContext:moc error:nil];

    [self popToRootController];
    
}

@end



