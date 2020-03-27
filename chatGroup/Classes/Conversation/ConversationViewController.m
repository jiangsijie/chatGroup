//
//  ConversationViewController.m
//  chatGroup
//
//  Created by sijie.jiang on 2020/3/25.
//  Copyright © 2020 sijie.jiang. All rights reserved.
//

#import "ConversationViewController.h"
#import "ConversationTableViewCell.h"
@interface ConversationViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) AVIMClient *client;
@property (strong, nonatomic) AVUser *currentUser;
@property (weak, nonatomic) IBOutlet UITableView *conversationTableView;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (strong, nonatomic) NSMutableArray* conversationList;
@end

@implementation ConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.conversationList = [NSMutableArray array];
    self.currentUser = [AVUser currentUser];
    self.client = [[AVIMClient alloc] initWithUser:self.currentUser];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.title = self.talkToUser.username;
    self.conversationTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.conversationTableView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ConversationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"conversationCell"];
    cell.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    cell.textLabel.text = [self.conversationList objectAtIndex:indexPath.row];
//    cell.textLabel.backgroundColor = [UIColor whiteColor];
//    cell.textLabel.layer.cornerRadius = 8;
//    cell.textLabel.layer.masksToBounds = YES;
//    cell.textLabel.layer.borderWidth = 1;
//    cell.textLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.conversationList.count;
}
- (IBAction)sendBtnOnClick:(id)sender {
    [self.client openWithCallback:^(BOOL succeeded, NSError * _Nullable error) {
        if(!succeeded) {
            return;
        }
        if(!self.messageTextField.text) {
            return;
        }

        [self.client createConversationWithName:@"对话" clientIds:@[self.talkToUser.objectId] attributes:nil options:AVIMConversationOptionUnique
                               callback:^(AVIMConversation *conversation, NSError *error) {
            AVIMTextMessage *message = [AVIMTextMessage messageWithText:self.messageTextField.text attributes:nil];
            [conversation sendMessage:message callback:^(BOOL succeeded, NSError *error) {
              if (succeeded) {
                NSLog(@"发送成功！");
                  [self.conversationList addObject:self.messageTextField.text];
                  [self refreshData];
              }
            }];
        }];
    }];
}

/**
 *  刷新数据源
 */
- (void)refreshData {
    [self.conversationTableView reloadData];
}
- (IBAction)backBtnOnClick:(id)sender {
    
}
@end
