//
//  TPNoteCollectionViewController.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/25.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPNoteCollectionViewController.h"
#import "TPNoteCollectionViewCell.h"
#import "TPNoteCollectionViewCell+Configure.h"
#import "TPNoteViewController.h"
#import "Utilities.h"
#import "TPNote.h"
#import "TPNoteManager.h"

@interface TPNoteCollectionViewController () <UIViewControllerPreviewingDelegate>

@end

@implementation TPNoteCollectionViewController{
    NSArray *noteArr;
}

static NSString * const reuseIdentifier = @"TPNoteCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    self.collectionView.backgroundColor = [Utilities getBackgroundColor];
    
    self.navigationController.navigationBar.barTintColor = [Utilities getColor];
    self.navigationController.navigationBar.backgroundColor = [Utilities getColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"笔记";
    
    UINib *nib = [UINib nibWithNibName:@"TPNoteCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:NO];
    [self loadNotes];
}

- (void)loadNotes{
    noteArr = [NSMutableArray arrayWithArray:[TPNoteManager fetchAllNotes]];
    [self.collectionView reloadData];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return noteArr.count;
}

- (TPNoteCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TPNoteCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    [cell configureWithNote:noteArr[indexPath.row]];
    
    //注册3D Touch
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:cell];
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TPNoteViewController *noteVC = [[TPNoteViewController alloc] init];
    
    TPNote *note = (TPNote *)noteArr[indexPath.row];
    [noteVC setNote:note];
    [noteVC setNoteMode:TPOldNote];
    
    [self.navigationController pushViewController:noteVC animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((CGRectGetWidth(self.view.frame) - 30) / 2, (CGRectGetWidth(self.view.frame) - 30) / 2);
}

//每一个分组的上左下右间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 0, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}


#pragma mark - UIViewControllerPreviewingDelegate

- (UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location{
    
    if ([self.presentedViewController isKindOfClass:[TPNoteViewController class]]){
        return nil;
    }
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:(TPNoteCollectionViewCell* )[previewingContext sourceView]];
    
    TPNoteViewController *noteVC = [[TPNoteViewController alloc] init];
    TPNote *note = (TPNote *)noteArr[indexPath.row];
    [noteVC setNote:note];
    [noteVC setNoteMode:TPOldNote];
    noteVC.preferredContentSize = CGSizeMake(0.0f, 525.0f);
    
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, 70);
    previewingContext.sourceRect = rect;
    
    return noteVC;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self.navigationController pushViewController:viewControllerToCommit animated:YES];
}

#pragma mark - DZNEmptyTableViewDelegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"没有笔记";
    
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName: [Utilities getColor],
                                 NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:20.0]
                                 };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
