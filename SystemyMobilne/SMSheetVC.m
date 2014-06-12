//
//  SMSheetVC.m
//  SystemyMobilne
//
//  Created by Adam on 11.06.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import "SMSheetVC.h"

@interface SMSheetVC ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *privacySemgentedController;
@property (strong, nonatomic) IBOutlet UIView *view;

@end

@implementation SMSheetVC

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
    // Do any additional setup after loading the view from its nib.
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

@end
