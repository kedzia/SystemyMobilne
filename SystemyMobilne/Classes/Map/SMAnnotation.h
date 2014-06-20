//
//  SMAnnotation.h
//  SystemyMobilne
//
//  Created by Adam on 24.04.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMLocation.h"
#import <MapKit/MapKit.h>

@interface SMAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *subtitle;
@property (nonatomic, copy, readonly) NSURL *photoURL;
@property (nonatomic,readonly) NSMutableArray *locationsArray;

- (instancetype) initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates
                               title:(NSString *)paramTitle
                            subTitle:(NSString *)paramSubTitle
                                 URL:(NSURL*) paramPhotoURL;

- (instancetype) initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates
                               title:(NSString *)paramTitle
                            subTitle:(NSString *)paramSubTitle
                                 URL:(NSURL*) paramPhotoURL
                            location:(SMLocation*)paramlocation;
@end
