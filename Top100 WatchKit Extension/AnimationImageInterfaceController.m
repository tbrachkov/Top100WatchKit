//
//  AnimationImageInterfaceController.m
//  Top100
//
//  Created by Todor Brachkov on 4/3/15.
//  Copyright (c) 2015 Todor Brachkov. All rights reserved.
//

#import "AnimationImageInterfaceController.h"

@interface AnimationImageInterfaceController ()

@property (weak, nonatomic) IBOutlet WKInterfaceImage *animationImageView;

@end

@implementation AnimationImageInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
//    Create animated images
    [self.animationImageView setImageNamed:@"dragon-"];
    [self.animationImageView startAnimatingWithImagesInRange:NSMakeRange(0, 60) duration:1.0 repeatCount:0];
    
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}



@end
