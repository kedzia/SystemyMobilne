//
//  SMAnnotation.m
//  SystemyMobilne
//
//  Created by Adam on 24.04.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import "SMAnnotation.h"

@implementation SMAnnotation

-(instancetype)initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates
                             title:(NSString *)paramTitle
                          subTitle:(NSString *)paramSubTitle
                               URL:(NSURL *)paramPhotoURL
{
    self = [super init];
    if(self)
    {
        _title = paramTitle;
        _subtitle = paramSubTitle;
        _coordinate = paramCoordinates;
        _photoURL = paramPhotoURL;
    }
    return self;
}

-(instancetype)initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates title:(NSString *)paramTitle subTitle:(NSString *)paramSubTitle URL:(NSURL *)paramPhotoURL location:(SMLocation *)paramlocation
{
    self = [self initWithCoordinates:paramCoordinates title:paramTitle subTitle:paramSubTitle URL:paramPhotoURL];
    if(self)
    {
       _locationsArray = [[NSMutableArray alloc] init];
        [_locationsArray addObject:paramlocation];
    }
    return self;
}

-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    NSAssert(_locationsArray.count == 1, @"cannot drag annotation that contains many placemarks");
    _coordinate = newCoordinate;
    __block SMLocation *location = [_locationsArray firstObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:newCoordinate.latitude longitude:newCoordinate.longitude];
    location.location = newLocation;
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if(placemarks != nil)
         {
             
             location.placemark = [placemarks firstObject];
         }
         else
         {
             NSLog(@"Geocode error:%@", error.localizedDescription);
         }
         
     }];
}

@end
