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
    NSString *stringData = [NSString stringWithFormat:@"%@", url];
    NSData *data =  [stringData dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}

-(id) reverseTransformedValue:(id)value
{
    NSString *data = [[NSString alloc] initWithData:(NSData*)value encoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:data];
    return url;
}

@end
