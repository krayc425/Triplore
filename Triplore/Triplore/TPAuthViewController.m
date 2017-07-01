//
//  TPAuthViewController.m
//  Triplore
//
//  Created by Sorumi on 17/6/27.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPAuthViewController.h"
#import "TPTextField.h"
#import "SVProgressHUD.h"
#import "TPAuthHelper.h"
#import "Utilities.h"

typedef NS_ENUM(NSInteger, TPAuthMode){
    TPAuthLogin         = 1,
    TPAuthRegister      = 2,
};

@interface TPAuthViewController () <UITextFieldDelegate>

@property (nonatomic) TPAuthMode mode;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet TPTextField *usernameTextField;
@property (weak, nonatomic) IBOutlet TPTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *authButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetButton;
@property (weak, nonatomic) IBOutlet UIView *separateLine;

@end

@implementation TPAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mode = TPAuthLogin;
    
    // title

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Triplore"];
    
    float spacing = 1.0f;
    [attributedString addAttribute:NSKernAttributeName
                             value:@(spacing)
                             range:NSMakeRange(0, [attributedString length])];
    
    self.titleLabel.attributedText = attributedString;
    
    // text fild
    UIImageView *usernameImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AUTH_MAIL"]];
    usernameImage.contentMode = UIViewContentModeScaleAspectFit;
    self.usernameTextField.rightView = usernameImage;

    UIImageView *passwordImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AUTH_LOCK"]];
    passwordImage.contentMode = UIViewContentModeScaleAspectFit;
    self.passwordTextField.rightView = passwordImage;


    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    self.authButton.layer.cornerRadius = 3.0;
}

- (void)setMode:(TPAuthMode)mode {
    _mode = mode;
    switch (mode) {
        case TPAuthLogin:
        {
            [self.authButton setTitle:@"登 录" forState:UIControlStateNormal];
            self.loginButton.hidden = YES;
            self.registerButton.hidden = NO;
            self.forgetButton.hidden = NO;
            self.separateLine.hidden = NO;
        }
            break;
        case TPAuthRegister:
        {
            [self.authButton setTitle:@"注 册" forState:UIControlStateNormal];
            self.loginButton.hidden = NO;
            self.registerButton.hidden = YES;
            self.forgetButton.hidden = YES;
            self.separateLine.hidden = YES;
        }
            break;
        default:
            break;
    }
}

#pragma mark - Text field

- (void)animateTextField:(UITextField *)textField up:(BOOL)up {
    const int movementDistance = 80;
    const float movementDuration = 0.3f;
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self animateTextField:textField up: YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self animateTextField:textField up: NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.usernameTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField) {
        [textField resignFirstResponder];
        [self authButtonDidTap:nil];
    }
    return YES;
}

#pragma mark - Action

- (IBAction)cancelButtonDidTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)authButtonDidTap:(id)sender {
    
    NSString *email = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if ([email isEqualToString: @""]) {
        [self showInfoHubWithText:@"请输入邮箱"];
        return;
    }
    
    if ([password isEqualToString: @""]) {
        [self showInfoHubWithText:@"请输入密码"];
        return;
    }

    switch (self.mode) {
        case TPAuthLogin:
            [self loginRequest];
            break;
        case TPAuthRegister:
            [self registerRequest];
            break;
        default:
            break;
    }

}

- (IBAction)registerButtonDidTap:(id)sender {
    self.mode = TPAuthRegister;
}

- (IBAction)loginButtonDidTap:(id)sender {
    self.mode = TPAuthLogin;
}

- (IBAction)forgetButtonDidTap:(id)sender {
    NSString *email = self.usernameTextField.text;
    
    if ([email isEqualToString:@""]) {
        [self showInfoHubWithText:@"请输入邮箱找回密码"];
        return;
    }
    
    [TPAuthHelper resetPasswordWithUsername:email
                                  withBlock:^(BOOL succeed, NSError * _Nullable error) {
                                      if (succeed) {
                                          [self showSuccessHubWithText:@"密码重置邮件已发送至您的邮箱"];
                                      } else {
                                          NSString *reason = [Utilities getErrorCodeDescription:error.code];
                                          [self showErrorHubWithText:[NSString stringWithFormat:@"重置密码失败\n%@", reason]];
                                      }
                                  }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginRequest {
    [SVProgressHUD showWithStatus:@"登录中"];
    [TPAuthHelper loginWithUsername:self.usernameTextField.text
                        andPassword:self.passwordTextField.text
                          withBlock:^(AVUser * _Nonnull user, NSError * _Nullable error) {
                              [SVProgressHUD dismiss];
                              if (user) {
                                  [self showSuccessHubWithText:@"登录成功"];
                                  
                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"change_user"
                                                                                      object:nil];
                              } else {
                                  NSString *reason = [Utilities getErrorCodeDescription:error.code];
                                  [self showErrorHubWithText:[NSString stringWithFormat:@"登录失败\n%@", reason]];
                              }
                          }];
}

- (void)registerRequest {
    [SVProgressHUD show];
    [TPAuthHelper signUpWithUsername:self.usernameTextField.text
                         andPassword:self.passwordTextField.text
                           withBlock:^(BOOL succeed, NSError * _Nullable error) {
                               [SVProgressHUD dismiss];
                               if(succeed){
                                   [self showSuccessHubWithText:@"注册成功"];
                                   
                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"change_user"
                                                                                    object:nil];
                                   
                               }else{
                                   NSString *reason = [Utilities getErrorCodeDescription:error.code];
                                   [self showErrorHubWithText:[NSString stringWithFormat:@"注册失败\n%@", reason]];
                               }
                           }];
}


- (void)showInfoHubWithText:(NSString *)text {
    [SVProgressHUD showInfoWithStatus:text];
    [SVProgressHUD dismissWithDelay:2];
}

- (void)showSuccessHubWithText:(NSString *)text {
    [SVProgressHUD showSuccessWithStatus:text];
    [SVProgressHUD dismissWithDelay:2 completion:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)showErrorHubWithText:(NSString *)text {
    [SVProgressHUD showErrorWithStatus:text];
    [SVProgressHUD dismissWithDelay:2];
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
