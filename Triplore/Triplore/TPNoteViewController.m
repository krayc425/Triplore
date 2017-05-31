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

#define STACK_SPACING 20
#define TOOLBAR_HEIGHT 60

@interface TPNoteViewController ()

@property (nonnull, nonatomic) UITableView *tableView;

@end

@implementation TPNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Utilities getBackgroundColor];
    // Do any additional setup after loading the view.
    NSLog(@"Video Dict %@", self.videoDict.description);
    //滚动视图
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   CGRectGetWidth(self.view.bounds),
                                                                   CGRectGetHeight(self.view.bounds) - 64 - TOOLBAR_HEIGHT)
                                                  style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    
    //标题
    UILabel *noteTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                        0,
                                                                        self.view.frame.size.width - 40,
                                                                        24)];
    noteTitleLabel.text = self.noteTitle;
    noteTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18.0f];
    noteTitleLabel.textColor = [UIColor colorWithRed:94.0/255.0 green:113.0/255.0 blue:113.0/255.0 alpha:1.0];

    //子视图
//    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 20)];
//    [label1 setText:@"Test 1"];
//    [label1 sizeToFit];
//    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 20)];
//    [label2 setText:@"Test 2"];
//    [label2 sizeToFit];
//    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 20)];
//    [label3 setText:@"Test 3"];
//    [label3 sizeToFit];
//    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 20)];
//    [label4 setText:@"Test 4"];
//    [label4 sizeToFit];
//    UIImage *image = [UIImage imageNamed:@"TEST_PNG"];
//    UIImageView *imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), image.size.height)];
//    [imgView1 setImage:image];
//    [imgView1 setContentMode:UIViewContentModeScaleAspectFit];
//    self.noteViews = @[noteTitleLabel, label1, label2, label3, imgView1, label4];
    
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
    UIButton *videoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [videoButton setImage:[UIImage imageNamed:@"NOTE_VIDEO"] forState:UIControlStateNormal];
    UIButton *editButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [editButton setImage:[UIImage imageNamed:@"NOTE_EDIT"] forState:UIControlStateNormal];
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
    [self.view addSubview:buttonStack];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:NO];
}

#pragma mark - Save to album

- (void)saveNoteAction{
    UIGraphicsBeginImageContextWithOptions(self.tableView.frame.size, NO, [[UIScreen mainScreen] scale]);
    [self.tableView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    
    
    
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
    return self.noteViews.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TPNoteViewTableViewCell";
    UINib *nib = [UINib nibWithNibName:@"TPNoteViewTableViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    TPNoteViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [cell setNoteView:self.noteViews[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.noteViews[indexPath.row].frame.size.height + 20;
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
