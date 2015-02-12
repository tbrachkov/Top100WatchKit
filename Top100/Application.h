//
//  Application.h
//  Top100
//
//  Created by Todor Brachkov on 2/11/15.
//  Copyright (c) 2015 Todor Brachkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Application : NSManagedObject

@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * contentType;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * releaseDate;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSString * appID;

@end
