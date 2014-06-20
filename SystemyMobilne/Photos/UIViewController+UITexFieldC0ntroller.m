//
//  UIViewController+UITexFieldC0ntroller.m
//  SystemyMobilne
//
//  Created by Adam on 12.06.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import "UIViewController+UITexFieldC0ntroller.h"

@implementation UIViewController (UITexFieldC0ntroller)
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
@end
