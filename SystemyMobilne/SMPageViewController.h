//
//  SMPageViewController.h
//  SystemyMobilne
//
//  Created by Adam on 05.05.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMPhoto.h"
#import "SMTextViewController.h"
@protocol SMPhotoProtocol
-(SMPhoto*) selectedPhoto;
-(void)updateText:(NSString*) paramText;
@end
@interface SMPageViewController : UIPageViewController <SMPhotoTextDelegate>
@property (weak, nonatomic) UIViewController<SMPhotoProtocol> *photoDelegate;

@end
