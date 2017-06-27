//
//  TPAuthViewController.m
//  Triplore
//
//  Created by Sorumi on 17/6/27.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPAuthViewController.h"


typedef NS_ENUM(NSInteger, TPAuthMode){
    TPAuthLogin         = 1,
    TPAuthRegister      = 2,
};

@interface TPAuthViewController () <UITextFieldDelegate>

@property (nonatomic) TPAuthMode mode;

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *authButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetButton;

@end

@implementation TPAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mode = TPAuthLogin;
    
    self.usernameTextField.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    self.usernameTextField.layer.cornerRadius = 3.0;
    self.passwordTextField.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    self.passwordTextField.layer.cornerRadius = 3.0;
    
    
    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    self.authButton.layer.cornerRadius = 3.0;
}

- (void)setMode:(TPAuthMode)mode {
    _mode = mode;
    switch (mode) {
        case TPAuthLogin:
            self.authButton.titleLabel.text = @"登 录";
            break;
        case TPAuthRegister:
            self.authButton.titleLabel.text = @"注 册";
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginRequest {
    
}

- (void) registerRequest {
    
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
