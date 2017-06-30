//
//  TPConstant.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/18.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#ifndef TPConstant_h
#define TPConstant_h

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define TPColor [UIColor colorWithRed:0.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0]
#define TPBackgroundColor [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0]
#define TPGradientColor [UIColor colorWithRed:62/255. green:62/255. blue:62/255. alpha:0.5]
#define TPFont (NSString *)[[NSUserDefaults standardUserDefaults] valueForKey:@"font"]
#define TPAllFonts @[@{@"name" : @"PingFangSC-Regular",@"display_name" : @"苹方"}, @{@"name" : @"SourceHanSerifCN-Regular",@"display_name" : @"思源宋体"}]

#endif /* TPConstant_h */
