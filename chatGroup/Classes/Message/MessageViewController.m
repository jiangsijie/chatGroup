//
//  MessageViewController.m
//  chatGroup
//
//  Created by sijie.jiang on 2020/3/24.
//  Copyright © 2020 sijie.jiang. All rights reserved.
//

#import "MessageViewController.h"
#import "Conversation.h"
#import "MessageTableViewCell.h"
#import "ConversationViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudIM/AVOSCloudIM.h>
extern NSMutableArray *gMessageList;
extern BOOL loginSuccessed;

@interface MessageViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *conversationList;
@property (strong, nonatomic) NSArray *userList;
@property (strong, nonatomic) AVUser *talkToUser;
@property (weak, nonatomic) IBOutlet UITableView *conversationListOfMessageTableView;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationSecond:) name:@"Second" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationSecond:) name:@"First" object:nil];
    [self initConversationList];
}

- (void) initConversationList {
    self.conversationList = [[NSMutableArray alloc] init];
    self.userList = [[NSArray alloc] init];
    AVQuery *query = [AVQuery queryWithClassName:@"_User"];
    [query selectKeys:@[@"objectId", @"username"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        for(NSInteger i=0,count=users.count; i<count; i++) {
            self.userList = users;
            AVUser *user = [users objectAtIndex:i];
            NSMutableArray *messageList = [[NSMutableArray alloc] init];
            
            for(NSInteger j=0,count1=gMessageList.count; j<count1; j++) {
                AVIMTypedMessage *message = [gMessageList objectAtIndex:j];
                NSString *from = message.attributes[@"from"];
                NSString *to = message.attributes[@"to"];
        
                if(((message.status == AVIMMessageStatusSent) && [user.objectId isEqualToString:to]) || (message.status == AVIMMessageStatusDelivered && [user.objectId isEqualToString:from])) {
                    [messageList addObject:message];
                }
           }
            if(messageList.count > 0) {
                Conversation *conversation = [[Conversation alloc] init];
                conversation.takeTo = user;
                conversation.messageList = [[NSMutableArray alloc] init];
                conversation.messageList = messageList;
                [self.conversationList addObject:conversation];
            }
        };
        
        [self refreshTable];
    }];
}

-(void)notificationSecond:(NSNotification *)notification{
    AVIMTypedMessage *message = [notification object];
    NSString *from = message.attributes[@"from"];
    NSString *to = message.attributes[@"to"];
    BOOL alreadyChatted = NO;
    for(NSInteger i=0,count=self.conversationList.count; i<count; i++) {
        Conversation *conversation = [self.conversationList objectAtIndex:i];
        NSString *objectId = conversation.takeTo.objectId;
        if(((message.status == AVIMMessageStatusSent) && [objectId isEqualToString:to]) || (message.status == AVIMMessageStatusDelivered && [objectId isEqualToString:from])) {
            [conversation.messageList addObject:message];
            alreadyChatted = YES;
        }
    }
    
    if(!alreadyChatted) {
        for(NSInteger i=0,count=self.userList.count; i<count; i++) {
            AVUser *user = [self.userList objectAtIndex:i];
            if(((message.status == AVIMMessageStatusSent) && [user.objectId isEqualToString:to]) || (message.status == AVIMMessageStatusDelivered && [user.objectId isEqualToString:from])) {
                Conversation *conversation = [[Conversation alloc] init];
                conversation.takeTo = user;
                conversation.messageList = [[NSMutableArray alloc] init];
                [conversation.messageList addObject:message];
                [self.conversationList addObject:conversation];
                alreadyChatted = YES;
            }
        }
        
    }
    [self refreshTable];
}

- (void) refreshTable {
    [self.conversationListOfMessageTableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"conversationOfMessageCell"];
    Conversation *conversation = [self.conversationList objectAtIndex:indexPath.row];
    cell.chatWithWhoLabel.text = conversation.takeTo.username;
    AVIMTypedMessage *message = [conversation.messageList lastObject];
    cell.latestMessageLabel.text = message.text;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.conversationList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(!loginSuccessed) {
        return;
    }
    Conversation *conversation = [self.conversationList objectAtIndex:indexPath.row];
    self.talkToUser = conversation.takeTo;
    self.hidesBottomBarWhenPushed = YES;
    [self performSegueWithIdentifier:@"fromMessageTabToConversationPageSegue" sender:self];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ConversationViewController *destination = segue.destinationViewController;
    destination.talkToUser = self.talkToUser;
}

@end
