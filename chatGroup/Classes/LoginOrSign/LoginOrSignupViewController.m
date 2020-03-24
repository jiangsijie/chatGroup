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

@end

@implementation LoginOrSignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
                  //[self performSegueWithIdentifier:@"fromLoginToProducts" sender:nil];
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
                //[self performSegueWithIdentifier:@"fromSignUpToProducts" sender:nil];
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
