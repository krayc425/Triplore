//
//  TPTabBarViewController.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/22.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPTabBarViewController.h"
#import "ViewController.h"
#import "Utilities.h"
#import "TPSiteTableViewController.h"

@interface TPTabBarViewController ()

@end

@implementation TPTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Triplore";
    self.navigationController.navigationBar.backgroundColor = [Utilities getColor];
    
    self.tabBar.tintColor = [Utilities getColor];
    
    //精选
    ViewController *vc = [[ViewController alloc] init];
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:@"精选" image:[UIImage imageNamed:@"TAB_HOME"] selectedImage:[UIImage imageNamed:@"TAB_HOME"]];
    vc.tabBarItem = item1;
    
    //地点
    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:@"地点" image:[UIImage imageNamed:@"TAB_SITE"] selectedImage:[UIImage imageNamed:@"TAB_SITE"]];
    TPSiteTableViewController *tpSiteTableViewController = [[TPSiteTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    tpSiteTableViewController.tabBarItem = item2;
    
    //书签？
    UIViewController *testVC3 = [[UIViewController alloc] init];
    UITabBarItem *item3 = [[UITabBarItem alloc] initWithTitle:@"书签" image:[UIImage imageNamed:@"TAB_BOOK"] selectedImage:[UIImage imageNamed:@"TAB_BOOK"]];
    testVC3.tabBarItem = item3;
    
    //我
    UIViewController *testVC4 = [[UIViewController alloc] init];
    UITabBarItem *item4 = [[UITabBarItem alloc] initWithTitle:@"我" image:[UIImage imageNamed:@"TAB_PERSON"] selectedImage:[UIImage imageNamed:@"TAB_PERSON"]];
    testVC4.tabBarItem = item4;
    
    [self addChildViewController:vc];
    [self addChildViewController:tpSiteTableViewController];
    [self addChildViewController:testVC3];
    [self addChildViewController:testVC4];
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
