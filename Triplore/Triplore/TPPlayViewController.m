
//  TPPlayViewController.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/30.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPPlayViewController.h"
#import "QYPlayerController.h"
#import "TPIndicatorView.h"
#import "TPNoteCreator.h"
#import "TPNoteViewController.h"
#import "TPAddTextViewController.h"
#import "UIImage+Extend.h"
#import "TPNote.h"
#import "TPNoteManager.h"
#import "TPNoteViewTableViewCell.h"
#import "TPVideoManager.h"
#import "TPVideo.h"
#import "TPVideoProgressBar.h"
#import "Triplore-Swift.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "TPPlayTutorialViewController.h"
#import "SVProgressHUD.h"
#import "TPPlayPanel.h"
#import "TPAddTextLandscapeViewController.h"
#import "TPMediaSaver.h"
#import <Photos/Photos.h>
#import <ReplayKit/ReplayKit.h>
#import <AVFoundation/AVFoundation.h>

#define CONTROLLER_BAR_WIDTH 30.0

#define KIPhone_AVPlayerRect_mwidth 320.0
#define KIPhone_AVPlayerRect_mheight 180.0

#define PANEL_WIDTH 150

@interface TPPlayViewController () <QYPlayerControllerDelegate, TPAddNoteViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, TPVideoProgressDelegate, DragableTableDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, TPPlayPanelDelegate, RPScreenRecorderDelegate, RPPreviewViewControllerDelegate>{
    CGRect playFrame;
    CGRect stackFrame;
    NSIndexPath *selectedIndexPath;
    UIBarButtonItem *favoriteButton;
    TPVideoProgressBar *progressBarView;
    TPPlayPanel *playPanel;
    NSNumber *currentPlayTime;
}

@property (nonatomic, weak) RPPreviewViewController *previewViewController;
@property (nonatomic, weak) IBOutlet UIView *playerView;
@property (nonatomic, weak) IBOutlet UITextField *titleText;
@property (nonatomic, weak) IBOutlet UIView *playPauseView;
@property (nonatomic, weak) IBOutlet UIView *barContainerView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

//@property (nonatomic,strong) ActivityIndicatorView *activityWheel;
@property (nonatomic) TPIndicatorView *loadingView;

@end

@implementation TPPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = TPBackgroundColor;

    self.navigationController.navigationBar.barTintColor = TPColor;
    self.navigationController.navigationBar.backgroundColor = TPColor;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = @"视频";
    
    self.hidesBottomBarWhenPushed = YES;
    self.tabBarController.tabBar.hidden = YES;
    
    [QYPlayerController sharedInstance].delegate = self;
    [[QYPlayerController sharedInstance] setPlayerFrame:self.playerView.frame];
    [_playerView addSubview:[QYPlayerController sharedInstance].view];
    
    playFrame = CGRectMake(0,
                           0,
                           SCREEN_WIDTH,
                           SCREEN_WIDTH / KIPhone_AVPlayerRect_mwidth * KIPhone_AVPlayerRect_mheight);
    
    TPIndicatorView *loadingView = [[TPIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 160, 60)];
    self.loadingView = loadingView;
    self.loadingView.center = CGPointMake(playFrame.size.width / 2, playFrame.size.height / 2);
    
    _titleText.placeholder = @"填写笔记标题";
    _titleText.font = [UIFont fontWithName:TPFont size:18.0f];
    _titleText.delegate = self;
    _titleText.textColor = [UIColor colorWithRed:94.0/255.0 green:113.0/255.0 blue:113.0/255.0 alpha:1.0];
    
    //进度
    progressBarView = [[[NSBundle mainBundle] loadNibNamed:@"TPVideoProgressBar" owner:nil options:nil] firstObject];
    [progressBarView.slider setThumbImage:[UIImage imageNamed:@"PROGRESS_OVAL"] forState:UIControlStateNormal];
    [progressBarView.slider setMinimumTrackTintColor:TPColor];
    [progressBarView.slider addTarget:progressBarView action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [progressBarView setBackgroundColor:[UIColor clearColor]];
    [progressBarView setDelegate:self];
    [progressBarView.layer setMasksToBounds:YES];

    //tableview
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.dragable = YES;
    self.tableView.dragableDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    if(self.noteMode == TPNewNote){
        self.noteViews = [[NSMutableArray alloc] init];
    }else{
        [_titleText setText:self.noteTitle];
        [[TPNoteCreator shareInstance] clearNoteView];
        for(UIView *v in self.noteViews){
            [[TPNoteCreator shareInstance] addNoteView:v];
        }
        [self reloadNoteViews];
    }
    
    //收藏按钮
    UIImage *favoriteImg = [TPVideoManager isFavoriteVideo:self.videoDict[@"id"]] ? [UIImage imageNamed:@"ME_COLLECT_FULL"] : [UIImage imageNamed:@"ME_COLLECT"];
    favoriteButton = [[UIBarButtonItem alloc] initWithImage:favoriteImg style:UIBarButtonItemStylePlain target:self action:@selector(favoriteAction)];
    self.navigationItem.rightBarButtonItem = favoriteButton;
    
    //操作面板
    playPanel = [[TPPlayPanel alloc] initWithFrame:CGRectMake(CGRectGetWidth(_playerView.frame) - PANEL_WIDTH - 30,
                                                              CGRectGetHeight(_playerView.frame) - 50,
                                                              PANEL_WIDTH,
                                                              30)];
    playPanel.delegate = self;
    
    //创建手势
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(objectDidDragged:)];
    //限定操作的触点数
    [panGR setMaximumNumberOfTouches:1];
    [panGR setMinimumNumberOfTouches:1];
    //将手势添加到draggableObj里
    [playPanel addGestureRecognizer:panGR];
    
    UITapGestureRecognizer *tapEndGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(stopPlayerRecording)];
    [tapEndGesture setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapEndGesture];
    
    //第一次的教程
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstPlay"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstPlay"];
        [self pauseClick];
        TPPlayTutorialViewController *tutoVC = [[TPPlayTutorialViewController alloc] init];
        [self.navigationController presentViewController:tutoVC animated:YES completion:^{
            [self playClick];
        }];
    }
    
    //存入视频列表，因为要存“最近观看”
    TPVideo *newVideo = [[TPVideo alloc] initWithVideoDict:self.videoDict];
    [TPVideoManager insertVideo:newVideo];
    
    NSLog(@"Video id: %@", self.videoDict[@"id"]);
    [self setFavoriteImage];
    
    NSString* aid = [self.videoDict valueForKey:@"a_id"];
    NSString* tvid = [self.videoDict valueForKey:@"tv_id"];
    NSString* isvip = [self.videoDict valueForKey:@"is_vip"];
    [[QYPlayerController sharedInstance] openPlayerByAlbumId:aid tvId:tvid isVip:isvip];
    self.title = self.videoDict[@"short_title"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:NO];
    [self reloadNoteViews];
    [self.view setNeedsLayout];
    [self.view layoutSubviews];
    NSLog(@"Play Will Appear");
}

- (void)viewDidAppear:(BOOL)animated{
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    
    [self saveNote];
    
    [self pauseClick];
    
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationPortrait) forKey:@"orientation"];
    
    NSLog(@"Play Will Disappear");
}

- (void)objectDidDragged:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateChanged ||
        sender.state == UIGestureRecognizerStateEnded) {
        //注意，这里取得的参照坐标系是该对象的上层View的坐标。
        CGPoint offset = [sender translationInView:self.view];
        UIView *draggableObj = playPanel;
        //通过计算偏移量来设定draggableObj的新坐标
        [draggableObj setCenter:CGPointMake(draggableObj.center.x + offset.x, draggableObj.center.y + offset.y)];
        //初始化sender中的坐标位置。如果不初始化，移动坐标会一直积累起来。
        [sender setTranslation:CGPointMake(0, 0) inView:self.view];
    }
}

- (void)dealloc{
    [[TPNoteCreator shareInstance] clearNoteView];
}

- (void)reloadNoteViews{
    [self.noteViews removeAllObjects];
    [self.noteViews addObjectsFromArray:[[TPNoteCreator shareInstance] getNoteViews]];
    [self.noteViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = [UIColor clearColor];
    }];
    [self.tableView reloadData];
}

- (void)hideToolViews:(BOOL)isHide{
    [[self.view viewWithTag:100] setHidden:isHide];
    [[self.view viewWithTag:200] setHidden:isHide];
    [playPanel setHidden:isHide];
}

#pragma mark - Player Methods

- (void)showPlayView{
    UIView *playView = [self.view viewWithTag:100];
    UIView *pauseView = [self.view viewWithTag:200];
    if(playView == nil){
        UIButton *play = [UIButton buttonWithType:UIButtonTypeCustom];
        [play setBackgroundColor:[UIColor clearColor]];
        [play setFrame:self.playPauseView.frame];
        [play setTintColor:[UIColor whiteColor]];
        UIImage *playImg = [UIImage imageNamed:@"VIDEO_PLAY_FULL"];
        playImg = [playImg imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [play setImage:playImg forState:UIControlStateNormal];
        play.layer.masksToBounds = YES;
        play.layer.cornerRadius = 15;
        [play addTarget:self action:@selector(playClick) forControlEvents:UIControlEventTouchUpInside];
        [play setTag:100];
        [self.view addSubview:play];
        play.hidden = NO;
        pauseView.hidden = YES;
    }else{
        playView.hidden = NO;
        pauseView.hidden = YES;
    }
}

- (void)sliderValueChanged:(id)sender{
    UISlider *slider = (UISlider *)sender;
    NSLog(@"Slider value: %f", slider.value);
}

- (void)showPauseView{
    UIView *playView = [self.view viewWithTag:100];
    UIView *pauseView = [self.view viewWithTag:200];
    if(pauseView == nil){
        UIButton *pause= [UIButton buttonWithType:UIButtonTypeCustom];
        [pause setBackgroundColor:[UIColor clearColor]];
        [pause setFrame:self.playPauseView.frame];
        [pause setTintColor:[UIColor whiteColor]];
        UIImage *pauseImg = [UIImage imageNamed:@"VIDEO_PAUSE_FULL"];
        pauseImg = [pauseImg imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [pause setImage:pauseImg forState:UIControlStateNormal];
        pause.layer.masksToBounds = YES;
        pause.layer.cornerRadius = 15;
        [pause addTarget:self action:@selector(pauseClick) forControlEvents:UIControlEventTouchUpInside];
        [pause setTag:200];
        [self.view addSubview:pause];
        pause.hidden = NO;
        playView.hidden = YES;
    }else{
        pauseView.hidden = NO;
        playView.hidden = YES;
    }
}

- (void)enablePlayPauseView{
    UIView *playView = [self.view viewWithTag:100];
    UIView *pauseView = [self.view viewWithTag:200];
    if(playView != nil){
        playView.userInteractionEnabled = YES;
    }
    if(pauseView != nil){
        playView.userInteractionEnabled = YES;
    }
}

- (void)unablePlayPauseView{
    UIView *playView = [self.view viewWithTag:100];
    UIView *pauseView = [self.view viewWithTag:200];
    if(playView != nil){
        playView.userInteractionEnabled = NO;
    }
    if(pauseView != nil){
        playView.userInteractionEnabled = NO;
    }
}

- (void)playClick{
    if ([QYPlayerController sharedInstance].isPlaying == NO) {
        [[QYPlayerController sharedInstance] play];
        [self showPauseView];
    }
}

- (void)pauseClick{
    if ([QYPlayerController sharedInstance].isPlaying == YES) {
        [[QYPlayerController sharedInstance] pause];
        [self showPlayView];
    }
}

#pragma QYBasePlayerControllerDelegate

/*
 * 播放出错
 */
- (void)onPlayerError:(NSDictionary *)error_no{
//    [self.activityWheel stopAnimating];
//    [self.activityWheel removeFromSuperview];
    [self.loadingView stopAnimating];
    [self.loadingView removeFromSuperview];
}

/*
 * 显示加载loading
 */
- (void)startLoading:(QYPlayerController *)player{
//    if (self.activityWheel.superview==nil) {
//        [self.view addSubview:self.activityWheel];
//        [self.activityWheel startAnimating];
//    }
    if (self.loadingView.superview==nil) {
        [self.view addSubview:self.loadingView];
        [self.loadingView startAnimating];
    }
    [self unablePlayPauseView];
}

/*
 * 关闭加载loading
 */
- (void)stopLoading:(QYPlayerController *)player{
//    [self.activityWheel stopAnimating];
//    [self.activityWheel removeFromSuperview];

    [self.loadingView stopAnimating];
    [self.loadingView removeFromSuperview];
    
    [self enablePlayPauseView];
}

/**
 **功能: 开始播放广告
 *
 */
- (void)onAdStartPlay:(QYPlayerController *)player{
    [self showPauseView];
    [self.view addSubview:playPanel];
    [self.view bringSubviewToFront:playPanel];
}

/**
 **功能: 开始播放正片
 *
 */
- (void)onContentStartPlay:(QYPlayerController *)player{
    [self showPauseView];
    [progressBarView setFrame:self.barContainerView.frame];
    [progressBarView layoutSubviews];
    [self.view addSubview:progressBarView];
}

/*
 * 播放时长发生变化
 */
- (void)playbackTimeChanged:(QYPlayerController *)player{
    [progressBarView setEndTimeWithSeconds:player.duration];
    [progressBarView setCurrentTimeWithSeconds:player.currentPlaybackTime];
}

/*
 * 播放完成
 */
- (void)playbackFinshed:(QYPlayerController *)player{
    if(self.view.bounds.size.width > self.view.bounds.size.height){
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    }
}

/*
 * 网络变化
 */
- (void)playerNetworkChanged:(QYPlayerController *)player{
    
}

- (void)setToTime:(double)time{
    [[QYPlayerController sharedInstance] seekToTime:time];
}

#pragma mark - Screen Recording

- (void)startPlayerRecording{
    [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
    [self hideToolViews:YES];
    
    RPScreenRecorder *sharedRecorder = [RPScreenRecorder sharedRecorder];
    sharedRecorder.delegate = self;
    [sharedRecorder startRecordingWithMicrophoneEnabled:YES handler:^(NSError *error) {
        if (error) {
            NSLog(@"startScreenRecording: %@", error.localizedDescription);
        }
    }];
}

- (void)stopPlayerRecording{
    
    RPScreenRecorder *sharedRecorder = RPScreenRecorder.sharedRecorder;
    [sharedRecorder stopRecordingWithHandler:^(RPPreviewViewController *previewViewController, NSError *error) {
        currentPlayTime = @([[QYPlayerController sharedInstance] currentPlaybackTime]);
        [self pauseClick];
        [self hideToolViews:NO];
        
        if (error) {
            NSLog(@"stopScreenRecording: %@", error.localizedDescription);
        }
        
        if (previewViewController) {
            previewViewController.previewControllerDelegate = self;
            self.previewViewController = previewViewController;
            // RPPreviewViewController only supports full screen modal presentation.
            self.previewViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:previewViewController animated:YES completion:nil];
        }
    }];
}

#pragma mark - RPPreviewViewControllerDelegate

- (void)previewControllerDidFinish:(RPPreviewViewController *)previewController {
    [previewController dismissViewControllerAnimated:YES completion:^{
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
        
        [playPanel setHidden:NO];
        
//        [self setToTime:[currentPlayTime doubleValue]];
        
        [self playClick];
    }];
}

- (void)previewController:(RPPreviewViewController *)previewController didFinishWithActivityTypes:(NSSet<NSString *> *)activityTypes{
    if ([activityTypes containsObject:@"com.apple.UIKit.activity.SaveToCameraRoll"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:@"成功保存视频到相册"];
            [SVProgressHUD dismissWithDelay:2.0];
        });
    }
    if ([activityTypes containsObject:@"com.apple.UIKit.activity.CopyToPasteboard"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:@"已经复制到粘贴板"];
            [SVProgressHUD dismissWithDelay:2.0];
        });
    }
}

#pragma mark - Button Action

- (void)editNoteAction{
    TPAddTextViewController *textVC;
    if([self isPortrait]) {
        textVC = [[TPAddTextViewController alloc] initWithNibName:@"TPAddTextViewController" bundle:[NSBundle mainBundle]];
        [textVC setAddMode:TPAddNote];
    }else{
        textVC = [[TPAddTextLandscapeViewController alloc] initWithNibName:@"TPAddTextLandscapeViewController" bundle:[NSBundle mainBundle]];
    }
    [textVC setNoteString:@""];
    textVC.addNoteViewDelegate = self;
    [textVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    self.modalPresentationStyle = UIModalPresentationCurrentContext; //关键语句，必须有
    [self presentViewController:textVC animated:YES completion:^(void){
        [self pauseClick];
    }];
}

- (void)editNoteActionWithString:(NSString *)string{
    TPAddTextViewController *textVC = [[TPAddTextViewController alloc] initWithNibName:@"TPAddTextViewController" bundle:[NSBundle mainBundle]];
    textVC.addNoteViewDelegate = self;
    [textVC setNoteString:string];
    [textVC setAddMode:TPUpdateNote];
    [textVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    self.modalPresentationStyle = UIModalPresentationCurrentContext; //关键语句，必须有
    [self presentViewController:textVC animated:YES completion:^(void){
        [self pauseClick];
    }];
}

- (void)addNoteView:(UIView *_Nonnull)view{
    [[TPNoteCreator shareInstance] addNoteView:view];
    [self reloadNoteViews];
    
    //编辑完成，继续播放视频
    [self playClick];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.noteViews indexOfObject:view] inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)updateNoteView:(UIView *_Nonnull)view{
    [[TPNoteCreator shareInstance] updateNoteView:view atIndex:selectedIndexPath.row];
    [self reloadNoteViews];
    
    //编辑完成，继续播放视频
    [self playClick];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.noteViews indexOfObject:view] inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)screenShotAction{
    [self hideToolViews:YES];
    
    //缩放因子
    CGFloat factor;
    if([self isPortrait]) {
        factor = (1.0 - 40 / CGRectGetWidth(self.view.bounds));
    }else{
        factor = (1.0 - (40 + CONTROLLER_BAR_WIDTH) / CGRectGetWidth(self.view.bounds)) / (CGRectGetWidth(self.view.bounds) / CGRectGetHeight(self.view.bounds));
    }
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(self.view.frame),
                                                      CGRectGetHeight(self.view.frame)),
                                           NO, scale);
    [self.view drawViewHierarchyInRect:CGRectMake(0,
                                                  0,
                                                  CGRectGetWidth(self.view.frame),
                                                  CGRectGetHeight(self.view.frame))
                    afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    image = [image getSubImage:CGRectMake(0,
                                          0,
                                          CGRectGetWidth([self isPortrait] ? self.view.bounds : self.playerView.frame) * scale,
                                          CGRectGetHeight(self.playerView.frame) * scale)];
    image = [image changeImageSizeWithOriginalImage:image percent:factor];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                         0,
                                                                         CGRectGetWidth(self.view.bounds) * factor,
                                                                         CGRectGetHeight(self.playerView.frame) * factor)];
    [imgView setImage:image];
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    [self addNoteView:imgView];
    UIGraphicsEndImageContext();
    
    //恢复暂停按钮
    [self hideToolViews:NO];
}

- (void)saveNote{
    NSArray *noteArr = [[TPNoteCreator shareInstance] getNoteViews];
    if(self.noteMode == TPNewNote){
        //新增模式，进入 NoteVC
        TPNote *newNote = [TPNote new];
        NSString *title;
        if([self.titleText.text isEqualToString:@""]){
            title = self.videoDict[@"short_title"];
        }else{
            title = self.titleText.text;
        }
        [newNote setTitle:title];
        [newNote setViews:[NSMutableArray arrayWithArray:noteArr]];
        [newNote setCreateTime:[NSDate date]];
        self.note = newNote;
    }else{
        //直接更新返回
        //更新：标题、Views
        [self.note setTitle:([_titleText.text isEqualToString:@""] ? self.videoDict[@"short_title"] : _titleText.text)];
        [self.note setViews:self.noteViews];
        [TPNoteManager updateNote:self.note];
    }
}

- (void)saveNoteAction{
    NSArray *noteArr = [[TPNoteCreator shareInstance] getNoteViews];
    if(noteArr.count <= 0){
        [SVProgressHUD showInfoWithStatus:@"您的笔记内容为空"];
        [SVProgressHUD dismissWithDelay:2.0];
        return;
    }
    
    [self saveNote];
    
    if(self.noteMode == TPNewNote){
        TPNoteViewController *noteVC = [[TPNoteViewController alloc] init];
        [noteVC setVideoDict:self.videoDict];
        [noteVC setNoteMode:self.noteMode];
        [noteVC setNote:self.note];
        [self.navigationController pushViewController:noteVC animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setFavoriteImage{
    UIImage *favoriteImg = [TPVideoManager isFavoriteVideo:self.videoDict[@"id"]] ? [UIImage imageNamed:@"ME_COLLECT_FULL"] : [UIImage imageNamed:@"ME_COLLECT"];
    [favoriteButton setImage:favoriteImg];
}

- (void)favoriteAction{
    [TPVideoManager commentVideo:[[TPVideo alloc] initWithVideoDict:self.videoDict]];
    [self setFavoriteImage];
}

#pragma mark - Panel Actions 

- (void)didTapEditButton{
    [self editNoteAction];
}

- (void)didTapScreenShotButton{
    [self screenShotAction];
}

- (void)didTapSaveButton{
    [self saveNoteAction];
}

- (void)didTapRecordButton{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"video_recording_tip"]){
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"录制提示"
                                                                        message:@"开始录制后，按屏幕任意区域即可结束录制" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *noMoreAction = [UIAlertAction actionWithTitle:@"不再提示" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"video_recording_tip"];
            [self startPlayerRecording];
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"开始录制" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self startPlayerRecording];
        }];
        [alertC addAction:noMoreAction];
        [alertC addAction:okAction];
        [alertC addAction:cancelAction];
        [self presentViewController:alertC animated:YES completion:nil];
    }else{
        [self startPlayerRecording];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.noteViews.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TPNoteViewTableViewCell";
    TPNoteViewTableViewCell *cell = (TPNoteViewTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell setNoteView:self.noteViews[indexPath.row]];
    [cell setBgColor:[UIColor whiteColor]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selectedIndexPath = indexPath;
    if([self.noteViews[indexPath.row] isKindOfClass:[UILabel class]]){
        UILabel *label = (UILabel *)self.noteViews[indexPath.row];
        [self editNoteActionWithString:label.text];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIView *view = self.noteViews[indexPath.row];
    return view.frame.size.height + 20;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [[TPNoteCreator shareInstance] removeNoteView:self.noteViews[indexPath.row]];
    [self reloadNoteViews];
    [tableView reloadData];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"               ";
}

#pragma mark - Rotation

// 支持旋转
- (BOOL)shouldAutorotate {
    return YES;
}

// 支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

// 默认方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    if (size.width > size.height) {
        NSLog(@"横屏");
        [self.navigationController setNavigationBarHidden:YES];
        [self.tableView setHidden:YES];
        [self.titleText setHidden:YES];
        [self.view setBackgroundColor:[UIColor blackColor]];
        
        [UIView animateWithDuration:0.5 animations:^{
            
        } completion:^(BOOL finished) {
            self.playerView.frame = CGRectMake(0,
                                               0,
                                               self.view.bounds.size.width,
                                               self.view.bounds.size.height - CONTROLLER_BAR_WIDTH);
            [[QYPlayerController sharedInstance] setPlayerFrame:self.playerView.frame];
            [playPanel setFrame:CGRectMake(CGRectGetWidth(self.playerView.frame) - PANEL_WIDTH - 30,
                                           CGRectGetHeight(self.playerView.frame) - 50,
                                           PANEL_WIDTH,
                                           30)];
            [[self.view viewWithTag:100] setFrame:CGRectMake(10,
                                                             self.view.bounds.size.height - CONTROLLER_BAR_WIDTH,
                                                             CONTROLLER_BAR_WIDTH,
                                                             CONTROLLER_BAR_WIDTH)];
            [[self.view viewWithTag:200] setFrame:CGRectMake(10,
                                                             self.view.bounds.size.height - CONTROLLER_BAR_WIDTH,
                                                             CONTROLLER_BAR_WIDTH,
                                                             CONTROLLER_BAR_WIDTH)];
            [progressBarView setFrame:CGRectMake(50,
                                                 self.playerView.frame.size.height,
                                                 self.view.bounds.size.width - 90,
                                                 CONTROLLER_BAR_WIDTH)];
            [progressBarView layoutSubviews];
            
            if (self.loadingView) {
                self.loadingView.center = CGPointMake(self.playerView.frame.size.width / 2, self.playerView.frame.size.height / 2);
            }
            
            [self.view layoutSubviews];
        }];
    } else {
        NSLog(@"竖屏");
        [self.navigationController setNavigationBarHidden:NO];
        [self.tableView setHidden:NO];
        [self.titleText setHidden:NO];
        [self.view setBackgroundColor:TPBackgroundColor];
        
        [UIView animateWithDuration:0.5 animations:^{
            
        } completion:^(BOOL finished) {
            self.playerView.frame = playFrame;
            [[QYPlayerController sharedInstance] setPlayerFrame:self.playerView.frame];
            [playPanel setFrame:CGRectMake(CGRectGetWidth(_playerView.frame) - PANEL_WIDTH - 30,
                                           CGRectGetHeight(_playerView.frame) - 50,
                                           PANEL_WIDTH,
                                           30)];
            [[self.view viewWithTag:100] setFrame:self.playPauseView.frame];
            [[self.view viewWithTag:200] setFrame:self.playPauseView.frame];
            [progressBarView setFrame:self.barContainerView.frame];
            [progressBarView layoutSubviews];
            
            if (self.loadingView) {
                self.loadingView.center = CGPointMake(self.playerView.frame.size.width / 2, self.playerView.frame.size.height / 2);
            }
            
            
            [self.view layoutSubviews];
        }];
    }
}

- (BOOL)isPortrait{
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        //翻转为竖屏时
        return YES;
    }else{
        return NO;
    }
}

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector  = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Drag Delegate

- (void)tableView:(UITableView *)tableView dragCellFrom:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath{
    // 更新数组中的内容
    [[TPNoteCreator shareInstance] moveNoteViewFromIndex:fromIndexPath.row toIndex:toIndexPath.row];
    [self.noteViews exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
    [self.tableView moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
}

- (void)tableView:(UITableView *)tableView endDragCellTo:(NSIndexPath *)indexPath{
    [self reloadNoteViews];
}

#pragma mark - DZNEmptyTableViewDelegate

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName: TPColor,
                                 NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size:20.0]
                                 };
    
    return [[NSAttributedString alloc] initWithString:@"添加一段文字笔记" attributes:attributes];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button{
    [self editNoteAction];
}

@end

