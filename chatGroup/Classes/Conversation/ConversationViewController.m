//
//  ConversationViewController.m
//  chatGroup
//
//  Created by sijie.jiang on 2020/3/25.
//  Copyright © 2020 sijie.jiang. All rights reserved.
//

#import "ConversationViewController.h"
#import "ConversationTableViewCell.h"

extern NSMutableArray *gMessageList;
extern AVIMClient *gAVIMCient;
extern BOOL loginSuccessed;

@interface ConversationViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *conversationTableView;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (strong, nonatomic) NSMutableArray* conversationList;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@end

@implementation ConversationViewController

- (void) initConversationList {
    for(NSInteger i=0,count=gMessageList.count; i<count; i++) {
        AVIMTypedMessage *message = [gMessageList objectAtIndex:i];
        NSString *from = message.attributes[@"from"];
        NSString *to = message.attributes[@"to"];

        if((message.status == AVIMMessageStatusSent) && [self.talkToUser.objectId isEqualToString:to]) {
            [self.conversationList addObject:message];
        } else if(message.status == AVIMMessageStatusDelivered && [self.talkToUser.objectId isEqualToString:from]) {
            [self.conversationList addObject:message];
        }
    }
}

-(void)notificationFirst:(NSNotification *)notification{
    AVIMTypedMessage *message = [notification object];
    NSString *from = message.attributes[@"from"];
    NSString *to = message.attributes[@"to"];

    if(((message.status == AVIMMessageStatusSent) && [self.talkToUser.objectId isEqualToString:to]) || (message.status == AVIMMessageStatusDelivered && [self.talkToUser.objectId isEqualToString:from])) {
        [self.conversationList addObject:message];
        [self refreshData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.conversationList = [[NSMutableArray alloc] init];

    [self initConversationList];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationFirst:) name:@"First" object:nil];


    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.title = self.talkToUser.username;
    self.conversationTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.conversationTableView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    self.sendBtn.layer.borderColor = [[UIColor lightGrayColor]CGColor];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ConversationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"conversationCell"];
    cell.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    AVIMTypedMessage *message = [self.conversationList objectAtIndex:indexPath.row];
    UILabel *label = [[UILabel alloc] init];
    if(message.status == AVIMMessageStatusSent) {
        label = cell.sendedMessageLabel;
    } else {
        label = cell.receivedMessageLabel;
    }
    label.text = message.text;
    label.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.conversationList.count;
}
- (IBAction)sendBtnOnClick:(id)sender {
    if(!loginSuccessed) {
        return;
    }
        if(!self.messageTextField.text) {
            return;
        }

        AVUser *currentUser = [AVUser currentUser];
        NSDictionary *attributes = @{
            @"from":currentUser.objectId,
            @"to": self.talkToUser.objectId
        };
        [gAVIMCient createConversationWithName:@"对话" clientIds:@[self.talkToUser.objectId] attributes:attributes options:AVIMConversationOptionUnique
                               callback:^(AVIMConversation *conversation, NSError *error) {
            AVIMTextMessage *message = [AVIMTextMessage messageWithText:self.messageTextField.text attributes:attributes];
            [conversation sendMessage:message callback:^(BOOL succeeded, NSError *error) {
              if (succeeded) {
                NSLog(@"发送成功！");
                  self.messageTextField.text = @"";
                  [gMessageList addObject:message];
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"Second" object:message];
                  [self.conversationList addObject:message];
                  [self refreshData];
              }
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
