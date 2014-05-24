//
//  SMPageViewController.m
//  SystemyMobilne
//
//  Created by Adam on 05.05.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import "SMPageViewController.h"
#import "SMFacebookPhotoSender.h"

@interface SMPageViewController () <UIPageViewControllerDelegate>

@end

@implementation SMPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tapped:(UITapGestureRecognizer*) sender
{
    [[self navigationController] setNavigationBarHidden:(![self navigationController].navigationBarHidden) animated:YES];
    
    
    if([self navigationController].navigationBarHidden)
    {
        self.view.backgroundColor = [UIColor blackColor];
        [self navigationController].toolbarHidden = YES;
    }
    else
    {
        self.view.backgroundColor = [UIColor whiteColor];
        [self navigationController].toolbarHidden = NO;
    }
}
-(id)init
{
    self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                    navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                  options:@{UIPageViewControllerOptionInterPageSpacingKey : @20.0f}];
    
    if(self)
    {
       
        self.title = @"pageViewController";
        self.view.backgroundColor = [UIColor whiteColor];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [self.view addGestureRecognizer:recognizer];
        
        UIBarButtonItem *buttonItemText = [[UIBarButtonItem alloc] initWithTitle:@"Text" style:UIBarButtonItemStylePlain target:self action:@selector(textButtonTapped)];
        UIBarButtonItem *buttonItemDelete = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStylePlain target:self action:@selector(deleteButtonTapped)];
        UIBarButtonItem *buttonItemFacebook = [[UIBarButtonItem alloc] initWithTitle:@"FB" style:UIBarButtonItemStylePlain target:self action:@selector(facebookTapped)];
        UIBarButtonItem *flexibleSpaceButton1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *flexibleSpaceButton2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [self setToolbarItems:@[buttonItemText, flexibleSpaceButton1, buttonItemFacebook, flexibleSpaceButton2, buttonItemDelete] animated:NO];
        
    
        
    }
    return self;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self navigationController].toolbarHidden = YES;
}


-(void)facebookTapped
{
    SMFacebookPhotoSender *sender = [[SMFacebookPhotoSender alloc] init];
    [sender LogIn];
    
}
-(void)textButtonTapped
{
    SMTextViewController *textVC = [[SMTextViewController alloc] initWithText:[self.photoDelegate selectedPhoto].descritptionText];
    
    textVC.delegate = self;
    [UIView animateWithDuration:0.75
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [self.navigationController pushViewController:textVC animated:NO];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
                     }];
}

-(void)deleteButtonTapped
{
    
    SMPhoto *photoToDel = [self.photoDelegate selectedPhoto];
    SMPhotoViewController *vc = nil;
    vc = (SMPhotoViewController*)[self.dataSource pageViewController:self viewControllerAfterViewController:self.photoDelegate];
    BOOL directionFowrward = YES;
  
    if (vc == nil)
    {
        vc = (SMPhotoViewController*)[self.dataSource pageViewController:self viewControllerBeforeViewController:self.photoDelegate];
        directionFowrward = NO;
    }
    else if(self.photoDelegate.indexPath.section == vc.indexPath.section)
    {
        //indexes inf fetched result controller will change, so we have to adjust it properly
        vc.indexPath = [NSIndexPath indexPathForItem:vc.indexPath.item -1 inSection:vc.indexPath.section];
    }
    else if(self.photoDelegate.indexPath.section != vc.indexPath.section)
    {
        vc.indexPath = [NSIndexPath indexPathForItem:vc.indexPath.item inSection:vc.indexPath.section -1];
    }
    
   
    if (vc != nil)
    {
        [photoToDel.managedObjectContext deleteObject:photoToDel];
        self.photoDelegate = vc;
      
        __weak SMPageViewController* blockself = self;
        
        void (^completionBlock)(BOOL) = ^(BOOL finished){
            if(finished)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [blockself setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];// bug fix for uipageview controller
                });
            }
        };

       
        
        if(directionFowrward == YES)
        {
            [self setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:completionBlock];
        }
        else
        {
            [self setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:completionBlock];
        }
        return;
    }
    
    [photoToDel.managedObjectContext deleteObject:photoToDel];
    // deleting last photo
   
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self navigationController].toolbarHidden = NO;
}

#pragma mark PhotoTextVC delegate

-(void)textForPhoto:(NSString *)paramText
{
    [self.photoDelegate selectedPhoto].descritptionText = paramText;
}

#pragma mark UIPageViewCOntrollerDelegate

-(void)pageViewController:(SMPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if(completed)
    {
        pageViewController.photoDelegate = self.viewControllers[0];
    }
}


@end
