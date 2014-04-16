//
//  SMLocation+methods.m
//  SystemyMobilne
//
//  Created by Adam on 11.04.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import "SMLocation+methods.h"

@implementation SMLocation (methods)
+(instancetype)initLocationWithPlacemark:(CLPlacemark *)placemark andContext:(NSManagedObjectContext *)context
{
    SMLocation *locationEntity = [NSEntityDescription insertNewObjectForEntityForName:@"SMLocation" inManagedObjectContext:context];
    if(locationEntity != nil)
    {
        locationEntity.placemark = placemark;
    }
    else
    {
        NSLog(@"Couldn't create proper location entity");
    }
    
    return locationEntity;
}
@end
