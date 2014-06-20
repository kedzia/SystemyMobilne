//
//  SMLocationTransformer.m
//  SystemyMobilne
//
//  Created by Adam on 16.04.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import "SMLocationTransformer.h"
#import <CoreLocation/CoreLocation.h>

@implementation SMLocationTransformer

+(BOOL)allowsReverseTransformation
{
    return YES;
}
+(Class)transformedValueClass
{
    return [NSData class];
}

-(id)transformedValue:(id)value
{
    CLLocation *location = (id)value;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:location];
    return data;
}

-(id) reverseTransformedValue:(id)value
{
    NSData *data = (NSData*) value;
    CLLocation *location = (CLLocation*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    return location;
}
@end
