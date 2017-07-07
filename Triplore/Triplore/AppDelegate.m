//
//  AppDelegate.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/5/21.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "AppDelegate.h"
#import "QYPlayerController.h"
#import "TPTabBarViewController.h"
#import "Utilities.h"
#import "DBManager.h"
#import <AVOSCloud/AVOSCloud.h>
#import "AFNetworking.h"
#import "SVProgressHUD.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //AVOSCloud
    [AVOSCloud setApplicationId:AVCloudID clientKey:AVCloudKEY];
    
#if DEBUG
    [AVOSCloud setAllLogsEnabled:YES];  //Release 时设为 NO
#else
    [AVOSCloud setAllLogsEnabled:NO];  //Release 时设为 NO
#endif

    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    //必须调用
    [[QYPlayerController sharedInstance] initPlayer];
    
    //数据库
    [DBManager shareInstance];
    
    TPTabBarViewController *tabVC = [[TPTabBarViewController alloc] init];
    UIWindow *windows = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window = windows;
    self.window.rootViewController = tabVC;
    [self.window makeKeyAndVisible];
    
    if(TPFont == NULL || [TPFont isEqualToString:@""]){
        [Utilities setFontAtIndex:0];
    }
    
    // 检测网络
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变时调用
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                NSLog(@"没有网络");
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"网络失去连接" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alertVC addAction:cancelAction];
                [[self theTopviewControler] presentViewController:alertVC animated:YES completion:nil];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                NSLog(@"手机自带网络");
                
                if(![[NSUserDefaults standardUserDefaults] boolForKey:@"alert_for_wwan"]){
                
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您正在使用移动蜂窝网络" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *noAlertAction = [UIAlertAction actionWithTitle:@"不再提示" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"alert_for_wwan"];
                }];
                [alertVC addAction:noAlertAction];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alertVC addAction:cancelAction];
                [[self theTopviewControler] presentViewController:alertVC animated:YES completion:nil];
                }
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                NSLog(@"WIFI");
            }
                break;
        }
    }];
    
    //开始监控
    [manager startMonitoring];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (UIViewController *)theTopviewControler{
    UIViewController *rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;

    UIViewController *parent = rootVC;
    while ((parent = rootVC.presentedViewController) != nil ) {
        rootVC = parent;
    }
    while ([rootVC isKindOfClass:[UINavigationController class]]) {
        rootVC = [(UINavigationController *)rootVC topViewController];
    }
    return rootVC;
}

@end
