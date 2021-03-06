//
//  SMPhotoAdder.h
//  SystemyMobilne
//
//  Created by Adam on 16.04.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "SMLocation.h"

@protocol SMPhotoAdderProtocol
-(void)finishedAddingPhotosforLocation:(SMLocation*) paramLocation;
@end
@interface SMPhotoAdder : NSObject
@property (weak, nonatomic) UIViewController<SMPhotoAdderProtocol> *delegate;
-(void)addPhotoToLocation:(CLLocation *)location andSaveInContext:(NSManagedObjectContext*)context;
-(void)takePhotoInLocation:(CLLocation *)location andSaveInContext:(NSManagedObjectContext *)context;
@end
