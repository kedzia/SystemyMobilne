//
//  SMURLTransformer.m
//  SystemyMobilne
//
//  Created by Adam on 16.04.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import "SMURLTransformer.h"

@implementation SMURLTransformer

+(BOOL)allowsReverseTransformation
{
    return YES;
}
+(Class)transformedValueClass
{
    return [NSString class];
}

-(id)transformedValue:(id)value
{
    NSURL *url = (id)value;
    NSString *data = [NSString stringWithFormat:@"%@", url];
    return data;
}

-(id) reverseTransformedValue:(id)value
{
    NSString *data = (NSString*) value;
    NSURL *url = [NSURL URLWithString:data];
    return url;
}

@end
