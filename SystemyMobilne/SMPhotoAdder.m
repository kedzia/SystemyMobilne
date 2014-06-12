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
#import "SMLocation+methods.h"
#import "SMPhoto+methods.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreLocation/CoreLocation.h>
#import "ELCImagePickerController.h"
#import "SMAppDelegate.h"

@interface SMPhotoAdder () <ELCImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *moc;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@end
@implementation SMPhotoAdder

- (void)takePhotoInLocation:(CLLocation *)location andSaveInContext:(NSManagedObjectContext *)context
{
    self.moc = context;
    self.location = location;
    NSArray* arr = [UIImagePickerController availableMediaTypesForSourceType:
                    UIImagePickerControllerSourceTypeCamera];
    if ([arr indexOfObject:(NSString*)kUTTypeImage] == NSNotFound) {
        NSLog(@"no stills");
        return; }
    if([self isCameraAvailable])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker = imagePicker;
        imagePicker.showsCameraControls = NO;
        imagePicker.toolbarHidden = NO;
        imagePicker.mediaTypes = @[(NSString*)kUTTypeImage];
        self.imagePicker = imagePicker;
        
        [self.delegate presentViewController:self.imagePicker animated:YES completion:nil];
    }
}

- (void) navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIBarButtonItem *takePhoto = [[UIBarButtonItem alloc] initWithTitle:@"Photo" style:UIBarButtonItemStylePlain target:self.imagePicker action:@selector(takePicture)];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [navigationController.topViewController setToolbarItems:@[cancel,space,takePhoto, space,done]];
}

-(void)addPhotoToLocation:(CLLocation *)location andSaveInContext:(NSManagedObjectContext *)context
{
    self.moc = context;
    self.location = location;
    if([self isPhotoLibraryAvailable])
    {
        ELCImagePickerController *imagePicker = [[ELCImagePickerController alloc] initImagePicker];
        imagePicker.maximumImagesCount = 400; //Set the maximum number of images to select, defaults to 4
        imagePicker.returnsOriginalImage = NO; //Only return the fullScreenImage, not the fullResolutionImage
        imagePicker.imagePickerDelegate = self;
        
        //Present modally
        [self.delegate presentViewController:imagePicker animated:YES completion:nil];
    }
}



-(SMLocation*)checkIfSMLocationExists:(CLLocation*)location
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"SMLocation"];
    fetchRequest.sortDescriptors = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"location = %@",location];
    fetchRequest.predicate = predicate;
    
    NSError *fetchError = nil;
    NSArray *results = [self.moc executeFetchRequest:fetchRequest error:&fetchError];
    if (fetchError)
    {
        NSLog(@"%@", fetchError.localizedDescription);
    }
    
    return results ? [results firstObject] : nil;
}

-(void)savePhotoWithURLs:(NSArray*) urlArray Location:(CLLocation*)location inContext:(NSManagedObjectContext*)context
{
    SMLocation *existingLocation = [self checkIfSMLocationExists:location];
    if(existingLocation == nil)
    {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:location
                       completionHandler:^(NSArray *placemarks, NSError *error){
                           
           if(placemarks != nil)
           {
               [context performBlock:^{
                   CLPlacemark *placemark = [placemarks firstObject];
                   SMLocation *locationEntity = [SMLocation initLocationWithPlacemark:placemark
                                                                             Location:location
                                                                           andContext:context];
                   for (NSURL *url in urlArray)
                   {
                       [SMPhoto initPhotoWith:url
                                         Text:@" " andLocation:locationEntity
                                    inContext:context];
                   }
                   [self.delegate finishedAddingPhotosforLocation:locationEntity];
               }];
           }
           else
           {
               NSLog(@"Error geocode %@", [error localizedDescription]);
           }
       }];
    }
    else
    {
        for (NSURL *url in urlArray)
        {
            [SMPhoto initPhotoWith:url
                              Text:@" " andLocation:existingLocation
                         inContext:context];
        }
    }
}

-(BOOL)isPhotoLibraryAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
}

- (BOOL)isCameraAvailable
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}


#pragma mark UIImagePickerControllerDelegate protocol


- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    if(info.count > 0)
    {
        NSMutableArray *urls = [[NSMutableArray alloc] init];
        for (NSDictionary *infoDictionary in info)
        {
            NSURL *url = [infoDictionary valueForKeyPath:UIImagePickerControllerReferenceURL];
            [urls addObject:url];
        }
    [self savePhotoWithURLs:urls Location:self.location inContext:self.moc];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)elcImagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self cancel];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKeyPath:UIImagePickerControllerOriginalImage];
    ALAssetsLibrary* library = [SMAppDelegate sharedLibrary];
    [library writeImageToSavedPhotosAlbum:image.CGImage orientation:ALAssetOrientationRight completionBlock:^(NSURL *assetURL, NSError *error) {
        if(!error)
        {
            [self savePhotoWithURLs:@[assetURL] Location:self.location inContext:self.moc];
        }
        else
        {
            NSLog(@"saving photo error: %@", error.localizedDescription);
        }
    }];
}

- (void)cancel
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}


@end
