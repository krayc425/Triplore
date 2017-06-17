//
//  TPAboutViewController.m
//  Triplore
//
//  Created by Sorumi on 17/6/17.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPMeAboutViewController.h"
#import "TPSliderTab.h"
#import "TPMeAboutCollectionViewCell.h"
#import "TPPersonHelper.h"
#import "TPPersonModel.h"
#import "Utilities.h"

@interface TPMeAboutViewController () <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, TPSliderTabDelegate>

@property (weak, nonatomic) IBOutlet TPSliderTab *sliderTab;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *people;

@end

@implementation TPMeAboutViewController

static NSString * const reuseIdentifier = @"TPMeAboutCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // navigation
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title = @"关于我们";

    // tab bar
    UIEdgeInsets adjustForTabbarInsets = self.collectionView.contentInset;
    adjustForTabbarInsets.bottom += CGRectGetHeight(self.tabBarController.tabBar.frame);
    self.collectionView.contentInset = adjustForTabbarInsets;
    
    // sider tab
    self.sliderTab.color = [UIColor whiteColor];
    self.sliderTab.delegate = self;
    
    // collection view
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    UINib *nib = [UINib nibWithNibName:@"TPMeAboutCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
    
    // model
    [TPPersonHelper fetchAllPeopleWithBlock:^(NSArray<TPPersonModel *> * _Nonnull people, NSError * _Nullable error) {
        self.people = people;
        
        NSMutableArray *names = [[NSMutableArray alloc] init];
        for (TPPersonModel* person in people) {
            [names addObject:person.name];
        }
        
        [self.collectionView reloadData];
        self.sliderTab.strings = names;
    }];
    
}

#pragma mark - <TPSliderTabDelegate>

- (void)indexDidSelect:(NSUInteger)selectedIndex {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat width = CGRectGetWidth(self.view.frame);
    NSUInteger index = (NSUInteger) round(offsetX / width);
    [self.sliderTab setSelectedIndex:index];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.people.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TPMeAboutCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.person = self.people[indexPath.row];
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((CGRectGetWidth(self.collectionView.frame) - 20), (CGRectGetHeight(self.collectionView.frame) - CGRectGetHeight(self.tabBarController.tabBar.frame) - 20));
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
