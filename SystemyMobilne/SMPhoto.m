//
//  SMPhoto.m
//  SystemyMobilne
//
//  Created by Adam on 11.04.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import "SMPhoto.h"
#import "SMLocation.h"
#import "SMAppDelegate.h"


@implementation SMPhoto

@dynamic photoURL;
@dynamic descritptionText;
@dynamic location;


-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[self.objectID URIRepresentation] forKey:@"managedObjectID"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    NSURL*   url = [aDecoder decodeObjectForKey:@"managedObjectID"];
    NSManagedObjectContext *moc = [(SMAppDelegate*)[[UIApplication sharedApplication] delegate] sharedManagedObjectContext];
    NSManagedObjectID*   oid = [moc.persistentStoreCoordinator managedObjectIDForURIRepresentation:url];
    return (SMPhoto*)[moc objectWithID:oid];
}

@end
