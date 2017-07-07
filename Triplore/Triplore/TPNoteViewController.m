//
//  TPNoteViewController.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/26.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPNoteViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TPNoteViewTableViewCell.h"
#import "TPNote.h"
#import "TPVideo.h"
#import "TPNoteManager.h"
#import "TPVideoManager.h"
#import "TPAddTextViewController.h"
#import "TPPlayViewController.h"
#import "TPNoteCollectionViewController.h"
#import "TPNoteDecorator.h"
#import "TPNoteTemplate.h"
#import "TPNoteTemplateFactory.h"
#import "Triplore-Swift.h"
#import "TPNoteCreator.h"
#import "TPNoteToolbar.h"
#import <Photos/Photos.h>
#import "TPNoteServerHelper.h"
#import "TPNoteServer.h"
#import "SVProgressHUD.h"
#import "TPMediaSaver.h"
#import <AVOSCloud/AVOSCloud.h>

#define STACK_SPACING 20
#define TOOLBAR_HEIGHT 44

@interface TPNoteViewController () <UITableViewDelegate, UITableViewDataSource, TPAddNoteViewDelegate, DragableTableDelegate, TPNoteToolbarDelegate>

@property (nonatomic, strong) TPNoteToolbar *buttonBar;
@property (nonnull, nonatomic) UITableView *tableView;

@end

@implementation TPNoteViewController{
    NSIndexPath *selectedIndexPath;
    NSMutableArray<UIView *> *showViews;    //展示用
    UISegmentedControl *segment;
    TPNoteTemplate *template;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    showViews = [[NSMutableArray alloc] init];
    self.view.backgroundColor = TPBackgroundColor;
    
    self.title = @"笔记";
    //滚动视图
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   CGRectGetWidth(self.view.bounds),
                                                                   CGRectGetHeight(self.view.bounds) - 64 - TOOLBAR_HEIGHT * (self.noteMode == TPOldNote ? 1 : 0))
                                                  style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.dragable = YES;
    self.tableView.dragableDelegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    
    //新的 Note，保存按钮
    if(self.noteMode == TPNewNote){
        UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 44,
                                                                          20,
                                                                          24,
                                                                          24)];
        saveButton.tintColor = [UIColor whiteColor];
        [saveButton setImage:[[UIImage imageNamed:@"NOTE_SAVE"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [saveButton addTarget:self action:@selector(saveNoteAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
        self.navigationItem.rightBarButtonItem = saveButtonItem;
    } else {
        // add tool bar
        CGSize size = self.navigationController.view.frame.size;
        self.buttonBar = [[TPNoteToolbar alloc] initWithFrame:CGRectMake(0, size.height - TOOLBAR_HEIGHT, size.width, TOOLBAR_HEIGHT)];
        self.buttonBar.delegate = self;
        if(self.noteMode == TPOldNote){
            self.buttonBar.mode = TPNoteToolbarLocal;
            
            [self.buttonBar setIsShare:[TPNoteManager hasUploadedToServer:self.note]];

        } else if (self.noteMode == TPRemoteNote) {
            self.buttonBar.mode = TPNoteToolbarRemote;
            
            [self.buttonBar setLikeCount:self.noteServer.like.integerValue];
            
            [self.buttonBar setIsCollect:[TPNoteServerHelper isFavoriteServerNote:self.noteServer.noteServerID]];
            [self.buttonBar setIsLike:[TPNoteServerHelper isLikeServerNote:self.noteServer.noteServerID]];
        }
        [self.navigationController.view addSubview:self.buttonBar];
    }
    
    segment = [[UISegmentedControl alloc] initWithItems:@[@"清新绿", @"活力棕"]];
    if(self.note.templateNum == 0){
        [segment setSelectedSegmentIndex:0];
    }else{
        [segment setSelectedSegmentIndex:self.note.templateNum];
    }
    [segment addTarget:self action:@selector(reloadShowViews) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segment;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:YES];
    [self reloadShowViews];
    
    [_buttonBar setHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    if(self.noteMode == TPOldNote){
        [self saveNote];
    }
    [self.tabBarController.tabBar setHidden:NO];
    [_buttonBar setHidden:YES];
}

- (void)reloadShowViews{
    self.note.templateNum = segment.selectedSegmentIndex;
    template = [TPNoteTemplateFactory getTemplateOfNum:self.note.templateNum];
    showViews = [NSMutableArray arrayWithArray:[TPNoteDecorator getNoteViews:self.note
                                                                 andTemplate:template]];
    self.view.backgroundColor = template.tem_color;
    self.tableView.backgroundColor = template.tem_color;
    [self.tableView reloadData];
}

#pragma mark - TPNoteToolBarDelegate 

- (void)didTapDeleteButton:(UIButton *)button {
    [self deleteAction];
}

- (void)didTapVideoButton:(UIButton *)button {
    [self videoAction];
}

- (void)didTapExportButton:(UIButton *)button {
    [self exportAlbumAction];
}

- (void)didTapShareButton:(UIButton *)button {
    if(![AVUser currentUser]){
        [SVProgressHUD showInfoWithStatus:@"您尚未登录"];
        [SVProgressHUD dismissWithDelay:1.0];
        return;
    }
    
    if([TPNoteManager hasUploadedToServer:self.note]){
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"选择操作" message: nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除分享" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [SVProgressHUD showWithStatus:@"删除中"];
            
            __weak __typeof__(self) weakSelf = self;
            [TPNoteServerHelper deleteServerNote:self.note.serverid withBlock:^(BOOL succeed, NSError * _Nullable error) {
                
                [TPNoteManager deleteNoteServerID:weakSelf.note];
                
                [weakSelf.buttonBar setIsShare:NO];
                
                if(succeed){
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"load_server_notes" object:nil];
                    NSLog(@"删除远程成功");
                    [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                    [SVProgressHUD dismissWithDelay:2.0];
                }
            }];
        }];
        UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"更新分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [SVProgressHUD showWithStatus:@"更新中"];
            TPNoteServer *newServer = [[TPNoteServer alloc] initWithTPNote:self.note];
            [TPNoteServerHelper updateServerNote:newServer withBlock:^(BOOL succeed, NSError * _Nullable error) {
                if(succeed){
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"load_server_notes" object:nil];
                    NSLog(@"更新远程成功");
                    [SVProgressHUD showSuccessWithStatus:@"更新成功"];
                    [SVProgressHUD dismissWithDelay:2.0];
                }
            }];
        }];
        [alertC addAction:updateAction];
        [alertC addAction:deleteAction];
        [alertC addAction:cancelAction];
        [self presentViewController:alertC animated:YES completion:nil];
    }else{
        [self uploadAction];
    }
}

- (void)didTapLikeButton:(UIButton *)button {
    if(![AVUser currentUser]){
        [SVProgressHUD showInfoWithStatus:@"您尚未登录"];
        [SVProgressHUD dismissWithDelay:1.0];
        return;
    }
    
    [self likeAction];
}

- (void)didTapCollectButton:(UIButton *)button {
    if(![AVUser currentUser]){
        [SVProgressHUD showInfoWithStatus:@"您尚未登录"];
        [SVProgressHUD dismissWithDelay:1.0];
        return;
    }
    
    [self favoriteAction];
}

- (void)didTapAddButton:(UIButton *)button {
    [self saveNoteAction];
}

#pragma mark - Button Action

- (void)favoriteAction{
    BOOL changeToCollect = ![TPNoteServerHelper isFavoriteServerNote:self.noteServer.noteServerID];
    [self.buttonBar setIsCollect:changeToCollect];
    
    if(changeToCollect){
        __weak __typeof__(self) weakSelf = self;
        [TPNoteServerHelper favoriteServerNote:self.noteServer withBlock:^(BOOL succeed, NSError * _Nullable error) {
            if(succeed){
                NSLog(@"收藏成功");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"load_favorite_notes" object:nil];
            }else{
                NSLog(@"收藏失败");
                weakSelf.buttonBar.isLike = !changeToCollect;
            }
        }];
    }else{
        __weak __typeof__(self) weakSelf = self;
        [TPNoteServerHelper cancelFavoriteServerNote:self.noteServer withBlock:^(BOOL succeed, NSError * _Nullable error) {
            if(succeed){
                NSLog(@"取消收藏成功");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"load_favorite_notes" object:nil];
            }else{
                NSLog(@"取消收藏失败");
                weakSelf.buttonBar.isCollect = !changeToCollect;
            }
        }];
    }
}

- (void)likeAction{
    BOOL changeToLike = ![TPNoteServerHelper isLikeServerNote:self.noteServer.noteServerID];
    [self.buttonBar setIsLike:changeToLike];
    
    __weak __typeof__(self) weakSelf = self;
    [TPNoteServerHelper commentServerNote:self.noteServer withIsLike:changeToLike withBlock:^(BOOL succeed, NSError * _Nullable error) {
        if(succeed){
            NSLog(@"点赞成功");
            [weakSelf.buttonBar setLikeCount:self.buttonBar.likeCount + (changeToLike ? 1 : -1)];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"load_server_notes" object:nil];
        }else{
            NSLog(@"点赞失败");
            weakSelf.buttonBar.isLike = !changeToLike;
        }
    }];
}

- (void)videoAction{
    NSDictionary *videoDict;
    if(self.noteMode == TPRemoteNote) {
        videoDict = self.noteServer.videoDict;
    }else{
        TPVideo *video = [TPVideoManager fetchVideoWithID:self.note.videoid];
        if(video == NULL){
            NSLog(@"没视频");
            return;
        }else{
            videoDict = video.dict;
        }
    }
    TPPlayViewController *playViewController = [[TPPlayViewController alloc] initWithNibName:@"TPPlayViewController" bundle:nil];
    [playViewController setNote:self.note];
    [playViewController setNoteMode:self.noteMode];
    [playViewController setVideoDict:videoDict];
    [playViewController setNoteViews:self.note.views];
    [playViewController setNoteTitle:self.note.title];
    
    [self.navigationController pushViewController:playViewController animated:YES];
}

- (void)deleteAction{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"确认删除笔记吗"
                                                                    message:@"该操作不可恢复"
                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                          style:UIAlertActionStyleCancel
                                                        handler:nil];
    [alertC addAction:cancelAction];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"删除"
                                                       style:UIAlertActionStyleDestructive
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [self deleteNote];
                                                     }];
    [alertC addAction:okAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (BOOL)saveNote{
    NSLog(@"保存笔记");
    BOOL success = NO;
    
    //新增
    if(self.noteMode == TPNewNote || self.noteMode == TPRemoteNote){
        [self.note setVideoid:self.videoDict[@"id"]];
        [self.note setTemplateNum:segment.selectedSegmentIndex];
        success = [TPNoteManager insertNote:self.note];
        
        TPVideo *video = [TPVideo new];
        [video setVideoid:self.videoDict[@"id"]];
        [video setDict:self.videoDict];
        success = success && [TPVideoManager insertVideo:video];
    }else{
        [self.note setTemplateNum:segment.selectedSegmentIndex];
        success = [TPNoteManager updateNote:self.note];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"load_notes" object:nil];
    
    return success;
}

- (void)saveNoteAction{
    BOOL success = [self saveNote];
    
    [[TPNoteCreator shareInstance] clearNoteView];
    
    if(success){
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }else{
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    }
    [SVProgressHUD dismissWithDelay:2.0 completion:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

- (void)uploadAction{
    [SVProgressHUD showWithStatus:@"分享中"];
    TPNoteServer *newNote = [[TPNoteServer alloc] initWithTPNote:self.note];
    __weak __typeof__(self) weakSelf = self;
    [TPNoteServerHelper uploadServerNote:newNote withBlock:^(BOOL succeed, NSString *serverID, NSError * _Nullable error) {
        if(succeed) {
            [weakSelf.buttonBar setIsShare:YES];
            
            [TPNoteManager updateNote:weakSelf.note withServerID:serverID];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"load_server_notes" object:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"load_notes" object:nil];
            
            [SVProgressHUD showSuccessWithStatus:@"分享成功"];
            [SVProgressHUD dismissWithDelay:2.0];
        }else{
            [SVProgressHUD showErrorWithStatus:@"分享失败"];
            [SVProgressHUD dismissWithDelay:2.0];
        }
    }];
}

- (void)deleteNote{
    if ([TPNoteManager deleteNoteWithID:self.note.noteid]) {
        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
        [SVProgressHUD dismissWithDelay:2.0 completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"删除失败"];
    }
}

- (void)editTitleAction{
    [self editNoteActionWithString:self.note.title andMode:TPUpdateTitle];
}

- (void)editNoteActionWithString:(NSString *)string andMode:(TPAddMode)mode{
    TPAddTextViewController *textVC = [[TPAddTextViewController alloc] initWithNibName:@"TPAddTextViewController" bundle:[NSBundle mainBundle]];
    textVC.addNoteViewDelegate = self;
    [textVC setNoteString:string];
    [textVC setAddMode:mode];
    [textVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    self.modalPresentationStyle = UIModalPresentationCurrentContext; //关键语句，必须有
    [self presentViewController:textVC animated:YES completion:nil];
}

- (void)updateNoteView:(UIView *_Nonnull)view{
    [self.note.views replaceObjectAtIndex:selectedIndexPath.row - 2 withObject:view];
    [self reloadShowViews];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.note.views indexOfObject:view] + 2 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)updateTitle:(NSString *)title{
    [self.note setTitle:title];
    [self reloadShowViews];
}

#pragma mark - Save to album

- (void)exportAlbumAction{
    UIGraphicsBeginImageContextWithOptions(self.tableView.contentSize, YES, [[UIScreen mainScreen] scale]);
    
    CGPoint savedContentOffset = self.tableView.contentOffset;
    CGRect saveFrame = self.tableView.frame;
    self.tableView.contentOffset = CGPointZero;
    self.tableView.frame = CGRectMake(0, 0, self.tableView.contentSize.width, self.tableView.contentSize.height);
    
    [self.tableView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    self.tableView.contentOffset = savedContentOffset;
    self.tableView.frame = saveFrame;
    
    UIGraphicsEndImageContext();
    
    [TPMediaSaver checkStatusWithCompletionBlock:^(BOOL authorized) {
        if(!authorized) {
            [SVProgressHUD showInfoWithStatus:@"请去设置开启权限"];
            [SVProgressHUD dismissWithDelay:2.0];
        } else {
            [TPMediaSaver saveImage:image withCompletionBlock:^(BOOL success, NSError *error) {
                if(!error) {
                    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"保存到相册成功"
                                                                                    message:nil
                                                                             preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                                           style:UIAlertActionStyleCancel
                                                                         handler:nil];
                    [alertC addAction:cancelAction];
                    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"去相册查看"
                                                                          style:UIAlertActionStyleDefault
                                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                                            NSString *str = @"photos-redirect://";
                                                                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]
                                                                                                               options:@{}
                                                                                                     completionHandler:nil];
                                                                        }];
                    [alertC addAction:albumAction];
                    [self presentViewController:alertC animated:YES completion:nil];
                }else{
                    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"保存失败"
                                                                                    message:nil
                                                                             preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的"
                                                                       style:UIAlertActionStyleDefault
                                                                     handler:nil];
                    [alertC addAction:okAction];
                    [self presentViewController:alertC animated:YES completion:nil];
                }
            }];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return showViews.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TPNoteViewTableViewCell";
    TPNoteViewTableViewCell *cell = (TPNoteViewTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    if(indexPath.row < 2){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setNoteView:showViews[indexPath.row]];
    [cell setBgColor:template.tem_color];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.noteMode != TPRemoteNote){
        selectedIndexPath = indexPath;
        if(indexPath.row == 0){
            return;
        }else if(indexPath.row == 1){
            [self editTitleAction];
        }else if([self.note.views[indexPath.row - 2] isKindOfClass:[UILabel class]]){
            UILabel *label = (UILabel *)self.note.views[indexPath.row - 2];
            [self editNoteActionWithString:label.text andMode:TPUpdateNote];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row < 2){
        return showViews[indexPath.row].frame.size.height + 10;
    }else{
        return showViews[indexPath.row].frame.size.height + 20;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.note.views removeObjectAtIndex:indexPath.row - 2];
    [self reloadShowViews];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"               ";
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Drag Delegate

- (void)tableView:(UITableView *)tableView dragCellFrom:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath{
    [self.note.views exchangeObjectAtIndex:fromIndexPath.row - 2 withObjectAtIndex:toIndexPath.row - 2];
    [showViews exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
    [self.tableView moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
}

- (BOOL)tableView:(UITableView *)tableView canDragCellTo:(NSIndexPath *)indexPath{
    return indexPath.row >= 2;
}

- (BOOL)tableView:(UITableView *)tableView canDragCellFrom:(NSIndexPath *)indexPath withTouchPoint:(CGPoint)point{
    return self.noteMode != TPRemoteNote && indexPath.row >= 2;
}

- (BOOL)tableView:(UITableView *)tableView canDragCellFrom:(NSIndexPath *)fromIndexPath over:(NSIndexPath *)overIndexPath{
    return fromIndexPath.row >= 2 && overIndexPath.row >= 2;
}

- (void)tableView:(UITableView *)tableView endDragCellTo:(NSIndexPath *)indexPath{
    [self reloadShowViews];
}

@end
