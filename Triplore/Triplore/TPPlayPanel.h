//
//  TPPlayPanel.h
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/30.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TPPlayPanelDelegate <NSObject>

@optional

- (void)didTapEditButton;

- (void)didTapScreenShotButton;

- (void)didTapSaveButton;

@end

@interface TPPlayPanel : UIView

@property (nonatomic, weak) id<TPPlayPanelDelegate> delegate;

@end
