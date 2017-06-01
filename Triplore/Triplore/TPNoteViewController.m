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

#define STACK_SPACING 20
#define TOOLBAR_HEIGHT 60

@interface TPNoteViewController () <UITableViewDelegate, UITableViewDataSource, TPAddNoteViewDelegate>

@property (nonnull, nonatomic) UITableView *tableView;

@end

@implementation TPNoteViewController{
    NSIndexPath *selectedIndexPath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Utilities getBackgroundColor];
    //滚动视图
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   CGRectGetWidth(self.view.bounds),
                                                                   CGRectGetHeight(self.view.bounds) - 64 - TOOLBAR_HEIGHT * (self.note != NULL ? 1 : 0))
                                                  style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    
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
    UIButton *editButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [editButton setImage:[UIImage imageNamed:@"NOTE_EDIT"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
    UIStackView *buttonStack = [[UIStackView alloc] initWithFrame:CGRectMake(0,
                                                                            CGRectGetHeight(self.tableView.bounds),
                                                                            CGRectGetWidth(self.view.bounds),
                                                                            TOOLBAR_HEIGHT)];
    [buttonStack addArrangedSubview:deleteButton];
    [buttonStack addArrangedSubview:videoButton];
    [buttonStack addArrangedSubview:editButton];
    buttonStack.axis = UILayoutConstraintAxisHorizontal;
    buttonStack.alignment = UIStackViewAlignmentFill;
    buttonStack.distribution = UIStackViewDistributionFillEqually;
    
    //非添加，查看模式
    if(self.note != NULL && self.note.noteid > 0){
        [self.view addSubview:buttonStack];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:YES];
    
    if(self.note != NULL && self.note.noteid > 0){
        self.noteTitle = self.note.title;
        self.title = self.noteTitle;
        self.noteViews = [NSMutableArray arrayWithArray:self.note.views];
    }
    
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:NO];
}

#pragma mark - Button Action

- (void)editAction{
    [self.tableView setEditing:!self.tableView.isEditing animated:YES];
    [self.tableView reloadData];
}

- (void)videoAction{
    TPVideo *video = [TPVideoManager fetchVideoWithID:self.note.videoid];
    if(video == NULL){
        NSLog(@"没视频");
    }else{
        
    }
}

- (void)deleteAction{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"确认删除吗\n该操作不可恢复"
                                                                    message:nil
                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                          style:UIAlertActionStyleCancel
                                                        handler:nil];
    [alertC addAction:cancelAction];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"删除"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [self deleteNote];
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

- (void)editNoteActionWithString:(NSString *)string{
    TPAddTextViewController *textVC = [[TPAddTextViewController alloc] initWithNibName:@"TPAddTextViewController" bundle:[NSBundle mainBundle]];
    textVC.addNoteViewDelegate = self;
    [textVC setNoteString:string];
    [textVC setAddMode:TPUpdateNote];
    [textVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    self.modalPresentationStyle = UIModalPresentationCurrentContext; //关键语句，必须有
    [self presentViewController:textVC animated:YES completion:nil];
}

- (void)updateNoteView:(UIView *_Nonnull)view{
    [self.noteViews replaceObjectAtIndex:selectedIndexPath.row withObject:view];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.noteViews indexOfObject:view] inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - Save to album

- (void)saveNoteAction{
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
    
    UIImageWriteToSavedPhotosAlbum(image,
                                   self,
                                   @selector(image:didFinishSavingWithError:contextInfo:),
                                   nil);
    
    //新增
    if(self.note == NULL){
        TPNote *note = [TPNote new];
        [note setVideoid:(NSInteger)self.videoDict[@"id"]];
        [note setTitle:self.noteTitle];
        [note setViews:self.noteViews];
        [note setCreateTime:[NSDate date]];
        [TPNoteManager insertNote:note];
        
        TPVideo *video = [TPVideo new];
        [video setVideoid:(NSInteger)self.videoDict[@"id"]];
        [video setDict:self.videoDict];
        [TPVideoManager insertVideo:video];
    }else{
        [self.note setViews:[NSArray arrayWithArray:self.noteViews]];
        
        [TPNoteManager updateNote:self.note];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error == nil) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"保存成功"
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"返回"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             [self.navigationController popToRootViewControllerAnimated:YES];
                                                         }];
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
    if(self.tableView.editing){
        selectedIndexPath = indexPath;
        if([self.noteViews[indexPath.row] isKindOfClass:[UILabel class]]){
            UILabel *label = (UILabel *)self.noteViews[indexPath.row];
            [self editNoteActionWithString:label.text];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.noteViews[indexPath.row].frame.size.height + 20;
}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    [self.noteViews exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

@end
