//
//  SMTextViewController.m
//  SystemyMobilne
//
//  Created by Adam on 07.05.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import "SMTextViewController.h"

@interface SMTextViewController () <UITextViewDelegate>
@property (strong, nonatomic) UITextView *myTextView;
@end

@implementation SMTextViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(instancetype)initWithText:(NSString *)paramText
{
    self = [super init];
    if(self)
    {
        self.myTextView = [[UITextView alloc] init];
        self.myTextView.text = paramText;
        self.myTextView.textAlignment = NSTextAlignmentJustified;
    }
    return self;
}

-(id)init
{
   return [self initWithText:@""];
}

-(void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myTextView.frame = self.view.bounds;
    self.myTextView.font = [UIFont systemFontOfSize:16.0f];
    [self.view addSubview:self.myTextView];
    self.myTextView.delegate = self;
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoardWillHide) name:UIKeyboardWillHideNotification object:nil];
   
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (self.isMovingFromParentViewController) {
        [UIView animateWithDuration:0.75
                         animations:^{
                             [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                             [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
                         }];
    }
    
    [self.delegate textForPhoto:self.myTextView.text];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text hasSuffix:@"\n"]) {
        
        [CATransaction setCompletionBlock:^{
            [self scrollToCaretInTextView:textView animated:NO];
        }];
        
    } else {
        [self scrollToCaretInTextView:textView animated:NO];
    }
}

- (void)scrollToCaretInTextView:(UITextView *)textView animated:(BOOL)animated
{
    CGRect rect = [textView caretRectForPosition:textView.selectedTextRange.end];
    rect.size.height += textView.textContainerInset.bottom;
    [textView scrollRectToVisible:rect animated:animated];
}

#pragma mark keyboard notification handlers

-(void)handleKeyboardDidShow:(NSNotification*) paramNotification
{
    NSDictionary *dict = [paramNotification userInfo];
    CGRect keyboardRect = [dict[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.myTextView convertRect:keyboardRect fromView:nil];
    CGSize statusBarSize = [[UIApplication sharedApplication] statusBarFrame].size;

    float topInset = [self navigationController].navigationBar.frame.size.height + MIN(statusBarSize.width, statusBarSize.height);
    self.myTextView.contentInset = UIEdgeInsetsMake(topInset, 0, keyboardRect.size.height, 0);
}

-(void)handleKeyBoardWillHide
{
    self.myTextView.contentInset = UIEdgeInsetsZero;
}
@end
