//
//  SMPhotosCVCell.m
//  SystemyMobilne
//
//  Created by Adam on 25.04.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import "SMPhotosCVCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SMAppDelegate.h"

@implementation SMPhotosCVCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)viewWithALAssetURL:(NSURL *)paramURL
{
    [[self.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
  [self retrieveImageFromAssestsWithURL:paramURL forView:self.contentView];
}

-(void)retrieveImageFromAssestsWithURL:(NSURL*)paramURL forView:(UIView*) paramView;
{
    ALAssetsLibraryAssetForURLResultBlock resultBlock = ^(ALAsset *myAsset)
    {
        CGImageRef imgRef = [myAsset thumbnail];
        UIImage *largeImage = [UIImage imageWithCGImage:imgRef];
        
            if(imgRef)
            {
                UIImageView *imv = [[UIImageView alloc] initWithImage:largeImage];
                //imv.autoresizingMask = UIViewContentModeScaleAspectFit;
                imv.frame = CGRectMake(0, 0, 140, 140);
                paramView.frame = imv.frame;
                [paramView addSubview:imv];
            }
    };
    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
    {
        NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
    };
    
    ALAssetsLibrary* assetslibrary = [SMAppDelegate sharedLibrary];
    [assetslibrary assetForURL:paramURL
                   resultBlock:resultBlock
                  failureBlock:failureblock];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
