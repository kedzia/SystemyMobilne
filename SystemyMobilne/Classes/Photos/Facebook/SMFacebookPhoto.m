//
//  SMFecbookPhoto.m
//  SystemyMobilne
//
//  Created by Adam on 11.06.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import "SMFacebookPhoto.h"

@implementation SMFacebookPhoto
-(instancetype)initWithImage:(UIImage *)paramImage andDescription:(NSString *)paramDescription
{
    self = [super init];
    if(self)
    {
        _image = paramImage;
        _description = paramDescription;
    }
    
    return self;
}
@end
