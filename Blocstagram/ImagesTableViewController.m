//
//  ImagesTableViewController.m
//  Blocstagram
//
//  Created by Matt Maher on 11/24/14.
//  Copyright (c) 2014 Matt Maher. All rights reserved.
//

#import "ImagesTableViewController.h"
#import "DataSource.h"
#import "User.h"
#import "Media.h"
#import "Comment.h"
#import "MediaTableViewCell.h"
#import "MediaFullScreenViewController.h"
#import "MediaFullScreenAnimator.h"

@interface ImagesTableViewController () <MediaTableViewCellDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, weak) UIImageView *lastTappedImageView;
@property(nonatomic, readonly, getter=isDragging) BOOL dragging;

@end

@implementation ImagesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[[DataSource sharedInstance] requestNewItemsWithCompletionHandler:^(NSError *error) {
        
    //}];
    
    NSLog(@"Work!!");
        
    [[DataSource sharedInstance] addObserver:self forKeyPath:@"mediaItems" options:0 context:nil];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshControlDidFire:) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView registerClass:[MediaTableViewCell class] forCellReuseIdentifier:@"mediaCell"];
}

- (void) dealloc
{
    [[DataSource sharedInstance] removeObserver:self forKeyPath:@"mediaItems"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

#pragma mark - Load More

- (void) refreshControlDidFire:(UIRefreshControl *) sender {
    [[DataSource sharedInstance] requestNewItemsWithCompletionHandler:^(NSError *error) {
        [sender endRefreshing];
    }];
}

- (void) infiniteScrollIfNecessary {
    NSIndexPath *bottomIndexPath = [[self.tableView indexPathsForVisibleRows] lastObject];
    
    if (bottomIndexPath && bottomIndexPath.row == [DataSource sharedInstance].mediaItems.count - 1) {
        // The very last cell is on screen
        [[DataSource sharedInstance] requestOldItemsWithCompletionHandler:nil];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self infiniteScrollIfNecessary];
    //[self.tableView reloadData];
}
/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSArray *arrayItems = [DataSource sharedInstance].mediaItems;
    for (int i = 0; i < arrayItems.count; i++) {
        Media *mediaItem = [DataSource sharedInstance].mediaItems[i];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
            if (mediaItem.downloadState == MediaDownloadStateNeedsImage) {
                [[DataSource sharedInstance] downloadImageForMediaItem:mediaItem];
            }
        });
    }
}*/
/*
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    NSArray *arrayItems = [DataSource sharedInstance].mediaItems;
    for (int i = 0; i < arrayItems.count; i++) {
        Media *mediaItem = [DataSource sharedInstance].mediaItems[i];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
            if (mediaItem.downloadState == MediaDownloadStateNeedsImage) {
                [[DataSource sharedInstance] downloadImageForMediaItem:mediaItem];
            }
        });
    }
    //[self.tableView reloadData];
}*/
/*
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    NSArray *arrayItems = [DataSource sharedInstance].mediaItems;
    for (int i = 0; i < arrayItems.count; i++) {
        Media *mediaItem = [DataSource sharedInstance].mediaItems[i];
        if (mediaItem.downloadState == MediaDownloadStateNeedsImage) {
                [[DataSource sharedInstance] downloadImageForMediaItem:mediaItem];
        }
    }
    //[self.tableView reloadData];
}
 */
#pragma mark - Table view data source

- (NSMutableArray *)items {
    NSArray *arrayItems = [DataSource sharedInstance].mediaItems;
    
    NSMutableArray *items = [arrayItems mutableCopy];
    
    return items;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self items].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    MediaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mediaCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.mediaItem = [self items][indexPath.row];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Media *item = [self items][indexPath.row];
    return [MediaTableViewCell heightForMediaItem:item width:CGRectGetWidth(self.view.frame)];
}

- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Media *item = [DataSource sharedInstance].mediaItems[indexPath.row];
    
    if (item.image) {
        return 350;
    } else {
        return 150;
    }
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arrayItems = [DataSource sharedInstance].mediaItems;
    for (int i = 0; i < arrayItems.count; i++) {
        Media *mediaItem = [DataSource sharedInstance].mediaItems[i];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
            if (mediaItem.downloadState == MediaDownloadStateNeedsImage) {
                [[DataSource sharedInstance] downloadImageForMediaItem:mediaItem];
            }
        });
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
   
    return YES;
}

/*
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [tableView setEditing:editing animated:YES];
}
*/
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Media *item = [DataSource sharedInstance].mediaItems[indexPath.row];
        [[DataSource sharedInstance] deleteMediaItem:item];
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - KVO

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == [DataSource sharedInstance] && [keyPath isEqualToString:@"mediaItems"]) {
        // We know mediaItems changed.  Let's see what kind of change it is.
        int kindOfChange = [change[NSKeyValueChangeKindKey] intValue];
        
        if (kindOfChange == NSKeyValueChangeSetting) {
            // Someone set a brand new images array
            [self.tableView reloadData];
            
        } else if (kindOfChange == NSKeyValueChangeInsertion ||
                   kindOfChange == NSKeyValueChangeRemoval ||
                   kindOfChange == NSKeyValueChangeReplacement) {
            // We have an incremental change: inserted, deleted, or replaced images
            
            // Get a list of the index (or indices) that changed
            NSIndexSet *indexSetOfChanges = change[NSKeyValueChangeIndexesKey];
            
            // Convert this NSIndexSet to an NSArray of NSIndexPaths (which is what the table view animation methods require)
            NSMutableArray *indexPathsThatChanged = [NSMutableArray array];
            [indexSetOfChanges enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                [indexPathsThatChanged addObject:newIndexPath];
            }];
            
            // Call `beginUpdates` to tell the table view we're about to make changes
            [self.tableView beginUpdates];
            
            // Tell the table view what the changes are
            if (kindOfChange == NSKeyValueChangeInsertion) {
                [self.tableView insertRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
            } else if (kindOfChange == NSKeyValueChangeRemoval) {
                [self.tableView deleteRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
            } else if (kindOfChange == NSKeyValueChangeReplacement) {
                [self.tableView reloadRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
            // Tell the table view that we're done telling it about changes, and to complete the animation
            [self.tableView endUpdates];
        }
    }
}

#pragma mark - MediaTableViewCellDelegate

- (void) cell:(MediaTableViewCell *)cell didTapImageView:(UIImageView *)imageView {
    self.lastTappedImageView = imageView;
    
    MediaFullScreenViewController *fullScreenVC = [[MediaFullScreenViewController alloc] initWithMedia:cell.mediaItem];
    
    fullScreenVC.transitioningDelegate = self;
    fullScreenVC.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:fullScreenVC animated:YES completion:nil];
}

- (void) cell:(MediaTableViewCell *)cell didLongPressImageView:(UIImageView *)imageView {
    NSMutableArray *itemsToShare = [NSMutableArray array];
    
    if (cell.mediaItem.caption.length > 0) {
        [itemsToShare addObject:cell.mediaItem.caption];
    }
    
    if (cell.mediaItem.image) {
        [itemsToShare addObject:cell.mediaItem.image];
    }
    
    if (itemsToShare.count > 0) {
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
        [self presentViewController:activityVC animated:YES completion:nil];
    }
}

#pragma mark - UIViewControllerTransitioningDelegate

 - (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
 presentingController:(UIViewController *)presenting
 sourceController:(UIViewController *)source {
 
 MediaFullScreenAnimator *animator = [MediaFullScreenAnimator new];
 animator.presenting = YES;
 animator.cellImageView = self.lastTappedImageView;
 
 return animator;
 }
 
 - (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
 MediaFullScreenAnimator *animator = [MediaFullScreenAnimator new];
 animator.cellImageView = self.lastTappedImageView;
 
 return animator;
 }


@end
