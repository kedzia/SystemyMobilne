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


@interface SMViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@end

@implementation SMViewController




-(void)updateMap
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"SMLocation"];
    NSError *requestError = nil;
    NSArray *locationArray = [self.managedObjectContext executeFetchRequest:request error:&requestError];
    if(requestError == nil)
    {
        for(SMLocation *location in locationArray)
        {
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.coordinate = location.placemark.location.coordinate;
            annotation.title = location.placemark.locality;
            annotation.subtitle = location.placemark.name;
            
            [self.mapView addAnnotation:annotation];
        }
    }

}



- (IBAction)testButtonPressed:(UIButton*)sender
{
    
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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
