//
//  SMLocation.h
//  SystemyMobilne
//
//  Created by Adam on 11.04.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>

@class SMPhoto;

@interface SMLocation : NSManagedObject <NSCoding>

@property (nonatomic, retain) CLPlacemark *placemark;
@property (nonatomic, retain) CLLocation *location;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSSet *photos;
@end

@interface SMLocation (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(SMPhoto *)value;
- (void)removePhotosObject:(SMPhoto *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;



@end
