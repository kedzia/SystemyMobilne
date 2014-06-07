//
//  SMLocation+methods.h
//  SystemyMobilne
//
//  Created by Adam on 11.04.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import "SMLocation.h"

@interface SMLocation (methods) <NSCoding>

+(instancetype)initLocationWithPlacemark:(CLPlacemark*)placemark Location:(CLLocation*)location Name:(NSString*) name andContext:(NSManagedObjectContext*)context;

+ (instancetype)initLocationWithPlacemark:(CLPlacemark*)placemark Location:(CLLocation*)location andContext:(NSManagedObjectContext*)context;

@end
