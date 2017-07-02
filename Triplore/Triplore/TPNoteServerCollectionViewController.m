//
//  TPNoteServerCollectionViewController.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/29.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPNoteServerCollectionViewController.h"
#import "TPNoteServerHelper.h"
#import "TPNoteCollectionViewCell.h"
#import "TPNoteViewController.h"
#import "TPNoteServer.h"
#import "TPNote.h"
#import "TPRefreshHeader.h"

static NSString * const reuseIdentifier = @"TPNoteCollectionViewCell";

@interface TPNoteServerCollectionViewController () <UIViewControllerPreviewingDelegate> {
    NSArray *noteArr;
}

@end

@implementation TPNoteServerCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // header
    TPRefreshHeader *header = [TPRefreshHeader headerWithRefreshingTarget:self
                                                         refreshingAction:@selector(loadNotes)];
    self.collectionView.mj_header = header;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadNotes)
                                                 name:@"load_server_notes"
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
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [TPNoteServerHelper loadServerNotesStartWith:0 withSize:10 withBlock:^(NSArray<TPNoteServer *> * _Nonnull noteServers, NSError * _Nullable error) {
            noteArr = [NSArray arrayWithArray:noteServers];
            NSLog(@"Load finished, %lu notes", (unsigned long)noteArr.count);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView.mj_header endRefreshing];
                [self.collectionView reloadData];
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
    cell.noteServer = noteArr[indexPath.row];
    
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


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = (CGRectGetWidth(self.view.frame) - 30) / 2;
    return CGSizeMake(width, width/16*9 + 107);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
