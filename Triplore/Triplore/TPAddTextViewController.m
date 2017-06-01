//
//  TPAddTextViewController.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/30.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPAddTextViewController.h"
#import "Utilities.h"

@interface TPAddTextViewController () <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *okButton;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) IBOutlet UITextView *noteText;

@end

@implementation TPAddTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f]];
    
    //全局返回
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backAction)];
    [self.view addGestureRecognizer:tapGesture];
    
    //笔记 Text
    [self.noteText.layer setCornerRadius:10.0f];
    [self.noteText setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:16.0]];
    [self.noteText setContentMode:UIViewContentModeTopLeft];
    [self.noteText setTextAlignment:NSTextAlignmentLeft];
    self.noteText.delegate = self;
    
    //完成按钮
    [self.okButton.layer setCornerRadius:CGRectGetHeight(self.okButton.frame) / 2];
    [self.okButton setBackgroundColor:[UIColor lightGrayColor]];
    [self.okButton setUserInteractionEnabled:NO];
    [self.okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.okButton.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:16.0]];
    [self.okButton setTitle:@"添 加" forState:UIControlStateNormal];
    [self.okButton addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [self.noteText becomeFirstResponder];
}

- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneAction{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 375, 20)];
    [label setText:self.noteText.text];
    [label setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:16.0]];
    [label setNumberOfLines:100];
    [label sizeToFit];
    
    [self.addNoteViewDelegate addNoteView:label];

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextView Delegate

- (void)textViewDidChange:(UITextView *)textView{
    if([textView.text isEqualToString:@""]){
        [self.okButton setBackgroundColor:[UIColor lightGrayColor]];
        [self.okButton setUserInteractionEnabled:NO];
    }else{
        [self.okButton setBackgroundColor:[Utilities getColor]];
        [self.okButton setUserInteractionEnabled:YES];
    }
}

@end
