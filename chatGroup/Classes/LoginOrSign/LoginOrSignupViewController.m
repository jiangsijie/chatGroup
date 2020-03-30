//
//  LoginOrSignupViewController.m
//  chatGroup
//
//  Created by sijie.jiang on 2020/3/23.
//  Copyright © 2020 sijie.jiang. All rights reserved.
//

#import "LoginOrSignupViewController.h"
#import <AVOSCloud/AVOSCloud.h>

@interface LoginOrSignupViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *signupBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginOrSignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setStyle];
}

- (void)setStyle {
    self.signupBtn.layer.borderColor = UIColor.systemBlueColor.CGColor;
    self.signupBtn.layer.borderWidth = 1;
    self.signupBtn.layer.cornerRadius = 5;
    self.loginBtn.backgroundColor = UIColor.systemBlueColor;
    self.loginBtn.layer.borderColor = UIColor.systemBlueColor.CGColor;
    self.loginBtn.layer.borderWidth = 1;
    self.loginBtn.layer.cornerRadius = 5;
}
- (IBAction)loginBtnOnClick:(id)sender {
    NSString *username = self.userName.text;
    NSString *password = self.password.text;
      if (username && password) {
          [AVUser logInWithUsernameInBackground:username password:password block:^(AVUser *user, NSError *error) {
              if (error) {
                  NSLog(@"登录失败 %@", error);
              } else {
                  NSLog(@"登录成功");
                  [self performSegueWithIdentifier:@"goToMainPageSegue" sender:self];
              }
          }];
      }
}
- (IBAction)signupBtnOnClick:(id)sender {
    NSString *username = self.userName.text;
    NSString *password = self.password.text;
    if (username && password) {
        AVUser *user = [AVUser user];
        user.username = username;
        user.password = password;
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"注册成功");
            } else {
                NSLog(@"注册失败 %@", error);
            }
        }];
    }
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
