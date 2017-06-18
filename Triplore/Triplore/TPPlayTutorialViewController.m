//
//  TPPlayTutorialViewController.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/18.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPPlayTutorialViewController.h"
#import "Utilities.h"

@interface TPPlayTutorialViewController ()

@property (nonnull, nonatomic) IBOutlet UIButton *okButton;
@property (nonnull, nonatomic) IBOutlet UIView *containerView;
@property (nonnull, nonatomic) IBOutletCollection(UILabel) NSArray *labels;

@end

@implementation TPPlayTutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view from its nib.
    [self.okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.okButton setTitle:@"好 的" forState:UIControlStateNormal];
    [self.okButton setBackgroundColor:[Utilities getColor]];
    [self.okButton addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
    [self.okButton.layer setCornerRadius:20.0];
    
    self.containerView.layer.cornerRadius = 10.0;
    self.containerView.layer.borderColor = [Utilities getColor].CGColor;
    self.containerView.layer.borderWidth = 2.0;
    
    for (UILabel *label in self.labels) {
        [label setTextColor:[UIColor darkGrayColor]];
        [label setNumberOfLines:2];
        [label setAdjustsFontSizeToFitWidth:YES];
        [label sizeToFit];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)okAction{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
