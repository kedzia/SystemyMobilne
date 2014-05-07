//
//  SMPhotoScrollView.h
//  SystemyMobilne
//
//  Created by Adam on 28.04.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMPhotoScrollView : UIScrollView

-(instancetype) initWithImageFromURL:(NSURL*) paramURL andFrame:(CGRect) paramFrame;
@end
