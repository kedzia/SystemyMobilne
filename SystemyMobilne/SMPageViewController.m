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
        
        UIBarButtonItem * buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"Text" style:UIBarButtonItemStylePlain target:self action:@selector(textButtonTapped)];
        [[self navigationController].toolbar setItems:@[buttonItem] animated:NO];
        
    }
    return self;
    
}

-(void)textButtonTapped
{
    NSLog(@"text tapped");
}

@end
