//
//  TPNoteViewController.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/26.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPNoteViewController.h"
#import "Utilities.h"
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

#define STACK_SPACING 20
#define TOOLBAR_HEIGHT 60

@interface TPNoteViewController () <UITableViewDelegate, UITableViewDataSource, TPAddNoteViewDelegate>

@property (nonnull, nonatomic) NSMutableArray *touchPoints;
@property (nonnull, nonatomic) UITableView *tableView;

@end

@implementation TPNoteViewController{
    NSIndexPath *selectedIndexPath;
    NSMutableArray<UIView *> *showViews;    //展示用
    UISegmentedControl *segment;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    showViews = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [Utilities getBackgroundColor];
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
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    
    //长按拖动手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.tableView addGestureRecognizer:longPress];
    self.touchPoints = [[NSMutableArray alloc] init];
    
    //点击标题进行更改
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
//    [button addTarget:self action:@selector(editTitleAction) forControlEvents:UIControlEventTouchUpInside];
//    button.contentMode = UIViewContentModeScaleAspectFit;
//    self.navigationItem.titleView = button;
    
    //保存按钮
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 44,
                                                                      20,
                                                                      24,
                                                                      24)];
    saveButton.tintColor = [UIColor whiteColor];
    [saveButton setImage:[[UIImage imageNamed:@"NOTE_SAVE"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveNoteAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    self.navigationItem.rightBarButtonItem = saveButtonItem;

    //底下按钮
    UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [deleteButton setImage:[UIImage imageNamed:@"NOTE_DELETE"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    UIButton *videoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [videoButton setImage:[UIImage imageNamed:@"NOTE_VIDEO"] forState:UIControlStateNormal];
    [videoButton addTarget:self action:@selector(videoAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *exportButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [exportButton setImage:[UIImage imageNamed:@"NOTE_EXPORT"] forState:UIControlStateNormal];
    [exportButton addTarget:self action:@selector(exportAlbumAction) forControlEvents:UIControlEventTouchUpInside];
    UIStackView *buttonStack = [[UIStackView alloc] initWithFrame:CGRectMake(0,
                                                                            CGRectGetHeight(self.tableView.bounds),
                                                                            CGRectGetWidth(self.view.bounds),
                                                                            TOOLBAR_HEIGHT)];
    [buttonStack addArrangedSubview:deleteButton];
    [buttonStack addArrangedSubview:videoButton];
    [buttonStack addArrangedSubview:exportButton];
    buttonStack.axis = UILayoutConstraintAxisHorizontal;
    buttonStack.alignment = UIStackViewAlignmentFill;
    buttonStack.distribution = UIStackViewDistributionFillEqually;
    
    //老的 Note，查看模式
    if(self.noteMode == TPOldNote){
        [self.view addSubview:buttonStack];
    }
    
    segment = [[UISegmentedControl alloc] initWithItems:@[@"Green", @"Brown"]];
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

- (void)setNoteTitle:(NSString *)noteTitle{
    _noteTitle = noteTitle;
    self.note.title = noteTitle;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:YES];
    
    self.noteTitle = self.note.title;
    self.noteViews = [NSMutableArray arrayWithArray:self.note.views];

    [self reloadShowViews];
}

- (void)viewWillDisappear:(BOOL)animated{
    if(self.noteMode == TPOldNote){
        [self saveNote];
    }
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)reloadShowViews{
    self.note.templateNum = segment.selectedSegmentIndex;
    showViews = [NSMutableArray arrayWithArray:[TPNoteDecorator getNoteViews:self.note andTemplate:[TPNoteTemplateFactory getTemplateOfNum:self.note.templateNum]]];
    self.view.backgroundColor = showViews[0].backgroundColor;
    self.tableView.backgroundColor = showViews[0].backgroundColor;
    [self.tableView reloadData];
}

#pragma mark - Button Action

- (void)videoAction{
    TPVideo *video = [TPVideoManager fetchVideoWithID:self.note.videoid];
    if(video == NULL){
        NSLog(@"没视频");
    }else{
        TPPlayViewController *playViewController = [[TPPlayViewController alloc] initWithNibName:@"TPPlayViewController" bundle:nil];
        [playViewController setNote:self.note];
        [playViewController setNoteMode:TPOldNote];
        [playViewController setVideoDict:video.dict];
        [playViewController setNoteViews:self.noteViews];
        [playViewController setNoteTitle:self.noteTitle];
        
        [self.navigationController pushViewController:playViewController animated:YES];
    }
}

- (void)deleteAction{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"确认删除吗"
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
    if(self.noteMode == TPNewNote){
        TPNote *note = [TPNote new];
        [note setVideoid:(NSInteger)self.videoDict[@"id"]];
        [note setTitle:self.noteTitle];
        [note setCreateTime:self.note.createTime];
        [note setViews:self.noteViews];
        [note setTemplateNum:segment.selectedSegmentIndex];
        
        success = [TPNoteManager insertNote:note];
        
        TPVideo *video = [TPVideo new];
        [video setVideoid:(NSInteger)self.videoDict[@"id"]];
        [video setDict:self.videoDict];
        success = success && [TPVideoManager insertVideo:video];
    }else{
        [self.note setViews:[NSArray arrayWithArray:self.noteViews]];
        [self.note setTitle:self.noteTitle];
        [self.note setTemplateNum:segment.selectedSegmentIndex];
        
        success = [TPNoteManager updateNote:self.note];
    }
    return success;
}

- (void)saveNoteAction{
    BOOL success = [self saveNote];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:success ? @"保存成功" : @"保存失败"
                                                                    message:nil
                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action){
                                                             [self.navigationController popToRootViewControllerAnimated:YES];
                                                     }];
    [alertC addAction:okAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)deleteNote{
    if ([TPNoteManager deleteNoteWithID:self.note.noteid]) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"删除成功"
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"好的"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                [self.navigationController popViewControllerAnimated:YES];
                                                            }];
        [alertC addAction:albumAction];
        [self presentViewController:alertC animated:YES completion:nil];
    }else{
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"删除失败"
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alertC addAction:okAction];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}

- (void)editTitleAction{
    [self editNoteActionWithString:self.noteTitle andMode:TPUpdateTitle];
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
    [self.noteViews replaceObjectAtIndex:selectedIndexPath.row - 2 withObject:view];
    self.note.views = self.noteViews;
    [self reloadShowViews];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.noteViews indexOfObject:view] + 2 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)updateTitle:(NSString *)title{
    [self setNoteTitle:title];
    [self reloadShowViews];
}

#pragma mark - Long Pressed Gesture

- (UIView *)customSnapshotFromView:(UIView *)inputView {
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
                if(indexPath.row < 2){
                    return;
                }
                sourceIndexPath = indexPath;
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                // 为拖动的cell添加一个快照
                snapshot = [self customSnapshotFromView:cell];
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
            if(sourceIndexPath.row < 2){
                return;
            }
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
            if (indexPath && indexPath.row >= 2 && ![indexPath isEqual:sourceIndexPath]) {
                // 更新数组中的内容
                [self.noteViews exchangeObjectAtIndex:
                 indexPath.row - 2 withObjectAtIndex:sourceIndexPath.row - 2];
                
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

#pragma mark - Save to album

- (void)exportAlbumAction{
    UIGraphicsBeginImageContextWithOptions(self.tableView.contentSize, NO, [[UIScreen mainScreen] scale]);
    
    CGPoint savedContentOffset = self.tableView.contentOffset;
    CGRect saveFrame = self.tableView.frame;
    self.tableView.contentOffset = CGPointZero;
    self.tableView.frame = CGRectMake(0, 0, self.tableView.contentSize.width, self.tableView.contentSize.height);
    
    [self.tableView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    self.tableView.contentOffset = savedContentOffset;
    self.tableView.frame = saveFrame;
    
    UIGraphicsEndImageContext();
    
    NSLog(@"%lu", (unsigned long)self.noteViews.count);
    
    UIImageWriteToSavedPhotosAlbum(image,
                                   self,
                                   @selector(image:didFinishSavingWithError:contextInfo:),
                                   nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error == nil) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"保存成功"
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
    [cell setBackgroundColor:showViews[0].backgroundColor];
    [cell setNoteView:showViews[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selectedIndexPath = indexPath;
    if(indexPath.row == 0){
        return;
    }else if(indexPath.row == 1){
        [self editTitleAction];
    }else if([self.noteViews[indexPath.row - 2] isKindOfClass:[UILabel class]]){
        UILabel *label = (UILabel *)self.noteViews[indexPath.row - 2];
        [self editNoteActionWithString:label.text andMode:TPUpdateNote];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row < 2){
        return showViews[indexPath.row].frame.size.height + 10;
    }else{
        return self.noteViews[indexPath.row - 2].frame.size.height + 20;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.noteViews removeObjectAtIndex:indexPath.row - 2];
    self.note.views = self.noteViews;
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

@end
