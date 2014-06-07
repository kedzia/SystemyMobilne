//
//  SMPhoto+methods.m
//  SystemyMobilne
//
//  Created by Adam on 11.04.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import "SMPhoto+methods.h"
#import "SMAppDelegate.h"

@implementation SMPhoto (methods)
+(instancetype)initPhotoWith:(NSURL *)url
                        Text:(NSString *)text
                 andLocation:(SMLocation *)location
                   inContext:(NSManagedObjectContext *)context
{
    SMPhoto *photoEntity = [NSEntityDescription insertNewObjectForEntityForName:@"SMPhoto" inManagedObjectContext:context];
    if(photoEntity != nil)
    {
        photoEntity.descritptionText = text;
        photoEntity.location = location;
        photoEntity.photoURL = url;
        [location addPhotosObject: photoEntity];
    }
    else
    {
        NSLog(@"Couldn't create proper Photo Entity");
    }
    
    return photoEntity;
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
    return (SMPhoto*)[moc objectWithID:oid];
}

@end
