//
//  TPNotePageViewController.m
//  Triplore
//
//  Created by Sorumi on 17/6/29.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPNotePageViewController.h"
#import "TPNoteCollectionViewController.h"
#import "TPNoteServerCollectionViewController.h"
#import "TPNoteFavoriteCollectionViewController.h"
#import "TYTabButtonPagerController.h"

@interface TPNotePageViewController () <TYPagerControllerDataSource>

@property (nonatomic) TYPagerController *pagerController;

@end

@implementation TPNotePageViewController

static int controllerNum = 3;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
       
    self.navigationController.navigationBar.barTintColor = TPColor;
    self.navigationController.navigationBar.backgroundColor = TPColor;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"笔记";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    TYTabButtonPagerController *pagerController = [[TYTabButtonPagerController alloc] init];
    pagerController.dataSource = self;
    pagerController.adjustStatusBarHeight = YES;
    pagerController.cellWidth = 56;
    pagerController.cellSpacing = 8;
    pagerController.progressColor = TPColor;
    pagerController.normalTextColor = [UIColor lightGrayColor];
    pagerController.selectedTextColor = TPColor;
    pagerController.normalTextFont = [UIFont systemFontOfSize:14.0f];
    pagerController.selectedTextFont = [UIFont systemFontOfSize:14.0f];
    pagerController.collectionLayoutEdging = (SCREEN_WIDTH - 56 * controllerNum - 8 * (controllerNum - 1));
    pagerController.barStyle = TYPagerBarStyleProgressView;
    
    
    pagerController.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44);
    [self addChildViewController:pagerController];
    [self.view addSubview:pagerController.view];
    _pagerController = pagerController;
    
}

#pragma mark - TYPagerControllerDataSource

- (NSInteger)numberOfControllersInPagerController
{
    return 3;
}

- (NSString *)pagerController:(TYPagerController *)pagerController titleForIndex:(NSInteger)index
{
    return @[@"推荐", @"我的", @"收藏"][index];
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index
{
    if (index == 0) {
        UICollectionViewFlowLayout *layout1 = [[UICollectionViewFlowLayout alloc] init];
        TPNoteServerCollectionViewController *controller1 = [[TPNoteServerCollectionViewController alloc] initWithCollectionViewLayout:layout1];
        controller1.parentNavigationController = self.navigationController;
        controller1.title = @"推荐";
        return controller1;
        
    } else if (index == 1) {
        UICollectionViewFlowLayout *layout2 = [[UICollectionViewFlowLayout alloc] init];
        TPNoteCollectionViewController *controller2 = [[TPNoteCollectionViewController alloc] initWithCollectionViewLayout:layout2];
        controller2.title = @"我的";
        controller2.parentNavigationController = self.navigationController;
        return controller2;
        
    } else {
        UICollectionViewFlowLayout *layout3 = [[UICollectionViewFlowLayout alloc] init];
        TPNoteFavoriteCollectionViewController *controller3 = [[TPNoteFavoriteCollectionViewController alloc] initWithCollectionViewLayout:layout3];
        controller3.title = @"收藏";
        controller3.parentNavigationController = self.navigationController;
        return controller3;
    }
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
