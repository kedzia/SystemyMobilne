//
//  SMPlacemarkTransformer.m
//  SystemyMobilne
//
//  Created by Adam on 10.04.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import "SMPlacemarkTransformer.h"

@implementation SMPlacemarkTransformer

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
    CLPlacemark *placemark = (id)value;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:placemark];
    return data;
}

-(id) reverseTransformedValue:(id)value
{
    NSData *data = (NSData*) value;
    CLPlacemark *placemark = (CLPlacemark*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    return placemark;
}
@end
