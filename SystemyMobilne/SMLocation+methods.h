//
//  SMLocation+methods.h
//  SystemyMobilne
//
//  Created by Adam on 11.04.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import "SMLocation.h"

@interface SMLocation (methods)

+(instancetype)initLocationWithPlacemark:(CLPlacemark*)placemark andContext:(NSManagedObjectContext*)context;
@end
