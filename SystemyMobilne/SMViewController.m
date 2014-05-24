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
#import "SMAnnotationView.h"


#define ANNO_VIEW_ID @"SMAnnotationView"
#define iphoneScaleFactorLatitude 10.0f
#define iphoneScaleFactorLongitude 10.0f

@interface SMViewController () <SMPhotoAdderProtocol, MKMapViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) SMPhotoAdder *photoAdder;
@property (nonatomic) MKZoomScale previousZoomScale;
@property (strong, nonatomic) NSMutableArray *locationsArray;
@property (strong, nonatomic) SMAnnotation * lastModifiedAnnotation;


@end

@implementation SMViewController

-(void)finishedAddingPhotosforLocation:(SMLocation *)paramLocation
{
    [self addAnnotationForLocation:paramLocation];
    [self.locationsArray addObject:paramLocation];

}


- (void)addAnnotationForLocation:(SMLocation *)location
{
    SMAnnotation *annotation = [[SMAnnotation alloc]
                                initWithCoordinates:location.location.coordinate
                                title:location.name
                                subTitle:nil
                                URL:[[location.photos anyObject] photoURL]
                                location:location];
    
    [self.mapView addAnnotation:annotation];
}

-(void)loadMap
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"SMLocation"];
    NSError *requestError = nil;
    NSArray *locationArray = [self.managedObjectContext executeFetchRequest:request error:&requestError];
    if(requestError == nil)
    {   if(self.locationsArray == nil)
        {
            self.locationsArray = [[NSMutableArray alloc] initWithCapacity:locationArray.count];
        }
        [self.locationsArray addObjectsFromArray:locationArray];
        [self updateMap];
    }
   
}

-(void) updateMap
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    float latDelta= iphoneScaleFactorLatitude;
    float longDelta= iphoneScaleFactorLongitude;
    BOOL found = NO;
    for(SMLocation *location in self.locationsArray)
    {
        CGPoint loc =[self.mapView convertCoordinate:location.location.coordinate toPointToView:self.mapView];
        for(SMAnnotation *anno in self.mapView.annotations)
        {
            CGPoint annoPoint = [self.mapView convertCoordinate:anno.coordinate toPointToView:self.mapView];
            if(abs(annoPoint.x-loc.x)<latDelta &&
               abs(annoPoint.y - loc.y)<longDelta)
            {
                found = YES;
                [anno.locationsArray addObject:location];
                break;
            }
        }
        if(found == NO)
        {
            [self addAnnotationForLocation:location];
        }
        found = NO;
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
    [self loadMap];
    self.title = @"Map";
    self.previousZoomScale = [self zoomLevelForMap];
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

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    BOOL result = NO;
    if([otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
    {
        result = YES;
    }
    return result;
}

#pragma mark mapView delegate

- (MKZoomScale)zoomLevelForMap
{
    MKZoomScale zoomScale = self.mapView.bounds.size.width/self.mapView.visibleMapRect.size.width;
    return zoomScale;
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if(self.previousZoomScale != [self zoomLevelForMap])
    {
        [self updateMap];
    }
    self.previousZoomScale = [self zoomLevelForMap];
}
-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    SMAnnotationView *annotationView = nil;
    if([annotation isKindOfClass:[SMAnnotation class]])
    {
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] init];
        [recognizer addTarget:self action:@selector(annotationLongPress:)];
        recognizer.delegate = self;
        recognizer.allowableMovement = 0.0f;
        
        SMAnnotation *smAnnotation = (SMAnnotation*) annotation;
        annotationView = [[SMAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ANNO_VIEW_ID];
        if(smAnnotation.locationsArray.count == 1)
        {
            [annotationView addGestureRecognizer:recognizer];
        }
        
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
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"location.name" ascending:YES];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"location IN %@", anno.locationsArray];
        
        fetchRequest.sortDescriptors = [NSArray arrayWithObject:descriptor];
        fetchRequest.predicate = predicate;
      
        NSFetchedResultsController *fetchedRC = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"location.name" cacheName:nil];
        SMPhotosCVC *photoCVC = [[SMPhotosCVC alloc] initWithRequest:fetchedRC];
        photoCVC.title = anno.title;
        
        self.lastModifiedAnnotation = anno;
        
        [[self navigationController] pushViewController:photoCVC animated:YES];
        
        
    }
    else
    {
        NSLog(@"Unknow annotation passed");
    }
}

-(void)checkIfAnnotationIsValid:(SMAnnotation*) annotation
{
    int emptyLocationCounter = 0;
    for(SMLocation *location in annotation.locationsArray)
    {
        if(location.photos.count == 0)
        {
            [self.locationsArray removeObject:location];
            emptyLocationCounter ++;
        }
    }
    if(emptyLocationCounter == annotation.locationsArray.count)
    {
        [self.mapView removeAnnotations:@[annotation]];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self navigationController].navigationBarHidden = YES;
    if(self.lastModifiedAnnotation)
    {
        [self checkIfAnnotationIsValid:self.lastModifiedAnnotation];
    }
}

@end
