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
#import "SMLocalizer.h"


#define ANNO_VIEW_ID @"SMAnnotationView"
#define iphoneScaleFactorLatitude 10.0f
#define iphoneScaleFactorLongitude 10.0f

@interface SMViewController () <SMPhotoAdderProtocol, MKMapViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) SMPhotoAdder *photoAdder;
@property (nonatomic) MKZoomScale previousZoomScale;
@property (strong, nonatomic) NSMutableArray *locationsArray;
@property (strong, nonatomic) SMAnnotation * lastModifiedAnnotation;
@property (strong, nonatomic) UILongPressGestureRecognizer *longGestureRecognizer;
@property (strong, nonatomic) UIBarButtonItem *addPhotoButton;
@property (strong, nonatomic) SMLocalizer *myLocalizer;


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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.restorationIdentifier = @"SMViewController";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myLocalizer = [[SMLocalizer alloc] init];
    self.longGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    self.longGestureRecognizer.delegate = self;
    self.longGestureRecognizer.enabled = NO;
    [self.mapView addGestureRecognizer:self.longGestureRecognizer];
    [self loadMap];
    self.title = @"Map";
    self.previousZoomScale = [self zoomLevelForMap];
    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbar.translucent = YES;
    
    self.addPhotoButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pressedStartAddingPhoto)];
    UIBarButtonItem *camera = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takePhoto)];
    
    [self setToolbarItems:@[self.addPhotoButton,camera]];
    
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
        CGImageRef imgRef = [rep fullScreenImage];
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

- (void)takePhoto
{
    CLLocation *location = [self.myLocalizer getCurrentLocation];
    if(location)
    {
        if(self.photoAdder == nil)
        {
            self.photoAdder = [[SMPhotoAdder alloc] init];
            self.photoAdder.delegate = self;
        }
        [self.photoAdder takePhotoInLocation:location
                           andSaveInContext:self.managedObjectContext];
    }
}

- (void)pressedStartAddingPhoto
{
    self.longGestureRecognizer.enabled = !self.longGestureRecognizer.enabled;
    if(self.addPhotoButton.tintColor == nil)
    {
        self.addPhotoButton.tintColor = [UIColor redColor];
    }
    else
    {
        self.addPhotoButton.tintColor = nil;
    }
}
-(void)longPress:(UILongPressGestureRecognizer*) sender
{
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        CGPoint touchLocation = [sender locationInView:self.mapView];
        CLLocation *location = nil;
  
        CLLocationCoordinate2D locCoord = [self.mapView convertPoint:touchLocation
                                                toCoordinateFromView:self.mapView];
        location = [[CLLocation alloc] initWithLatitude:locCoord.latitude longitude:locCoord.longitude];
        
        for(SMAnnotation *annotation in self.mapView.annotations)
        {
            if(CGRectContainsPoint([self.mapView viewForAnnotation:annotation].frame, touchLocation))
            {
                location = [(SMLocation*)[annotation.locationsArray firstObject] location];
                if(annotation.locationsArray.count > 1)
                {
                    return; //preventing forbidden operation
                }
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
        
        [self pressedStartAddingPhoto];
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

#pragma mark state preservation and restoration

-(void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super encodeRestorableStateWithCoder:coder];
     if(self.mapView)
     {
         [coder encodeObject:self.mapView.camera forKey:@"camera"];
     }
}

-(void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    MKMapCamera *camera = [coder decodeObjectForKey:@"camera"];
    if(camera)
    {
        self.mapView.camera = camera;
    }
}

#pragma mark mapView delegate
- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

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
        SMAnnotation *smAnnotation = (SMAnnotation*) annotation;
        annotationView = [[SMAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ANNO_VIEW_ID];
   
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

- (NSFetchedResultsController *)createFetchRCforPhtotWithPredicate:(NSPredicate*)paramPredicate
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"SMPhoto"];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"location.name" ascending:YES];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:descriptor];
    fetchRequest.predicate = paramPredicate;
    
    NSFetchedResultsController *fetchedRC = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"location.name" cacheName:nil];
    return fetchedRC;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if([view.annotation isKindOfClass:[SMAnnotation class]])
    {
        SMAnnotation *anno = (SMAnnotation*)view.annotation;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"location IN %@", anno.locationsArray];
        NSFetchedResultsController *fetchedRC = [self createFetchRCforPhtotWithPredicate:predicate];
        SMPhotosCVC *photoCVC = [[SMPhotosCVC alloc] initWithRequest:fetchedRC];
        photoCVC.title = anno.title;
        photoCVC.restorationIdentifier = @"PhotosCVC";
        
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
    NSError *error = nil;
    [self.managedObjectContext save:&error];
    if(error)
    {
        NSLog(@"%@", error.description);
    }
    int emptyLocationCounter = 0;
    for(SMLocation *location in annotation.locationsArray)
    {
        if(location.photos.count == 0)
        {
            [self.locationsArray removeObject:location];
            [location.managedObjectContext deleteObject:location];
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
    [self.navigationController.navigationBar setHidden:YES];
    self.navigationController.toolbarHidden = NO;
    [self.myLocalizer startLocalizing];
    if(self.lastModifiedAnnotation)
    {
        [self checkIfAnnotationIsValid:self.lastModifiedAnnotation];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.toolbarHidden = YES;
     [self.myLocalizer stopLocalizing];
     [self.myLocalizer stopLocalizing];
}


@end
