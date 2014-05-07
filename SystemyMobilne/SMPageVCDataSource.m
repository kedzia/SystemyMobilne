//
//  SMPageVCDataSource.m
//  SystemyMobilne
//
//  Created by Adam on 28.04.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import "SMPageVCDataSource.h"
#import "SMPhoto.h"

@interface SMPageVCDataSource ()

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultController;
@end
@implementation SMPageVCDataSource

-(instancetype)initWithFetchedResultController:(NSFetchedResultsController *)paramfetchedResultController
{
    self =[super init];
    {
        _fetchedResultController = paramfetchedResultController;
    }
    return self;
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(SMPhotoViewController *)viewController
{
    NSIndexPath *index = [NSIndexPath indexPathForItem:viewController.indexPath.item -1
                                             inSection:viewController.indexPath.section];
    if(index.item  >= 0 )
    {
        SMPhoto *photo = [self.fetchedResultController objectAtIndexPath:index];
        return [[SMPhotoViewController alloc] initWithIndex:index andPhoto:photo];
        
    }
    else if(index.section > 0)
    {
        index = [NSIndexPath indexPathForItem:0 inSection:index.section +1];
        SMPhoto *photo = [self.fetchedResultController objectAtIndexPath:index];
        return [[SMPhotoViewController alloc] initWithIndex:index andPhoto:photo];
    }
    
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(SMPhotoViewController *)viewController
{
    NSIndexPath *index = [NSIndexPath indexPathForItem:viewController.indexPath.item +1
                                             inSection:viewController.indexPath.section];
    if(index.item  <= [self maxItemIndexInSection:index.section])
    {
        SMPhoto *photo = [self.fetchedResultController objectAtIndexPath:index];
        return [[SMPhotoViewController alloc] initWithIndex:index andPhoto:photo];
        
    }
    else if(index.section < [self maxIndexOfSection])
    {
        index = [NSIndexPath indexPathForItem:0 inSection:index.section +1];
        SMPhoto *photo = [self.fetchedResultController objectAtIndexPath:index];
        return [[SMPhotoViewController alloc] initWithIndex:index andPhoto:photo];
    }
    
    return nil;
}

- (NSInteger) maxItemIndexInSection:(NSInteger)section
{
    if ([[self.fetchedResultController sections] count] > 0) {
        
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultController sections] objectAtIndex:section];
        
        return [sectionInfo numberOfObjects] -1;
        
    } else
        
        return 0;
}

- (NSInteger)maxIndexOfSection
{
    return [[self.fetchedResultController sections] count] -1;
}
@end
