//
//  SMPhotosCVCell.m
//  SystemyMobilne
//
//  Created by Adam on 25.04.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import "SMPhotosCVCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation SMPhotosCVCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(instancetype)initWithALAssetURL:(NSURL *)paramURL
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}

-(void)retrieveImageFromAssestsWithURL:(NSURL*)paramURL forView:(UIView*) paramView;
{
    ALAssetsLibraryAssetForURLResultBlock resultBlock = ^(ALAsset *myAsset)
    {
        ALAssetRepresentation *rep = [myAsset defaultRepresentation];
        CGImageRef imgRef = [rep fullResolutionImage];
        if(imgRef)
        {
            UIImage *largeImage = [UIImage imageWithCGImage:imgRef];
            
            UIImageView *imv = [[UIImageView alloc] initWithImage:largeImage];
            imv.autoresizingMask = UIViewContentModeScaleToFill;
            imv.frame = CGRectMake(0, 0, 35, 35);
            paramView.frame = imv.frame;
            [paramView addSubview:imv];
        }
    };
    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
    {
        NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
    };
    
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
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
