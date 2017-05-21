//
//  QYPlayerController.h
//  QYPlayerController
//
//  Copyright (c) 2017-present, IQIYI, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class QYPlayerController;

/*
 播放控制相关的Delegate
 */
@protocol QYPlayerControllerDelegate <NSObject>

@optional

/*
 * 显示加载loading
 */
-(void)startLoading:(QYPlayerController *)player;

/*
 * 关闭加载loading
 */
-(void)stopLoading:(QYPlayerController *)player;

/*
 * 播放时长发生变化
 */
-(void)playbackTimeChanged:(QYPlayerController *)player;

/*
 * 播放完成
 */
-(void)playbackFinshed:(QYPlayerController *)player;

/*
 * 网络变化
 */
- (void)playerNetworkChanged:(QYPlayerController *)player;

/*
 * 播放出错
 */
-(void)onPlayerError:(NSDictionary *)error_no;

/*
 * 开始播放广告
 */
- (void)onAdStartPlay:(QYPlayerController *)player;

/*
 * 开始播放正片
 */
- (void)onContentStartPlay:(QYPlayerController *)player;


@end

@interface QYPlayerController : UIViewController

@property (nonatomic, weak)id<QYPlayerControllerDelegate> delegate;

+ (QYPlayerController *)sharedInstance;

/*
 * 初始化方法 请在AppDelegate的application: didFinishLaunchingWithOptions：中调用
 */
- (void)initPlayer;

/*
 * 播放影片
 */

- (void)openPlayerByAlbumId:(NSString*)albumId tvId:(NSString*)tvId isVip:(NSString*)isVip;

/*
 * 暂停播放
 */
- (void)pause;

/*
 * 继续播放
 */
- (void)play;

/*
 * 功能: seek到指定的时间点播放， 注意调用的时间点，应该在视频加载成功后调用，否则不起作用
 * time：目标时间点
 */
- (void)seekToTime:(double)time;

/*
 * 功能:  返回当前播放进度 单位 s
 * 参数：
 */
- (double)currentPlaybackTime;
/*
 * 功能:  返回视频总时长，加载完成后有效 单位 s
 * 参数：
 */
- (double)duration;

/*
 * 功能:  获得已经缓冲的视频长度 单位 s
 * 参数：
 */
- (double)playableDuration;

/*
 * 停止播放器
 */
- (void)stopPlayer;


/*
 * 更改播放器的frame
 */
- (void)setPlayerFrame:(CGRect)rect;

/*
 * 功能: 是否播放
 *
 */
-(BOOL)isPlaying;

/*
 *  是否加载
 */
- (BOOL)isLoading;

/*
 * 功能: 设置静音
 *
 */
-(void)setMute:(BOOL)mute;

@end
