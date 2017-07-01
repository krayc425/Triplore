//
//  TPPlayPanel.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/30.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPPlayPanel.h"

@interface TPPlayPanel()

@property (nonatomic, nonnull) UIButton *recordButton;
@property (nonatomic, nonnull) UIButton *editButton;
@property (nonatomic, nonnull) UIButton *screenshotButton;
@property (nonatomic, nonnull) UIButton *saveButton;

@end

@implementation TPPlayPanel

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        //4个按钮
        
        _recordButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [_recordButton setImage:[UIImage imageNamed:@"VIDEO_RECORD"] forState:UIControlStateNormal];
        [_recordButton addTarget:self action:@selector(recordAction) forControlEvents:UIControlEventTouchUpInside];
        _recordButton.tintColor = TPColor;
        
        _editButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [_editButton setImage:[UIImage imageNamed:@"NOTE_EDIT"] forState:UIControlStateNormal];
        [_editButton addTarget:self action:@selector(editNoteAction) forControlEvents:UIControlEventTouchUpInside];
        _editButton.tintColor = TPColor;
        
        _screenshotButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [_screenshotButton setImage:[UIImage imageNamed:@"NOTE_SCREENSHOT"] forState:UIControlStateNormal];
        [_screenshotButton addTarget:self action:@selector(screenShotAction) forControlEvents:UIControlEventTouchUpInside];
        _screenshotButton.tintColor = TPColor;
        
        _saveButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [_saveButton setImage:[UIImage imageNamed:@"NOTE_SAVE"] forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(saveNoteAction) forControlEvents:UIControlEventTouchUpInside];
        _saveButton.tintColor = TPColor;
        
        UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_recordButton, _editButton, _screenshotButton, _saveButton]];
        [stackView setFrame:CGRectMake(10, 0, CGRectGetWidth(frame) - 20, CGRectGetHeight(frame))];
        [stackView setAlignment:UIStackViewAlignmentCenter];
        [stackView setDistribution:UIStackViewDistributionEqualSpacing];
        
        [self addSubview:stackView];
        
        self.backgroundColor = TPBackgroundColor;
        self.layer.cornerRadius = 5.0;
        self.layer.shadowOffset = CGSizeMake(1, 1);
        self.layer.shadowRadius = 5.0;
        self.layer.shadowOpacity = 0.7;
    }
    return self;
}

- (void)editNoteAction{
    if([self.delegate respondsToSelector:@selector(didTapEditButton)]){
        [self.delegate didTapEditButton];
    }
}

- (void)screenShotAction{
    if([self.delegate respondsToSelector:@selector(didTapScreenShotButton)]){
        [self.delegate didTapScreenShotButton];
    }
}

- (void)saveNoteAction{
    if([self.delegate respondsToSelector:@selector(didTapSaveButton)]){
        [self.delegate didTapSaveButton];
    }
}

- (void)recordAction{
    if([self.delegate respondsToSelector:@selector(didTapRecordButton)]){
        [self.delegate didTapRecordButton];
    }
}

@end
