//
//  ConversationViewController.m
//  chatGroup
//
//  Created by sijie.jiang on 2020/3/25.
//  Copyright © 2020 sijie.jiang. All rights reserved.
//

#import "ConversationViewController.h"

@interface ConversationViewController ()
@property (strong, nonatomic) AVIMClient *client;
@property (strong, nonatomic) AVUser *currentUser;
@end

@implementation ConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentUser = [AVUser currentUser];
    self.client = [[AVIMClient alloc] initWithUser:self.currentUser];
    
    //todo:  聊天
//    [self.client openWithCallback:^(BOOL succeeded, NSError * _Nullable error) {
//        if(!succeeded) {
//            return;
//        }
//        NSString *name = @"123";
//        [self.client createConversationWithName:name clientIds:@[self.talkToUser.objectId] attributes:nil options:AVIMConversationOptionUnique
//                               callback:^(AVIMConversation *conversation, NSError *error) {
//            AVIMTextMessage *message = [AVIMTextMessage messageWithText:@"耗子，起床！" attributes:nil];
//            [conversation sendMessage:message callback:^(BOOL succeeded, NSError *error) {
//              if (succeeded) {
//                NSLog(@"发送成功！");
//              }
//            }];
//        }];
//    }];
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
