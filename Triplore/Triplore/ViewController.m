//
//  ViewController.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/21.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "ViewController.h"
#import "PlayViewController.h"
#import "ActivityIndicatorView.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)NSMutableArray* dataSourceArrayFirst;
@property(nonatomic,strong)NSMutableArray* dataSourceArraySecond;
@property(nonatomic,strong)NSMutableArray* dataSourceArrayThird;
@property(nonatomic,strong)PlayViewController *playViewController;
@property(nonatomic,strong) ActivityIndicatorView *activityWheel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataSourceArrayFirst = [[NSMutableArray alloc] initWithCapacity:1];
    self.dataSourceArraySecond = [[NSMutableArray alloc] initWithCapacity:3];
    self.dataSourceArrayThird = [[NSMutableArray alloc] initWithCapacity:3];
    
    
    [self createTableView];
    [self requestUrl];
    [self showLoadingView];
    
}
-(void)showLoadingView
{
    self.tableView.hidden = YES;
    if(self.activityWheel==nil)
    {
        ActivityIndicatorView *wheel = [[ActivityIndicatorView alloc] initWithFrame: CGRectMake(0, 0, 15, 15)];
        wheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        self.activityWheel = wheel;
        self.activityWheel.center = self.view.center;
    }
    [self.activityWheel startAnimating];
    [self.view addSubview:self.activityWheel];
}
-(void)removeLoadingView
{
    self.tableView.hidden = NO;
    [self.activityWheel stopAnimating];
    if (self.activityWheel.superview) {
        [self.activityWheel removeFromSuperview];
    }
    self.activityWheel = nil;
}
-(void)createTableView
{
    if (self.tableView==nil)
    {
        UITableView* contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20)];
        contentTableView.backgroundColor = [UIColor whiteColor];
        contentTableView.pagingEnabled = NO;
        contentTableView.autoresizesSubviews = YES;
        contentTableView.alwaysBounceHorizontal = NO;
        contentTableView.showsHorizontalScrollIndicator = NO;
        contentTableView.showsVerticalScrollIndicator = NO;
        contentTableView.scrollsToTop = YES;
        contentTableView.dataSource = self;
        contentTableView.delegate = self;
        contentTableView.allowsSelection = NO;
        contentTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView  = contentTableView;
        [self.view addSubview:self.tableView];
    }
}
#pragma mark  UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 180;
    }
    else if (indexPath.row==1) {
        return 400;
    }
    else if (indexPath.row==2) {
        return 480;
    }
    else{
        return 0;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"CellIdentifier%i",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];;
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        if (indexPath.row==0) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180)];
            [imageView setTag:100];
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            [imageView addGestureRecognizer:singleTap];
            [cell.contentView addSubview:imageView];
        }
        if (indexPath.row==1) {
            CGFloat imagewidth = (self.view.frame.size.width-10*3)/2;
            CGFloat imageheight = imagewidth/480*360;
            
            UILabel *title = [[UILabel alloc] init];
            title.frame = CGRectMake(10, 0, self.view.frame.size.width, 30);
            title.font = [UIFont systemFontOfSize:14];
            title.textColor = [UIColor blackColor];
            [title setText:@"资讯"];
            title.tag = 500;
            [cell.contentView addSubview:title];
            
            UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, imagewidth, imageheight)];//左上
            [imageView1 setTag:200];
            imageView1.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            [imageView1 addGestureRecognizer:singleTap1];
            [cell.contentView addSubview:imageView1];
            
            UILabel *label1 = [[UILabel alloc] init];
            label1.frame = CGRectMake(imageView1.frame.origin.x, imageView1.frame.origin.y+imageView1.frame.size.height+10, imageView1.frame.size.width, 25);
            label1.font = [UIFont systemFontOfSize:13];
            label1.textColor = [UIColor blackColor];
            label1.tag = 201;
            [cell.contentView addSubview:label1];
            
            UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(10+imageView1.frame.size.width+10, 40, imagewidth, imageheight)];//右上
            [imageView2 setTag:210];
            imageView2.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            [imageView2 addGestureRecognizer:singleTap2];
            [cell.contentView addSubview:imageView2];
            
            UILabel *label2 = [[UILabel alloc] init];
            label2.frame = CGRectMake(imageView2.frame.origin.x, imageView2.frame.origin.y+imageView2.frame.size.height+10, imageView2.frame.size.width, 25);
            label2.font = [UIFont systemFontOfSize:13];
            label2.textColor = [UIColor blackColor];
            label2.tag = 211;
            [cell.contentView addSubview:label2];
            
            UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(10, label1.frame.origin.y+label1.frame.size.height+10, imagewidth, imageheight)];//左下
            [imageView3 setTag:220];
            imageView3.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            [imageView3 addGestureRecognizer:singleTap3];
            [cell.contentView addSubview:imageView3];
            
            UILabel *label3 = [[UILabel alloc] init];
            label3.frame = CGRectMake(imageView3.frame.origin.x, imageView3.frame.origin.y+imageView3.frame.size.height+10, imageView3.frame.size.width, 25);
            label3.font = [UIFont systemFontOfSize:13];
            label3.textColor = [UIColor blackColor];
            label3.tag = 221;
            [cell.contentView addSubview:label3];
            
            UIImageView *imageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(10+imageView1.frame.size.width+10, label1.frame.origin.y+label1.frame.size.height+10, imagewidth, imageheight)];//右下
            [imageView4 setTag:230];
            imageView4.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            [imageView4 addGestureRecognizer:singleTap4];
            [cell.contentView addSubview:imageView4];
            
            UILabel *label4 = [[UILabel alloc] init];
            label4.frame = CGRectMake(imageView4.frame.origin.x, imageView4.frame.origin.y+imageView4.frame.size.height+10, imageView4.frame.size.width, 25);
            label4.font = [UIFont systemFontOfSize:13];
            label4.textColor = [UIColor blackColor];
            label4.tag = 231;
            [cell.contentView addSubview:label4];
            
        }
        if (indexPath.row==2) {
            CGFloat imagewidth = (self.view.frame.size.width-40*3)/2;
            CGFloat imageheight = imagewidth/260*360;
            
            
            UILabel *title = [[UILabel alloc] init];
            title.frame = CGRectMake(10, 0, self.view.frame.size.width, 30);
            title.font = [UIFont systemFontOfSize:14];
            title.textColor = [UIColor blackColor];
            title.tag = 500;
            [title setText:@"电视剧"];
            [cell.contentView addSubview:title];
            
            UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(40, 40, imagewidth, imageheight)];//左上
            [imageView1 setTag:300];
            imageView1.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            [imageView1 addGestureRecognizer:singleTap1];
            [cell.contentView addSubview:imageView1];
            
            UILabel *label1 = [[UILabel alloc] init];
            label1.frame = CGRectMake(imageView1.frame.origin.x, imageView1.frame.origin.y+imageView1.frame.size.height+10, imageView1.frame.size.width, 25);
            label1.font = [UIFont systemFontOfSize:13];
            label1.textColor = [UIColor blackColor];
            label1.tag = 301;
            [cell.contentView addSubview:label1];
            
            UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(40+imageView1.frame.size.width+40, 40, imagewidth, imageheight)];//右上
            [imageView2 setTag:310];
            imageView2.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            [imageView2 addGestureRecognizer:singleTap2];
            [cell.contentView addSubview:imageView2];
            
            UILabel *label2 = [[UILabel alloc] init];
            label2.frame = CGRectMake(imageView2.frame.origin.x, imageView2.frame.origin.y+imageView2.frame.size.height+10, imageView2.frame.size.width, 25);
            label2.font = [UIFont systemFontOfSize:13];
            label2.textColor = [UIColor blackColor];
            label2.tag = 311;
            [cell.contentView addSubview:label2];
            
            UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(40, label1.frame.origin.y+label1.frame.size.height+10, imagewidth, imageheight)];//左下
            [imageView3 setTag:320];
            imageView3.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            [imageView3 addGestureRecognizer:singleTap3];
            [cell.contentView addSubview:imageView3];
            
            UILabel *label3 = [[UILabel alloc] init];
            label3.frame = CGRectMake(imageView3.frame.origin.x, imageView3.frame.origin.y+imageView3.frame.size.height+10, imageView3.frame.size.width, 25);
            label3.font = [UIFont systemFontOfSize:13];
            label3.textColor = [UIColor blackColor];
            label3.tag = 321;
            [cell.contentView addSubview:label3];
            
            UIImageView *imageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(40+imageView1.frame.size.width+40, label1.frame.origin.y+label1.frame.size.height+10, imagewidth, imageheight)];//右下
            [imageView4 setTag:330];
            imageView4.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            [imageView4 addGestureRecognizer:singleTap4];
            [cell.contentView addSubview:imageView4];
            
            UILabel *label4 = [[UILabel alloc] init];
            label4.frame = CGRectMake(imageView4.frame.origin.x, imageView4.frame.origin.y+imageView4.frame.size.height+10, imageView4.frame.size.width, 25);
            label4.font = [UIFont systemFontOfSize:13];
            label4.textColor = [UIColor blackColor];
            label4.tag = 331;
            [cell.contentView addSubview:label4];
            
        }
    }
    if(indexPath.row==0)
    {
        if (self.dataSourceArrayFirst.count>0) {
            NSDictionary *dic = [self.dataSourceArrayFirst objectAtIndex:0];
            NSString *imgurl =[dic valueForKey:@"img"];
            UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:100];
            if(imageView!=nil&&imgurl!=nil&&imageView.image==nil&&imageView.image==nil)
            {
                NSString *newurl = [NSString stringWithFormat:@"%@%@",imgurl,@"?sign=iqiyi"];
                NSURL *imageUrl = [NSURL URLWithString:newurl];
                
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
                imageView.image = image;
            }
        }
    }
    if(indexPath.row==1)
    {
        if (self.dataSourceArraySecond.count>3) {
            int flag = 200;
            for (int i=0;i<self.dataSourceArraySecond.count;i++) {
                NSDictionary *dic = [self.dataSourceArraySecond objectAtIndex:i];
                NSString *imgurl =[dic valueForKey:@"img"];
                UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:flag+i*10];
                if(imageView!=nil&&imgurl!=nil&&imageView.image==nil)
                {
                    imgurl = [imgurl stringByReplacingOccurrencesOfString:@".jpg" withString:@"_480_360.jpg?sign=iqiyi"];
                    NSURL *imageUrl = [NSURL URLWithString:imgurl];
                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
                    imageView.image = image;
                }
                
                NSString *title =[dic valueForKey:@"title"];
                UILabel *label = (UILabel *)[cell.contentView viewWithTag:flag+i*10+1];
                if(label!=nil&&title!=nil)
                {
                    [label setText:title];
                }
            }
        }
    }
    if(indexPath.row==2)
    {
        if (self.dataSourceArrayThird.count>3) {
            int flag = 300;
            for (int i=0;i<self.dataSourceArrayThird.count;i++) {
                NSDictionary *dic = [self.dataSourceArrayThird objectAtIndex:i];
                NSString *imgurl =[dic valueForKey:@"img"];
                UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:flag+i*10];
                if(imageView!=nil&&imgurl!=nil&&imageView.image==nil)
                {
                    imgurl = [imgurl stringByReplacingOccurrencesOfString:@".jpg" withString:@"_260_360.jpg?sign=iqiyi"];
                    NSURL *imageUrl = [NSURL URLWithString:imgurl];
                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
                    imageView.image = image;
                }
                
                NSString *title =[dic valueForKey:@"title"];
                UILabel *label = (UILabel *)[cell.contentView viewWithTag:flag+i*10+1];
                if(label!=nil&&title!=nil)
                {
                    [label setText:title];
                }
            }
        }
    }
    return cell;
}
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.dataSourceArrayFirst.count<1
        ||self.dataSourceArraySecond.count<4
        ||self.dataSourceArrayThird.count<4) {
        return;
    }
    UIImageView *eventImageView = (UIImageView *)gestureRecognizer.view;
    
    if (self.playViewController!=nil) {
        self.playViewController = nil;
    }
    self.playViewController = [[PlayViewController alloc] init];
    switch (eventImageView.tag) {
        case 100:
            self.playViewController.playDetail = [self.dataSourceArrayFirst objectAtIndex:0];
            break;
        case 200:
            self.playViewController.playDetail = [self.dataSourceArraySecond objectAtIndex:0];
            break;
        case 210:
            self.playViewController.playDetail = [self.dataSourceArraySecond objectAtIndex:1];
            break;
        case 220:
            self.playViewController.playDetail = [self.dataSourceArraySecond objectAtIndex:2];
            break;
        case 230:
            self.playViewController.playDetail = [self.dataSourceArraySecond objectAtIndex:3];
            break;
        case 300:
            self.playViewController.playDetail = [self.dataSourceArrayThird objectAtIndex:0];
            break;
        case 310:
            self.playViewController.playDetail = [self.dataSourceArrayThird objectAtIndex:1];
            break;
        case 320:
            self.playViewController.playDetail = [self.dataSourceArrayThird objectAtIndex:2];
            break;
        case 330:
            self.playViewController.playDetail = [self.dataSourceArrayThird objectAtIndex:3];
            break;
            
            
        default:
            break;
    }
    
    //    NSLog()
    [self addChildViewController:self.playViewController];
    [self.playViewController.view setFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.playViewController.view];
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf.playViewController.view setFrame:CGRectMake(0, 0, weakSelf.view.frame.size.width, weakSelf.view.frame.size.height)];
    } completion:^(BOOL finished) {
        
    }];
    
}
#pragma network request

-(void)requestUrl
{
    NSURL *url = [NSURL URLWithString:@"http://iface.qiyi.com/openapi/batch/recommend?app_k=f0f6c3ee5709615310c0f053dc9c65f2&app_v=8.4&app_t=0&platform_id=12&dev_os=10.3.1&dev_ua=iPhone9,3&dev_hw=%7B%22cpu%22%3A0%2C%22gpu%22%3A%22%22%2C%22mem%22%3A%2250.4MB%22%7D&net_sts=1&scrn_sts=1&scrn_res=1334*750&scrn_dpi=153600&qyid=87390BD2-DACE-497B-9CD4-2FD14354B2A4&secure_v=1&secure_p=iPhone&core=1&req_sn=1493946331320&req_times=1"];
    
    
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError)
        {
            [self performSelectorOnMainThread:@selector(requestFailed) withObject:nil waitUntilDone:NO];
        }
        else
        {
            NSDictionary *tmpDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray *data = [tmpDic objectForKey:@"data"];
            NSNumber* resultCode = [tmpDic valueForKey:@"code"];
            if (resultCode.integerValue == 0) {
                [self performSelectorOnMainThread:@selector(showDataMessage:) withObject:data waitUntilDone:NO];
            }
        }
    }];
    
}
- (void)requestFailed
{
    [self removeLoadingView];
    self.tableView.hidden = YES;
    UILabel *copyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    [copyLabel setText:@"网络请求失败"];
    [copyLabel setTextColor:[UIColor lightGrayColor]];
    copyLabel.center = self.view.center;
    copyLabel.font = [UIFont systemFontOfSize:14];
    copyLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:copyLabel];
}
- (void)showDataMessage:(NSArray*)resultDic
{
    [self removeLoadingView];
    //仅取部分数据为例
    for (NSDictionary *dic in resultDic) {
        NSString *name = [dic valueForKey:@"title"];
        NSArray *videoList = [dic valueForKey:@"video_list"];
        if ([name isEqualToString:@"轮播图"] && videoList.count>0)
        {
            [self.dataSourceArrayFirst addObject:[videoList objectAtIndex:0]];
        }
        else if ([name isEqualToString:@"资讯"] && videoList.count>3)
        {
            [self.dataSourceArraySecond addObject:[videoList objectAtIndex:0]];
            [self.dataSourceArraySecond addObject:[videoList objectAtIndex:1]];
            [self.dataSourceArraySecond addObject:[videoList objectAtIndex:2]];
            [self.dataSourceArraySecond addObject:[videoList objectAtIndex:3]];
        }
        else if ([name isEqualToString:@"电视剧"] && videoList.count>3)
        {
            [self.dataSourceArrayThird addObject:[videoList objectAtIndex:0]];
            [self.dataSourceArrayThird addObject:[videoList objectAtIndex:1]];
            [self.dataSourceArrayThird addObject:[videoList objectAtIndex:2]];
            [self.dataSourceArrayThird addObject:[videoList objectAtIndex:3]];
        }
    }
    
    [self.tableView reloadData];
}

@end
