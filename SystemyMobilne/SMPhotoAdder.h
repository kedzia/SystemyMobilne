//
//  SMPhotoAdder.h
//  SystemyMobilne
//
//  Created by Adam on 16.04.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SMPhotoAdder : NSObject
@property (weak, nonatomic) UIViewController *delegate;
-(void)addPhotoToLocation:(CLLocation *)location andSaveInContext:(NSManagedObjectContext*)context;

@end
