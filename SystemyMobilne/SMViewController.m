//
//  SMViewController.m
//  SystemyMobilne
//
//  Created by Adam on 10.04.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import "SMViewController.h"
#import "SMPersistentStore.h"
#import <MapKit/MapKit.h>
#import "SMPhoto.h"
#import "SMLocation.h"
#import "SMLocation+methods.h"
#import "SMPhoto+methods.h"
#import "SMPhotoAdder.h"
#import "SMAnnotation.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SMPhotosCVC.h"


#define ANNO_VIEW_ID @"SMAnnotationView"

@interface SMViewController () <SMPhotoAdderProtocol, MKMapViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) SMPhotoAdder *photoAdder;


@end

@implementation SMViewController

-(void)finishedAddingPhotos
{
    [self updateMap];
}


-(void)updateMap
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"SMLocation"];
    NSError *requestError = nil;
    NSArray *locationArray = [self.managedObjectContext executeFetchRequest:request error:&requestError];
    if(requestError == nil)
    {
        for(SMLocation *location in locationArray)
        {
            SMAnnotation *annotation = [[SMAnnotation alloc]
                                        initWithCoordinates:location.location.coordinate
                                        title:location.name
                                        subTitle:nil
                                        URL:[[location.photos anyObject] photoURL]
                                        location:location];
            
            [self.mapView addAnnotation:annotation];
        }
    }
   
}

-(void)longPressRecognized:(UILongPressGestureRecognizer*) sender
{
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        
        CLLocation *location = nil;
        CGPoint touchCoordinate = [sender locationInView:self.mapView];
        
        
        CLLocationCoordinate2D locCoord = [self.mapView convertPoint:touchCoordinate
                                                toCoordinateFromView:self.mapView];
        location = [[CLLocation alloc] initWithLatitude:locCoord.latitude longitude:locCoord.longitude];
        
        if(!self.photoAdder)
        {
            self.photoAdder = [[SMPhotoAdder alloc] init];
            self.photoAdder.delegate = self;
        }
        
        [self.photoAdder addPhotoToLocation:location andSaveInContext:self.managedObjectContext];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognized:)];
    
    [self.mapView addGestureRecognizer:recognizer];
    [self updateMap];
    self.title = @"Map";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)retrieveImageFromAssestsWithURL:(NSURL*)paramURL forView:(UIView*) paramView;
{
    ALAssetsLibraryAssetForURLResultBlock resultBlock = ^(ALAsset *myAsset)
    {
        ALAssetRepresentation *rep = [myAsset defaultRepresentation];
        CGImageRef imgRef = [rep fullResolutionImage];
        if(imgRef)
        {
            UIImage *largeImage = [UIImage imageWithCGImage:imgRef];
            
            UIImageView *imv = [[UIImageView alloc] initWithImage:largeImage];
            imv.autoresizingMask = UIViewContentModeScaleToFill;
            imv.frame = CGRectMake(0, 0, 35, 35);
            paramView.frame = imv.frame;
            [paramView addSubview:imv];
        }
    };
    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
    {
        NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
    };
    
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:paramURL
                   resultBlock:resultBlock
                  failureBlock:failureblock];
    
}

-(void)annotationLongPress:(UILongPressGestureRecognizer*) sender
{
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        CGPoint touchLocation = [sender locationInView:self.mapView];
        CLLocation *location = nil;
        for(SMAnnotation *annotation in self.mapView.annotations)
        {
            
            if(CGRectContainsPoint([self.mapView viewForAnnotation:annotation].frame, touchLocation))
            {
                location = [(SMLocation*)[annotation.locationsArray firstObject] location];
                break;
            }
            
        }
        if(!self.photoAdder)
        {
            self.photoAdder = [[SMPhotoAdder alloc] init];
            self.photoAdder.delegate = self;
        }
        
        [self.photoAdder addPhotoToLocation:location
                           andSaveInContext:self.managedObjectContext];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
#pragma mark mapView delegate

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *annotationView = nil;
    if([annotation isKindOfClass:[SMAnnotation class]])
    {
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] init];
        [recognizer addTarget:self action:@selector(annotationLongPress:)];
        recognizer.delegate = self;
        
        SMAnnotation *smAnnotation = (SMAnnotation*) annotation;
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ANNO_VIEW_ID];
        [annotationView addGestureRecognizer:recognizer];
        annotationView.pinColor = MKPinAnnotationColorPurple;
        annotationView.animatesDrop = YES;
        annotationView.canShowCallout = YES;
        
        UIButton *accesorButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [accesorButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        
        annotationView.rightCalloutAccessoryView = accesorButton;
        annotationView.leftCalloutAccessoryView = [[UIView alloc] init];
        
        [self retrieveImageFromAssestsWithURL:smAnnotation.photoURL forView:annotationView.leftCalloutAccessoryView];

        
    }
    else
    {
        NSLog(@"wrong annotation passed");
    }
    
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if([view.annotation isKindOfClass:[SMAnnotation class]])
    {
        SMAnnotation *anno = (SMAnnotation*)view.annotation;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"SMPhoto"];
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"descritptionText" ascending:YES];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"location = %@"
                                                    argumentArray:anno.locationsArray ];
        
        fetchRequest.sortDescriptors = [NSArray arrayWithObject:descriptor];
        fetchRequest.predicate = predicate;
      
        NSFetchedResultsController *fetchedRC = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        SMPhotosCVC *photoCVC = [[SMPhotosCVC alloc] initWithRequest:fetchedRC];
        photoCVC.title = anno.title;
        
        [[self navigationController] pushViewController:photoCVC animated:YES];
        
        
    }
    else
    {
        NSLog(@"Unknow annotation passed");
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self navigationController].navigationBarHidden = YES;
}

@end
