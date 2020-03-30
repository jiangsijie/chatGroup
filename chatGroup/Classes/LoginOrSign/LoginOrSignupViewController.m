//
//  LoginOrSignupViewController.m
//  chatGroup
//
//  Created by sijie.jiang on 2020/3/23.
//  Copyright © 2020 sijie.jiang. All rights reserved.
//

#import "LoginOrSignupViewController.h"

@interface LoginOrSignupViewController ()<AVIMClientDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *signupBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginOrSignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setStyle];
    gMessageList = [NSMutableArray arrayWithCapacity:8];
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
                  
                  AVUser *currentUser = [AVUser currentUser];
                  gAVIMCient = [[AVIMClient alloc] initWithClientId:currentUser.objectId];
                  gAVIMCient.delegate = self;
                  [gAVIMCient openWithCallback:^(BOOL succeeded, NSError *error) {
                    if(!succeeded) {
                        loginSuccessed = NO;
                        NSLog(@"登录即时通讯服务失败 %@", error);
                        return;
                    }
                    loginSuccessed = YES;
                    NSLog(@"登录即时通讯服务成功");
                  }];
              }
          }];
      }
}

/*!
 当前用户被邀请加入对话的通知。
 @param conversation － 所属对话
 @param clientId - 邀请者的 ID
 */
-(void)conversation:(AVIMConversation *)conversation invitedByClientId:(NSString *)clientId{
    NSLog(@"%@", [NSString stringWithFormat:@"当前 clientId（Jerry）被 %@ 邀请，加入了对话",clientId]);
}

/*!
 接收到新消息（使用内置消息格式）。
 @param conversation － 所属对话
 @param message - 具体的消息
 */
- (void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"First" object:message];

    [gMessageList addObject:message];
}

- (void)imClientClosed:(nonnull AVIMClient *)imClient error:(NSError * _Nullable)error {
}


- (void)imClientPaused:(nonnull AVIMClient *)imClient {
}


- (void)imClientResumed:(nonnull AVIMClient *)imClient {
}


- (void)imClientResuming:(nonnull AVIMClient *)imClient {
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

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
}

//- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
//}

- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
}

- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
}

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
}

- (void)setNeedsFocusUpdate {
}

//- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
//    return YES;
//}

- (void)updateFocusIfNeeded {
}

@end
