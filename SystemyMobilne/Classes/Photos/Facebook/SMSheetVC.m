//
//  SMSheetVC.m
//  SystemyMobilne
//
//  Created by Adam on 11.06.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import "SMSheetVC.h"

@interface SMSheetVC () <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>
@property (weak, nonatomic) IBOutlet UISegmentedControl *privacySemgentedController;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIView *alertView;

@end

@implementation SMSheetVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.alertView.layer.cornerRadius = 10;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)privacySegmentedControllerValueChanged:(UISegmentedControl *)sender
{
    
}
- (IBAction)uploadPressed:(UIButton *)sender
{
    NSString *result;
    switch (self.privacySemgentedController.selectedSegmentIndex) {
        case 1:
            result = @"SELF";
            break;
        case 2:
            result = @"FRIENDS";
            break;
        case 3:
            result = @"EVERYONE";
            break;
        default:
            result = @"SELF";
            break;
    }
    [self.delegate choosenPrivacy:result];
}
- (IBAction)cancelPressed:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)
animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    UIView *view1 = fromVC.view;
    UIView *view2 = toVC.view;
    
    if(toVC == self)
    {
        [container addSubview:view2];
        view2.frame = view1.frame;
        view2.alpha = 0;
        self.alertView.transform = CGAffineTransformMakeScale(1.6, 1.6);
        view1.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
        [UIView animateWithDuration:0.25
                         animations:^{
                             view2.alpha = 1;
                             self.alertView.transform = CGAffineTransformIdentity;
                         }completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                         }];
    }
    else
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.alertView.transform = CGAffineTransformMakeScale(0.5, 0.5);
            view1.alpha = 0;
        } completion:^(BOOL finished) {
            view2.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
            [transitionContext completeTransition:YES];
        }];
    }
}
@end
