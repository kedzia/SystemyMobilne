//
//  SMPhotoAdder.m
//  SystemyMobilne
//
//  Created by Adam on 16.04.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import "SMPhotoAdder.h"
#import "SMPersistentStore.h"
#import "SMPhoto.h"
#import "SMLocation.h"
#import "SMLocation+methods.h"
#import "SMPhoto+methods.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface SMPhotoAdder () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *moc;
@property (strong, nonatomic) CLLocation *location;
@end
@implementation SMPhotoAdder

-(void)addPhotoToLocation:(CLLocation *)location andSaveInContext:(NSManagedObjectContext *)context
{
    self.moc = context;
    self.location = location;
    if([self isPhotoLibraryAvailable])
    {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        NSMutableArray *photos = [[NSMutableArray alloc] init];
        [photos addObject:(__bridge NSString *)kUTTypeImage];
        
        imagePickerController.mediaTypes = photos;
        imagePickerController.delegate = self;
        
        [self.delegate presentViewController:imagePickerController animated:YES completion:nil];
    }
}

-(void)savePhotoWithURL:(NSURL*) url Location:(CLLocation*)location inContext:(NSManagedObjectContext*)context
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray *placemarks, NSError *error){

        if(placemarks != nil)
        {
            [context performBlock:^{
                for(CLPlacemark *placemark in placemarks)
                {
                    NSLog(@"Location: %f, %f", location.coordinate.longitude, location.coordinate.latitude);
                    NSLog(@"Placemark: %f, %f", placemark.location.coordinate.longitude, placemark.location.coordinate.latitude);
                    
                    SMLocation *locationEntity = [SMLocation initLocationWithPlacemark:placemark Location:location andContext:context];
                    [SMPhoto initPhotoWith:url
                                      Text:@" " andLocation:locationEntity
                                 inContext:context];
                }
                [self.delegate finishedAddingPhotos];
            }];
           
        }
        else
        {
            NSLog(@"Error geocode %@", [error localizedDescription]);
        }
        
    }];
    
    
    
    
}

-(BOOL)isPhotoLibraryAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
}

#pragma mark UIImagePickerControllerDelegate protocol

-(void)imagePickerController:(UIImagePickerController *)picker
       didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSURL *url = [info valueForKeyPath:UIImagePickerControllerReferenceURL];
    [self savePhotoWithURL:url Location:self.location inContext:self.moc];
   
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


@end
