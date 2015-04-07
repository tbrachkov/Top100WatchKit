//
//  DetailViewController.h
//  Top100
//
//  Created by Todor Brachkov on 2/10/15.
//  Copyright (c) 2015 Todor Brachkov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailTransition.h"

@import DataShareKit;

#define isIOS7 floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1

@interface DetailViewController : UIViewController

@property (strong, nonatomic) Application* detailItem;
@property (nonatomic, strong) id<TransitionGestureTarget> gestureTarget;

@end

