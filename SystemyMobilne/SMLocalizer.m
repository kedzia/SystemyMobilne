//
//  SMLocalizer.m
//  SystemyMobilne
//
//  Created by Adam on 11.06.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import "SMLocalizer.h"
@interface SMLocalizer () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *myLocationManager;
@property (strong, nonatomic) CLLocation *lastLocation;
@end
@implementation SMLocalizer

- (void) startLocalizing
{
    [self.myLocationManager startMonitoringSignificantLocationChanges];
}

- (void) stopLocalizing
{
    [self.myLocationManager stopUpdatingLocation];
}

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        if ([CLLocationManager locationServicesEnabled])
        { self.myLocationManager = [[CLLocationManager alloc] init];
            self.myLocationManager.delegate = self;
            
            [self.myLocationManager startMonitoringSignificantLocationChanges];
        }
        else
        {
            /* Location services are not enabled.
             Take appropriate action: for instance, prompt the
             user to enable the location services */
            NSLog(@"Location services are not enabled");
        }
    }
    return self;
}
- (CLLocation*)getCurrentLocation
{
    return self.lastLocation;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
fromLocation:(CLLocation *)oldLocation
{
    self.lastLocation = newLocation;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"%@", error.localizedDescription);
}


@end
