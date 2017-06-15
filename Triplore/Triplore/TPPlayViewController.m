//
//  TPPlayViewController.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/30.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPPlayViewController.h"
#import "QYPlayerController.h"
#import "ActivityIndicatorView.h"
#import "Utilities.h"
#import "TPNoteCreator.h"
#import "TPNoteViewController.h"
#import "TPAddTextViewController.h"
#import "QYAVPlayerController.h"
#import "PlayerController.h"
#import "UIImage+Extend.h"
#import "TPNote.h"
#import "TPNoteManager.h"
#import "TPNoteViewTableViewCell.h"
#import "TPVideoManager.h"
#import "TPVideo.h"
#import "TPVideoProgressBar.h"

#define CONTROLLER_BAR_WIDTH 30.0

#define KIPhone_AVPlayerRect_mwidth 320.0
#define KIPhone_AVPlayerRect_mheight 180.0

@interface TPPlayViewController () <QYPlayerControllerDelegate, TPAddNoteViewDelegate, PlayerControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, TPVideoProgressDelegate>{
    CGRect playFrame;
    CGRect stackFrame;
    NSIndexPath *selectedIndexPath;
    UIBarButtonItem *favoriteButton;
    TPVideoProgressBar *progressBarView;
}

@property (nonatomic, nonnull) IBOutlet UIView *playerView;
@property (nonatomic, nonnull) IBOutlet UITextField *titleText;
@property (nonatomic, nonnull) IBOutlet UIButton *editButton;
@property (nonatomic, nonnull) IBOutlet UIButton *screenshotButton;
@property (nonatomic, nonnull) IBOutlet UIButton *saveButton;
@property (nonatomic, nonnull) IBOutlet UIView *playPauseView;
@property (nonatomic, nonnull) IBOutlet UIView *barContainerView;
@property (nonatomic, nonnull) IBOutlet UITableView *tableView;
@property (nonatomic, nonnull) IBOutlet UIStackView *buttonStack;

@property (nonatomic,strong) ActivityIndicatorView *activityWheel;
@property (nonnull, nonatomic) NSMutableArray *touchPoints;

@end

@implementation TPPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [Utilities getBackgroundColor];

    self.navigationController.navigationBar.barTintColor = [Utilities getColor];
    self.navigationController.navigationBar.backgroundColor = [Utilities getColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"视频";
    
    self.hidesBottomBarWhenPushed = YES;
    self.tabBarController.tabBar.hidden = YES;
    
    [QYPlayerController sharedInstance].delegate = self;
    [[QYPlayerController sharedInstance] setPlayerFrame:self.playerView.frame];
    NSLog(@"%f %f %f %f", self.playerView.frame.size.height, self.playerView.frame.size.width, self.playerView.frame.origin.x, self.playerView.frame.origin.y);
    [_playerView addSubview:[QYPlayerController sharedInstance].view];
    
    playFrame = CGRectMake(0,
                           0,
                           [[UIScreen mainScreen] bounds].size.width,
                           [[UIScreen mainScreen] bounds].size.width / KIPhone_AVPlayerRect_mwidth * KIPhone_AVPlayerRect_mheight);
    
    ActivityIndicatorView *wheel = [[ActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    wheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.activityWheel = wheel;
    self.activityWheel.center = CGPointMake(playFrame.size.width / 2, playFrame.size.height / 2 + 15);
    
    _titleText.placeholder = @"填写笔记标题";
    _titleText.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18.0f];
    _titleText.delegate = self;
    _titleText.textColor = [UIColor colorWithRed:94.0/255.0 green:113.0/255.0 blue:113.0/255.0 alpha:1.0];
    
    //三个按钮
    [_editButton setImage:[UIImage imageNamed:@"NOTE_EDIT"] forState:UIControlStateNormal];
    [_editButton addTarget:self action:@selector(editNoteAction) forControlEvents:UIControlEventTouchUpInside];
    _editButton.tintColor = [Utilities getColor];
    
    [_screenshotButton setImage:[UIImage imageNamed:@"NOTE_SCREENSHOT"] forState:UIControlStateNormal];
    [_screenshotButton addTarget:self action:@selector(screenShotAction) forControlEvents:UIControlEventTouchUpInside];
    _screenshotButton.tintColor = [Utilities getColor];
    
    [_saveButton setImage:[UIImage imageNamed:@"NOTE_SAVE"] forState:UIControlStateNormal];
    [_saveButton addTarget:self action:@selector(saveNoteAction) forControlEvents:UIControlEventTouchUpInside];
    _saveButton.tintColor = [Utilities getColor];
    
    //进度
    progressBarView = [[[NSBundle mainBundle] loadNibNamed:@"TPVideoProgressBar" owner:nil options:nil] lastObject];
    [progressBarView.slider setThumbImage:[UIImage imageNamed:@"PROGRESS_OVAL"] forState:UIControlStateNormal];
    [progressBarView.slider setMinimumTrackTintColor:[UIColor colorWithRed:33.0/255.0 green:184.0/255.0 blue:34.0/255.0 alpha:1.0]];
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
    
    //长按拖动手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.tableView addGestureRecognizer:longPress];
    self.touchPoints = [[NSMutableArray alloc] init];
    
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
    UIImage *favoriteImg = [TPVideoManager isFavoriteVideo:[self.videoDict[@"id"] integerValue]] ? [UIImage imageNamed:@"ME_COLLECT_FULL"] : [UIImage imageNamed:@"ME_COLLECT"];
    favoriteButton = [[UIBarButtonItem alloc] initWithImage:favoriteImg style:UIBarButtonItemStylePlain target:self action:@selector(favoriteAction)];
    self.navigationItem.rightBarButtonItem = favoriteButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:NO];
    [self reloadNoteViews];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSString* aid = [self.videoDict valueForKey:@"a_id"];
    NSString* tvid = [self.videoDict valueForKey:@"tv_id"];
    NSString* isvip = [self.videoDict valueForKey:@"is_vip"];
    [[QYPlayerController sharedInstance] openPlayerByAlbumId:aid tvId:tvid isVip:isvip];
    
    self.title = self.videoDict[@"short_title"];
    
    //存入视频列表，因为要存“最近观看”
    TPVideo *newVideo = [[TPVideo alloc] initWithVideoDict:self.videoDict];
    [TPVideoManager insertVideo:newVideo];
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    [[QYPlayerController sharedInstance] pause];
    [self saveNote];
    
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
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
    [[QYPlayerController sharedInstance] play];
    [self showPauseView];
}

- (void)pauseClick{
    if ([QYPlayerController sharedInstance].isPlaying==YES) {
        [[QYPlayerController sharedInstance] pause];
        [self showPlayView];
    }
}

#pragma QYBasePlayerControllerDelegate

/*
 * 播放出错
 */
- (void)onPlayerError:(NSDictionary *)error_no{
    [self.activityWheel stopAnimating];
    [self.activityWheel removeFromSuperview];
}

/*
 * 显示加载loading
 */
- (void)startLoading:(QYPlayerController *)player{
    if (self.activityWheel.superview==nil) {
        [self.view addSubview:self.activityWheel];
        [self.activityWheel startAnimating];
    }
    [self unablePlayPauseView];
}

/*
 * 关闭加载loading
 */
- (void)stopLoading:(QYPlayerController *)player{
    [self.activityWheel stopAnimating];
    [self.activityWheel removeFromSuperview];
    [self enablePlayPauseView];
}
/**
 **功能: 开始播放广告
 *
 */
- (void)onAdStartPlay:(QYPlayerController *)player{
    [self showPauseView];
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

#pragma mark - Button Action

- (void)editNoteAction{
    TPAddTextViewController *textVC = [[TPAddTextViewController alloc] initWithNibName:@"TPAddTextViewController" bundle:[NSBundle mainBundle]];
    textVC.addNoteViewDelegate = self;
    [textVC setNoteString:@""];
    [textVC setAddMode:TPAddNote];
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
    NSLog(@"%lu Views", (long)[[TPNoteCreator shareInstance] countNoteView]);
    [self reloadNoteViews];
    
    //编辑完成，继续播放视频
    [self playClick];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.noteViews indexOfObject:view] inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)updateNoteView:(UIView *_Nonnull)view{
    [[TPNoteCreator shareInstance] updateNoteView:view atIndex:selectedIndexPath.row];
    NSLog(@"%lu Views", (long)[[TPNoteCreator shareInstance] countNoteView]);
    [self reloadNoteViews];
    
    //编辑完成，继续播放视频
    [self playClick];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.noteViews indexOfObject:view] inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)screenShotAction{
    NSLog(@"截图");
    //隐藏暂停按钮
    [[self.view viewWithTag:100] setHidden:YES];
    [[self.view viewWithTag:200] setHidden:YES];
    //缩放因子
    CGFloat factor = (1.0 - 40 / CGRectGetWidth(self.view.bounds));
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)), NO, scale);
    [self.view drawViewHierarchyInRect:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    image = [image getSubImage:CGRectMake(0, 0, CGRectGetWidth(self.view.frame) * scale, CGRectGetHeight(self.playerView.frame) * scale)];
    image = [image changeImageSizeWithOriginalImage:image percent:factor];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) * factor, CGRectGetHeight(self.playerView.frame) * factor)];
    [imgView setImage:image];
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    [self addNoteView:imgView];
    UIGraphicsEndImageContext();
    //恢复暂停按钮
    [[self.view viewWithTag:100] setHidden:NO];
    [[self.view viewWithTag:200] setHidden:NO];
}

- (void)saveNote{
    NSLog(@"保存");
    NSArray *noteArr = [[TPNoteCreator shareInstance] getNoteViews];
    if(self.noteMode == TPNewNote){
        //新增模式，进入 NoteVC
        TPNote *newNote = [TPNote new];
        [newNote setTitle:([_titleText.text isEqualToString:@""] ? self.videoDict[@"short_title"] : _titleText.text)];
        [newNote setViews:noteArr];
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
        NSLog(@"没有 View");
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"您的笔记内容为空"
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                         }];
        [alertC addAction:okAction];
        [self presentViewController:alertC animated:YES completion:nil];
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
    UIImage *favoriteImg = [TPVideoManager isFavoriteVideo:[self.videoDict[@"id"] integerValue]] ? [UIImage imageNamed:@"ME_COLLECT_FULL"] : [UIImage imageNamed:@"ME_COLLECT"];
    [favoriteButton setImage:favoriteImg];
}

- (void)favoriteAction{
    [TPVideoManager commentVideo:[[TPVideo alloc] initWithVideoDict:self.videoDict]];
    [self setFavoriteImage];
}

#pragma mark - Long Pressed Gesture

- (UIView *)customSnapshoFromView:(UIView *)inputView {
    // 用cell的图层生成UIImage，方便一会显示
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 自定义这个快照的样子（下面的一些参数可以自己随意设置）
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    return snapshot;
}

- (void)longPressGestureRecognized:(id)sender {
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    CGPoint location = [longPress locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    static UIView       *snapshot = nil;
    static NSIndexPath  *sourceIndexPath = nil;
    switch (state) {
            // 已经开始按下
        case UIGestureRecognizerStateBegan: {
            // 判断是不是按在了cell上面
            if (indexPath) {
                sourceIndexPath = indexPath;
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                // 为拖动的cell添加一个快照
                snapshot = [self customSnapshoFromView:cell];
                // 添加快照至tableView中
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.tableView addSubview:snapshot];
                // 按下的瞬间执行动画
                [UIView animateWithDuration:0.25 animations:^{
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    cell.alpha = 0.0;
                } completion:^(BOOL finished) {
                    cell.hidden = YES;
                }];
            }
            break;
        }
            // 移动过程中
        case UIGestureRecognizerStateChanged: {
            // 这里保持数组里面只有最新的两次触摸点的坐标
            [self.touchPoints addObject:[NSValue valueWithCGPoint:location]];
            if (self.touchPoints.count > 2) {
                [self.touchPoints removeObjectAtIndex:0];
            }
            CGPoint center = snapshot.center;
            // 快照随触摸点y值移动（当然也可以根据触摸点的y轴移动量来移动）
            center.y = location.y;
            // 快照随触摸点x值改变量移动
            CGPoint Ppoint = [[self.touchPoints firstObject] CGPointValue];
            CGPoint Npoint = [[self.touchPoints lastObject] CGPointValue];
            CGFloat moveX = Npoint.x - Ppoint.x;
            center.x += moveX;
            snapshot.center = center;
            // 是否移动了
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                
                // 更新数组中的内容
                [[TPNoteCreator shareInstance] moveNoteViewFromIndex:indexPath.row toIndex:sourceIndexPath.row];
                [self reloadNoteViews];
                
                // 把cell移动至指定行
                [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // 存储改变后indexPath的值，以便下次比较
                sourceIndexPath = indexPath;
            }
            break;
        }
            // 长按手势取消状态
        default: {
            // 清除操作
            // 清空数组，非常重要，不然会发生坐标突变！
            [self.touchPoints removeAllObjects];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
            cell.hidden = NO;
            cell.alpha = 0.0;
            // 将快照恢复到初始状态
            [UIView animateWithDuration:0.25 animations:^{
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;
            } completion:^(BOOL finished) {
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
            }];
            break;
        }
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
    if (size.width > size.height) { // 横屏
        NSLog(@"横屏");
        [self.navigationController setNavigationBarHidden:YES];
        [self.tableView setHidden:YES];
        [self.titleText setHidden:YES];
        [self.editButton setHidden:YES];
        [self.saveButton setHidden:YES];
        [self.screenshotButton setHidden:YES];
        [self.view setBackgroundColor:[UIColor blackColor]];
        
        [UIView animateWithDuration:0.5 animations:^{
            
        } completion:^(BOOL finished) {
            self.playerView.frame = CGRectMake(0,
                                               0,
                                               self.view.bounds.size.width,
                                               self.view.bounds.size.height - CONTROLLER_BAR_WIDTH);
            [[QYPlayerController sharedInstance] setPlayerFrame:self.playerView.frame];
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
            [self.view layoutSubviews];
        }];
    } else {
        NSLog(@"竖屏");
        [self.navigationController setNavigationBarHidden:NO];
        [self.tableView setHidden:NO];
        [self.titleText setHidden:NO];
        [self.editButton setHidden:NO];
        [self.saveButton setHidden:NO];
        [self.screenshotButton setHidden:NO];
        [self.view setBackgroundColor:[Utilities getBackgroundColor]];
        
        [UIView animateWithDuration:0.5 animations:^{
            
        } completion:^(BOOL finished) {
            self.playerView.frame = playFrame;
            [[QYPlayerController sharedInstance] setPlayerFrame:self.playerView.frame];
            [[self.view viewWithTag:100] setFrame:self.playPauseView.frame];
            [[self.view viewWithTag:200] setFrame:self.playPauseView.frame];
            [progressBarView setFrame:self.barContainerView.frame];
            [progressBarView layoutSubviews];
            [self.view layoutSubviews];
        }];
    }
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
    
