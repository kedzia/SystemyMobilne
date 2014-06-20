//
//  SMFecbookPhoto.h
//  SystemyMobilne
//
//  Created by Adam on 11.06.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMFacebookPhoto : NSObject
@property (strong, nonatomic, readonly) UIImage *image;
@property (strong, nonatomic, readonly) NSString *description;

- (instancetype) initWithImage:(UIImage*) paramImage andDescription:(NSString*) paramDescription;
@end

