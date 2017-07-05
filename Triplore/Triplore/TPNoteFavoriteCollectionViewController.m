//
//  TPNoteFavoriteCollectionViewController.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/29.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPNoteFavoriteCollectionViewController.h"
#import "TPNoteServerHelper.h"
#import "TPNoteCollectionViewCell.h"
#import "TPNoteViewController.h"
#import "TPNoteServer.h"
#import "TPNote.h"
#import "TPRefreshHeader.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

static NSString *const reuseIdentifier = @"TPNoteCollectionViewCell";

@interface TPNoteFavoriteCollectionViewController () <UIViewControllerPreviewingDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate> {
    NSArray *noteArr;
}

@end

@implementation TPNoteFavoriteCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // header
    TPRefreshHeader *header = [TPRefreshHeader headerWithRefreshingTarget:self
                                                         refreshingAction:@selector(loadNotes)];
    self.collectionView.mj_header = header;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadNotes)
                                                 name:@"load_favorite_notes"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:NO];
    
    [self loadNotes];
}

- (void)loadNotes{
    __weak __typeof__(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [TPNoteServerHelper loadFavoriteServerNotesWithBlock:^(NSArray<TPNoteServer *> * _Nonnull noteServers, NSError * _Nullable error) {
            noteArr = [NSArray arrayWithArray:noteServers];
            NSLog(@"Load finished, %lu favorite notes", (unsigned long)noteArr.count);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.collectionView.mj_header endRefreshing];
                [weakSelf.collectionView reloadData];
            });
        }];
    });
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
    
    cell.mode = TPNoteCellRemote;
    cell.noteServer  = noteArr[indexPath.row];
    
    //注册3D Touch
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:cell];
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TPNoteViewController *noteVC = [[TPNoteViewController alloc] init];
    TPNoteServer *noteServer = noteArr[indexPath.row];
    TPNote *note = [[TPNote alloc] initWithTPNoteServer:noteServer];
    [noteVC setNote:note];
    [noteVC setNoteMode:TPRemoteNote];
    [noteVC setVideoDict:noteServer.videoDict];
    [noteVC setNoteServer:noteServer];
    
    [self.parentNavigationController pushViewController:noteVC animated:YES];
}

#pragma mark - UIViewControllerPreviewingDelegate

- (UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location{
    
    if ([self.presentedViewController isKindOfClass:[TPNoteViewController class]]){
        return nil;
    }
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:(TPNoteCollectionViewCell* )[previewingContext sourceView]];
    
    TPNoteViewController *noteVC = [[TPNoteViewController alloc] init];
    TPNote *note = [[TPNote alloc] initWithTPNoteServer:noteArr[indexPath.row]];
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
    NSString *text = @"暂无收藏笔记";
    
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName: TPColor,
                                 NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:20.0]
                                 };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end
