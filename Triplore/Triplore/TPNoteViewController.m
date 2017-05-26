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

#define STACK_SPACING 20

@interface TPNoteViewController (){
    UIStackView *stackView;
}

@end

@implementation TPNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Utilities getBackgroundColor];
    // Do any additional setup after loading the view.
    
    //滚动视图
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     CGRectGetWidth(self.view.bounds),
                                                                     CGRectGetHeight(self.view.bounds))];
    self.scrollView.contentSize = self.view.bounds.size;
    
    //标题
    UILabel *noteTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                        20,
                                                                        self.view.frame.size.width - 40,
                                                                        24)];
    noteTitleLabel.text = self.noteTitle;
    noteTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18.0f];
    noteTitleLabel.textColor = [UIColor colorWithRed:94.0/255.0 green:113.0/255.0 blue:113.0/255.0 alpha:1.0];
    [self.scrollView addSubview:noteTitleLabel];

    //子视图
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 20)];
    [label1 setText:@"Test 1"];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 20)];
    [label2 setText:@"Test 2"];
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 20)];
    [label3 setText:@"Test 3"];
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 20)];
    [label4 setText:@"Test 4"];
    UIImage *image = [UIImage imageNamed:@"TEST_PNG"];
    UIImageView *imgView1 = [[UIImageView alloc] initWithImage:image];
    self.noteViews = @[label1, label2, label3, imgView1, label4];
    
    //加入 StackView
    CGFloat height = 0.0;
    for(UIView *view in self.noteViews){
        height += (view.frame.size.height + STACK_SPACING);
    }
    stackView = [[UIStackView alloc] initWithFrame:CGRectMake(20,
                                                              20 + 44,
                                                              CGRectGetWidth(self.view.bounds) - 40,
                                                              height - STACK_SPACING)];
    stackView.spacing = STACK_SPACING;
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.distribution = UIStackViewDistributionFillProportionally;
    stackView.backgroundColor = [UIColor blueColor];
    
    for(UIView *view in self.noteViews){
        [view setBackgroundColor:[UIColor clearColor]];
        [stackView addArrangedSubview:view];
    }
    [self.scrollView addSubview:stackView];
    
    [self.view addSubview: self.scrollView];
    
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Save to album

- (void)saveNoteAction{
    UIGraphicsBeginImageContextWithOptions(stackView.bounds.size, NO, [[UIScreen mainScreen] scale]);
    [stackView.layer renderInContext:UIGraphicsGetCurrentContext()];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
