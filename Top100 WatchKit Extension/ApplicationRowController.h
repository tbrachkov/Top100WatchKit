//
//  ApplicationRowController.h
//  Top100
//
//  Created by Todor Brachkov on 3/29/15.
//  Copyright (c) 2015 Todor Brachkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WatchKit/WatchKit.h>

@interface ApplicationRowController : NSObject

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *applicationTitleLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *applicationDetailLabel;

@end
