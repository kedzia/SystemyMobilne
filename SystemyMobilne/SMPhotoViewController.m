//
//  SMPhotoViewController.m
//  SystemyMobilne
//
//  Created by Adam on 28.04.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import "SMPhotoViewController.h"
#import "SMPhotoScrollView.h"


@interface SMPhotoViewController ()

@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) SMPhoto *photo;
@property (strong, nonatomic) SMPhotoScrollView *scrollView;
@end

@implementation SMPhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(instancetype)initWithIndex:(NSIndexPath *)paramIndexPath andPhoto:(SMPhoto*)paramPhoto
{
    self = [super init];
    if(self)
    {
        _indexPath = paramIndexPath;
        _photo = paramPhoto;
    }
    return self;
}

-(void)loadView
{
    self.scrollView = [[SMPhotoScrollView alloc] initWithImageFromURL:self.photo.photoURL andFrame:[UIScreen mainScreen].bounds];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view = self.scrollView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"scrollviewController";
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark NSCoding Protocol
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.indexPath forKey:@"indexPath"];
    [aCoder encodeObject:self.photo forKey:@"photo"];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    NSIndexPath *indexPath = [aDecoder decodeObjectForKey:@"indexPath"];
    SMPhoto *photo = [aDecoder decodeObjectForKey:@"photo"];
    return [[SMPhotoViewController alloc] initWithIndex:indexPath andPhoto:photo];
}
#pragma mark - SMPhotoProtocol

-(void)updateText:(NSString *)paramText
{
    self.photo.descritptionText = paramText;
}

-(SMPhoto*)selectedPhoto
{
    return self.photo;
}

-(UIImage*)getImage
{
    return self.scrollView.zoomingView.image;
}

@end
