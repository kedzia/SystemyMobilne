//
//  SMFacebookPhotoSender.h
//  SystemyMobilne
//
//  Created by Adam on 24.05.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "SMFacebookPhoto.h"
#import "SMSheetVC.h"

@interface SMFacebookPhotoSender : NSObject @property (weak, nonatomic) UIViewController *delegate;

-(void)LogInAndUploadPhotos:(NSArray*)photosArray toAlbum:(NSString*)albumName;
@end
