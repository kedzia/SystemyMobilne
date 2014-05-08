//
//  SMTextViewController.h
//  SystemyMobilne
//
//  Created by Adam on 07.05.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SMPhotoTextDelegate
-(void)textForPhoto:(NSString*)paramText;
@end
@interface SMTextViewController : UIViewController

@property (weak, nonatomic) id<SMPhotoTextDelegate> delegate;
-(instancetype)initWithText:(NSString*)paramText;
@end
