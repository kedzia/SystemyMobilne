//
//  SMPhoto+methods.h
//  SystemyMobilne
//
//  Created by Adam on 11.04.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import "SMPhoto.h"
#import "SMLocation.h"

@interface SMPhoto (methods) <NSCoding>

+(instancetype)initPhotoWith:(NSURL*)url Text:(NSString*)text andLocation:(SMLocation*)location inContext:(NSManagedObjectContext*) context;
@end
