//
//  SMLocalizer.h
//  SystemyMobilne
//
//  Created by Adam on 11.06.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface SMLocalizer : NSObject

-(CLLocation*)getCurrentLocation;
- (void)stopLocalizing;
- (void)startLocalizing;
@end
