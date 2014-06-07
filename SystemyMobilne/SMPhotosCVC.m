//
//  SMPhotosCVC.m
//  SystemyMobilne
//
//  Created by Adam on 24.04.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import "SMPhotosCVC.h"
#import "SMPhoto.h"
#import "SMPhotosCVCell.h"
#import "SMPageVCDataSource.h"
#import "SMPhotoViewController.h"
#import  "SMPageViewController.h"

@interface SMPhotosCVC () <NSFetchedResultsControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIPageViewControllerDataSource>
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultController;
@property (strong, nonatomic) NSMutableArray *sectionChanges;
@property (strong, nonatomic) NSMutableArray *itemChanges;
@property (strong, nonatomic) SMPageVCDataSource *pageVCDataSource;

@end

@implementation SMPhotosCVC

-(instancetype)initWithRequest:(NSFetchedResultsController *)paramFetchedResultsController
{
    self = [super initWithCollectionViewLayout:[self flowLayout]];
    if(self)
    {
        [self.collectionView registerClass:[SMPhotosCVCell class] forCellWithReuseIdentifier:@"CellID"];
        self.fetchedResultController = paramFetchedResultsController;
        self.fetchedResultController.delegate = self;
        
        NSError *error = nil;
        [self.fetchedResultController performFetch:&error];
        if(error)
        {
            NSLog(@"%@",error.localizedDescription);
        }
    }
    return self;
}

- (UICollectionViewFlowLayout *) flowLayout
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 10.0f;
    flowLayout.minimumInteritemSpacing = 10.0f;
    flowLayout.itemSize = CGSizeMake(120.0f, 160.0f);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(10.0f, 20.0f, 10.0f, 20.0f);
    return flowLayout;
}
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
    self.collectionView.delegate = self;
    [self.navigationController setNavigationBarHidden:NO];
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    
}

#pragma mark state restoration

-(void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.fetchedResultController.fetchRequest.predicate forKey:@"predicate"];
    [super encodeRestorableStateWithCoder:coder];
}
-(void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super decodeRestorableStateWithCoder:coder];
}

#pragma mark UIViewCollectionDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SMPhoto *photo = [self.fetchedResultController objectAtIndexPath:indexPath];

    SMPhotoViewController *pvc = [[SMPhotoViewController alloc] initWithIndex:indexPath andPhoto:photo];
    SMPageViewController *pageVC = [[SMPageViewController alloc] init];
    
    pageVC.dataSource = self;
    pageVC.photoDelegate = pvc;
    pageVC.title = photo.location.name;

    [pageVC setViewControllers:@[pvc]
                     direction:UIPageViewControllerNavigationDirectionForward
                      animated:NO
                    completion:nil];
    
    [[self navigationController] pushViewController:pageVC animated:YES];
}

#pragma mark UICollectionViewDataSource
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SMPhotosCVCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"CellID" forIndexPath:indexPath];
    if(cell)
    {
        SMPhoto *photo = [self.fetchedResultController objectAtIndexPath:indexPath];
        [cell viewWithALAssetURL:photo.photoURL];
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    if ([[self.fetchedResultController sections] count] > 0) {
        
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultController sections] objectAtIndex:section];
        
        return [sectionInfo numberOfObjects];
        
    } else
        
        return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
     return [[self.fetchedResultController sections] count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"suplementary view method called in UICollectionView");
    return nil;
}
#pragma mark UIPageViewController Data Source

-(UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(SMPhotoViewController *)viewController
{
    if(self.pageVCDataSource == nil)
    {
        self.pageVCDataSource = [[SMPageVCDataSource alloc] initWithFetchedResultController:self.fetchedResultController];
    }
    return [self.pageVCDataSource pageViewController:pageViewController viewControllerAfterViewController:viewController];
}

-(UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(SMPhotoViewController *)viewController
{
    if(self.pageVCDataSource == nil)
    {
        self.pageVCDataSource = [[SMPageVCDataSource alloc] initWithFetchedResultController:self.fetchedResultController];
    }
    return [self.pageVCDataSource pageViewController:pageViewController viewControllerBeforeViewController:viewController];
}

#pragma mark  NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    _sectionChanges = [[NSMutableArray alloc] init];
    _itemChanges = [[NSMutableArray alloc] init];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {
    NSMutableDictionary *change = [[NSMutableDictionary alloc] init];
    change[@(type)] = @(sectionIndex);
    [_sectionChanges addObject:change];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    NSMutableDictionary *change = [[NSMutableDictionary alloc] init];
    switch(type) {
        case NSFetchedResultsChangeInsert:
            change[@(type)] = newIndexPath;
            break;
        case NSFetchedResultsChangeDelete:
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeUpdate:
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeMove:
            change[@(type)] = @[indexPath, newIndexPath];
            break;
    }
    [_itemChanges addObject:change];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.collectionView performBatchUpdates:^{
        for (NSDictionary *change in _sectionChanges) {
            [change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                switch(type) {
                    case NSFetchedResultsChangeInsert:
                        [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                        break;
                    case NSFetchedResultsChangeDelete:
                        [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                        break;
                }
            }];
        }
        for (NSDictionary *change in _itemChanges) {
            [change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                switch(type) {
                    case NSFetchedResultsChangeInsert:
                        [self.collectionView insertItemsAtIndexPaths:@[obj]];
                        break;
                    case NSFetchedResultsChangeDelete:
                        [self.collectionView deleteItemsAtIndexPaths:@[obj]];
                        break;
                    case NSFetchedResultsChangeUpdate:
                        [self.collectionView reloadItemsAtIndexPaths:@[obj]];
                        break;
                    case NSFetchedResultsChangeMove:
                        [self.collectionView moveItemAtIndexPath:obj[0] toIndexPath:obj[1]];
                        break;
                }
            }];
        }
    } completion:^(BOOL finished) {
        _sectionChanges = nil;
        _itemChanges = nil;
    }];
}



@end
