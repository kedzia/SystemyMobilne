//
//  SMLocation+methods.m
//  SystemyMobilne
//
//  Created by Adam on 11.04.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import "SMLocation+methods.h"
#import "SMAppDelegate.h"

@implementation SMLocation (methods)
+(instancetype)initLocationWithPlacemark:(CLPlacemark *)placemark
                                Location:(CLLocation *)location
                                    Name:(NSString *)name
                              andContext:(NSManagedObjectContext *)context

{
    SMLocation *locationEntity = [NSEntityDescription insertNewObjectForEntityForName:@"SMLocation" inManagedObjectContext:context];
    if(locationEntity != nil)
    {
        locationEntity.placemark = placemark;
        locationEntity.location = location;
        locationEntity.name = name;
    }
    else
    {
        NSLog(@"Couldn't create proper location entity");
    }
    
    return locationEntity;
}

+(instancetype)initLocationWithPlacemark:(CLPlacemark *)placemark Location:(CLLocation *)location andContext:(NSManagedObjectContext *)context
{
    NSString *parsedName = [NSString stringWithFormat:@"%@ ,%@ ,%@",placemark.country,placemark.subAdministrativeArea, placemark.locality ];
    
    return [SMLocation initLocationWithPlacemark:placemark
                                        Location:location
                                            Name:parsedName
                                      andContext:context];
}


-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[self.objectID URIRepresentation] forKey:@"managedObjectID"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    NSURL*   url = [aDecoder decodeObjectForKey:@"managedObjectID"];
    NSManagedObjectContext *moc = [(SMAppDelegate*)[[UIApplication sharedApplication] delegate] sharedManagedObjectContext];
    NSManagedObjectID*   oid = [moc.persistentStoreCoordinator managedObjectIDForURIRepresentation:url];
    return (SMLocation*)[moc objectWithID:oid];
}
@end
