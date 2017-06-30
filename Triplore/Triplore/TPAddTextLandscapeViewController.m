//
//  TPAddTextLandscapeViewController.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/30.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPAddTextLandscapeViewController.h"

@interface TPAddTextLandscapeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (strong, nonatomic) UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITextView *noteText;

@end

@implementation TPAddTextLandscapeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //完成按钮
    [self.okButton.layer setCornerRadius:CGRectGetWidth(self.okButton.frame) / 2];
    [self.okButton setBackgroundColor:[UIColor lightGrayColor]];
    [self.okButton setUserInteractionEnabled:NO];
    [self.okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.okButton.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:16.0]];
    [self.okButton.titleLabel setNumberOfLines:4];
    [self.okButton setTitle:@"添\n\n加" forState:UIControlStateNormal];
    
    [self.okButton addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doneAction{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 375, 20)];
    [label setText:self.noteText.text];
    [label setFont:[UIFont fontWithName:TPFont size:16.0]];
    [label setNumberOfLines:100];
    [label sizeToFit];

    [self.addNoteViewDelegate addNoteView:label];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
