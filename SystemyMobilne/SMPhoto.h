//
//  SMPhoto.h
//  SystemyMobilne
//
//  Created by Adam on 11.04.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SMLocation;

@interface SMPhoto : NSManagedObject 

@property (nonatomic, retain) NSURL * photoURL;
@property (nonatomic, retain) NSString * descritptionText;
@property (nonatomic, retain) SMLocation *location;

@end
