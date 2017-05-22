//
//  TPTabBarViewController.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/22.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPTabBarViewController.h"
#import "ViewController.h"

@interface TPTabBarViewController ()

@end

@implementation TPTabBarViewController

- (void)viewDidLoad {
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Triplore";
    
    ViewController *vc = [[ViewController alloc] init];
    vc.title = @"精选";
    
    [self addChildViewController:vc];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
