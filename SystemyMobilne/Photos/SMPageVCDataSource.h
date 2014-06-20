//
//  SMPageVCDataSource.h
//  SystemyMobilne
//
//  Created by Adam on 28.04.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMPhotoViewController.h"
#import "SMPageViewController.h"

@interface SMPageVCDataSource : NSObject <UIPageViewControllerDataSource>


-(instancetype) initWithFetchedResultController:(NSFetchedResultsController *)paramfetchedResultController;

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(SMPhotoViewController *)viewController;
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(SMPhotoViewController *)viewController;
@end
