//
//  SMSheetVC.h
//  SystemyMobilne
//
//  Created by Adam on 11.06.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMFacebookPhotoSender.h"

@protocol SMSheetVCProtocol
- (void)choosenPrivacy:(NSString*)paramPrivacy;

@end
@interface SMSheetVC : UIViewController

@property (weak, nonatomic) id<SMSheetVCProtocol> delegate;
@end
