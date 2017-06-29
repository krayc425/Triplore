//
//  TPTabBarViewController.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/22.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPTabBarViewController.h"
#import "TPSelectionTableViewController.h"

#import "TPSiteTableViewController.h"
#import "TPNotePageViewController.h"
#import "TPMeTableViewController.h"
#import "TPPlayViewController.h"
#import "ABCIntroView.h"

@interface TPTabBarViewController () <ABCIntroViewDelegate> {
    BOOL shouldAutorotate;
}

@property (nonatomic, nonnull) ABCIntroView *introView;

@end

@implementation TPTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //TabBar
    self.tabBarController.tabBar.delegate = self;
    self.tabBar.tintColor = TPColor;
    
    //精选
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:@"精选" image:[UIImage imageNamed:@"TAB_HOME"] selectedImage:[UIImage imageNamed:@"TAB_HOME"]];
    TPSelectionTableViewController *selectionVC = [[TPSelectionTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    selectionVC.tabBarItem = item1;
    UINavigationController *naviVC1 = [[UINavigationController alloc] initWithRootViewController:selectionVC];
    
    //地点
    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:@"地点" image:[UIImage imageNamed:@"TAB_SITE"] selectedImage:[UIImage imageNamed:@"TAB_SITE"]];
    TPSiteTableViewController *siteVC = [[TPSiteTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    siteVC.tabBarItem = item2;
    UINavigationController *naviVC2 = [[UINavigationController alloc] initWithRootViewController:siteVC];
    
    //笔记
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    TPNotePageViewController *noteVC = [[TPNotePageViewController alloc] initWithCollectionViewLayout:layout];
    TPNotePageViewController *noteVC = [[TPNotePageViewController alloc] init];
    UITabBarItem *item3 = [[UITabBarItem alloc] initWithTitle:@"笔记" image:[UIImage imageNamed:@"TAB_BOOK"] selectedImage:[UIImage imageNamed:@"TAB_BOOK"]];
    noteVC.tabBarItem = item3;
    UINavigationController *naviVC3 = [[UINavigationController alloc] initWithRootViewController:noteVC];
    
    //我
    TPMeTableViewController *meVC = [[TPMeTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UITabBarItem *item4 = [[UITabBarItem alloc] initWithTitle:@"我" image:[UIImage imageNamed:@"TAB_PERSON"] selectedImage:[UIImage imageNamed:@"TAB_PERSON"]];
    meVC.tabBarItem = item4;
    UINavigationController *naviVC4 = [[UINavigationController alloc] initWithRootViewController:meVC];
    
    [self addChildViewController:naviVC1];
    [self addChildViewController:naviVC2];
    [self addChildViewController:naviVC3];
    [self addChildViewController:naviVC4];
    
    for(UINavigationController *naviVC in self.childViewControllers) {
        naviVC.navigationBar.translucent = NO;
        naviVC.navigationBar.opaque = YES;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"intro_screen_viewed"]) {
        self.introView = [[ABCIntroView alloc] initWithFrame:self.view.frame];
        self.introView.delegate = self;
        self.introView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.introView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    //显式调用子 vc 的 viewwillappear
    [self.selectedViewController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    //显式调用子 vc 的 viewdidappear
    [self.selectedViewController viewDidAppear:animated];
}

#pragma mark - BarButton Pressed

- (void)backBarButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITabBarController Delegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    switch (self.selectedIndex) {
        case 0:
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            break;
        default:
            break;
    }
}

#pragma mark - Rotation

- (BOOL)shouldAutorotate {
    UINavigationController *nav = self.selectedViewController;
    UIViewController *vc = nav.topViewController;
    if ([vc isKindOfClass:[TPPlayViewController class]] &&
        [vc respondsToSelector:@selector(shouldAutorotate)]) {
        return [vc shouldAutorotate];
    }
    
    return NO;
}

// 支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UINavigationController *nav = self.selectedViewController;
    UIViewController *vc = nav.topViewController;
    if ([vc isKindOfClass:[TPPlayViewController class]] &&
        [vc respondsToSelector:@selector(supportedInterfaceOrientations)]) {
        return [vc supportedInterfaceOrientations];
    }
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - ABCIntroViewDelegate Methods

- (void)onDoneButtonPressed{
    //    Uncomment so that the IntroView does not show after the user clicks "DONE"
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"YES"forKey:@"intro_screen_viewed"];
    [defaults synchronize];
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.introView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.introView removeFromSuperview];
    }];
}

@end
