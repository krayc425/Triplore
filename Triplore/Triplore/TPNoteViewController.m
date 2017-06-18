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
#import "Triplore-Swift.h"
#import "TPNoteCreator.h"

#define STACK_SPACING 20
#define TOOLBAR_HEIGHT 60

@interface TPNoteViewController () <UITableViewDelegate, UITableViewDataSource, TPAddNoteViewDelegate, DragableTableDelegate>

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
    self.view.backgroundColor = [Utilities getBackgroundColor];
    
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
    }else{
        //老的 Note，查看模式
        
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
        [self.view addSubview:buttonStack];
    }
    
    segment = [[UISegmentedControl alloc] initWithItems:@[@"绿", @"棕"]];
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
}

- (void)viewWillDisappear:(BOOL)animated{
    if(self.noteMode == TPOldNote){
        [self saveNote];
    }
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)reloadShowViews{
    self.note.templateNum = segment.selectedSegmentIndex;
    template = [TPNoteTemplateFactory getTemplateOfNum:self.note.templateNum];
    showViews = [NSMutableArray arrayWithArray:[TPNoteDecorator getNoteViews:self.note andTemplate:template]];
    self.view.backgroundColor = template.tem_color;
    self.tableView.backgroundColor = template.tem_color;
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
        [playViewController setNoteViews:self.note.views];
        [playViewController setNoteTitle:self.note.title];
        
        [self.navigationController pushViewController:playViewController animated:YES];
    }
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
    if(self.noteMode == TPNewNote){
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
    return success;
}

- (void)saveNoteAction{
    BOOL success = [self saveNote];
    
    [[TPNoteCreator shareInstance] clearNoteView];
    
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
    
    NSLog(@"%lu", (unsigned long)self.note.views.count);
    
    UIImageWriteToSavedPhotosAlbum(image,
                                   self,
                                   @selector(image:didFinishSavingWithError:contextInfo:),
                                   nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSLog(@"%@", image.description);
    
    if (error == nil) {
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row < 2){
        return showViews[indexPath.row].frame.size.height + 10;
    }else{
        return self.note.views[indexPath.row - 2].frame.size.height + 20;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.note.views removeObjectAtIndex:indexPath.row - 2];
//    self.note.views = self.noteViews;
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
    return indexPath.row >= 2;
}

- (BOOL)tableView:(UITableView *)tableView canDragCellFrom:(NSIndexPath *)fromIndexPath over:(NSIndexPath *)overIndexPath{
    return fromIndexPath.row >= 2 && overIndexPath.row >= 2;
}

- (void)tableView:(UITableView *)tableView endDragCellTo:(NSIndexPath *)indexPath{
    [self reloadShowViews];
}

@end
