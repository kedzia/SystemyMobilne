//
//  SMAnnotationView.h
//  SystemyMobilne
//
//  Created by Adam on 09.05.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "SMAnnotation.h"

@interface SMAnnotationView : MKPinAnnotationView

- (void)setPinColorForAnnotation:(SMAnnotation *)annotation;
@end
