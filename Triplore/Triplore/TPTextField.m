//
//  TPTextField.m
//  Triplore
//
//  Created by Sorumi on 17/6/28.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPTextField.h"

@implementation TPTextField

- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.borderStyle = UITextBorderStyleNone;
    self.layer.cornerRadius = 3;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.masksToBounds = YES;
//    self.backgroundColor = kWhiteColor;
//    self.textColor = kPrimaryColor;
    self.tintColor = TPColor;
    
    
    self.rightViewMode = UITextFieldViewModeAlways;

}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 14, 14);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 14, 14);
}

- (CGRect) rightViewRectForBounds:(CGRect)bounds {
    CGRect textRect = [super rightViewRectForBounds:bounds];
    textRect.origin.x -= 14;
    return textRect;
}

@end
