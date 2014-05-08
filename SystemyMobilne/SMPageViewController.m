//
//  SMPageViewController.m
//  SystemyMobilne
//
//  Created by Adam on 05.05.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import "SMPageViewController.h"


@interface SMPageViewController ()

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
    // Do any additional setup after loading the view.
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
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [self.view addGestureRecognizer:recognizer];
        
        UIBarButtonItem * buttonItemText = [[UIBarButtonItem alloc] initWithTitle:@"Text" style:UIBarButtonItemStylePlain target:self action:@selector(textButtonTapped)];
        UIBarButtonItem *buttonItemDelete = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStylePlain target:self action:@selector(deleteButtonTapped)];
        
        [self setToolbarItems:@[buttonItemText, buttonItemDelete] animated:NO];
    
        
    }
    return self;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self navigationController].toolbarHidden = YES;
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
    UIViewController *vc = nil;
    vc = [self.dataSource pageViewController:self viewControllerAfterViewController:self.photoDelegate];
    if (vc == nil)
    {
        vc = [self.dataSource pageViewController:self viewControllerBeforeViewController:self.photoDelegate];
    }
    
    if (vc != nil)
    {
        [photoToDel.managedObjectContext deleteObject:photoToDel];
        self.photoDelegate = (UIViewController<SMPhotoProtocol>*)vc;
        [self setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
     
        return;
    }
    
    [photoToDel.managedObjectContext deleteObject:photoToDel];
    // deleting last photo
   
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
}

-(void)textForPhoto:(NSString *)paramText
{
    [self.photoDelegate selectedPhoto].descritptionText = paramText;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self navigationController].toolbarHidden = NO;
}

@end
