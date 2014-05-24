//
//  SMPhotoViewController.h
//  SystemyMobilne
//
//  Created by Adam on 28.04.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMPhoto.h"

@interface SMPhotoViewController : UIViewController

@property (strong, nonatomic) NSIndexPath *indexPath;

-(instancetype) initWithIndex:(NSIndexPath*) paramIndexPath andPhoto:(SMPhoto*)paramPhoto;
-(SMPhoto*) selectedPhoto;
-(void)updateText:(NSString *)paramText;
-(UIImage*)getImage;
@end
