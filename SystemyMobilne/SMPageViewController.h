//
//  SMPageViewController.h
//  SystemyMobilne
//
//  Created by Adam on 05.05.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMPhoto.h"
#import "SMLocation.h"
#import "SMTextViewController.h"
#import "SMPhotoViewController.h"

@interface SMPageViewController : UIPageViewController <SMPhotoTextDelegate>
@property (weak, nonatomic) SMPhotoViewController* photoDelegate;

@end
