//
//  createChatGroupViewController.m
//  chatGroup
//
//  Created by Tiancheng Chen  on 2020/3/29.
//  Copyright © 2020 sijie.jiang. All rights reserved.
//

#import "createChatGroupViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudIM/AVOSCloudIM.h>
#import "ChatViewController.h"
@interface CreateChatGroupViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *userTableView;
@property (strong, nonatomic) NSArray *usersList;
@property (strong, nonatomic) NSMutableArray *selectUserIndexList;
@property (strong, nonatomic) AVIMClient *client;
@property (strong, nonatomic) AVUser *currentUser;
@property (strong, nonatomic) AVUser *talkToUser;
@property (assign, nonatomic) BOOL loginFailed;
@property (strong, nonatomic) NSString *conversationId;
@end

@implementation CreateChatGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.userTableView.delegate = self;
    self.userTableView.dataSource = self;

    self.usersList = [NSArray array];
    self.selectUserIndexList = [NSMutableArray array];
    
    AVQuery *query = [AVQuery queryWithClassName:@"_User"];
    [query selectKeys:@[@"objectId", @"username"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        self.usersList = users;
        [self refreshData];
    }];
    
    self.currentUser = [AVUser currentUser];
    self.client = [[AVIMClient alloc] initWithUser:self.currentUser];
    [AVUser logInWithUsernameInBackground:self.currentUser.username password:self.currentUser.password block:^(AVUser * _Nullable user, NSError * _Nullable error) {
        if(!user) {
            self.loginFailed = YES;
        }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    if (indexPath.section == 1) {
        CreateCGCellViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
        AVUser *user = [self.usersList objectAtIndex:indexPath.row];
        if ([self.selectUserIndexList containsObject:indexPath]) {
            cell.isSelect.image = [UIImage addImage];
        } else {
            cell.isSelect.image = [UIImage removeImage];
        }
        cell.username.textColor = [UIColor blackColor];
        cell.username.text = user.username;
        return cell;
//    }
    
    // ..
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.usersList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.loginFailed) {
        return;
    }
    self.talkToUser = [self.usersList objectAtIndex:indexPath.row];
    if ([self.selectUserIndexList containsObject:indexPath]) {
        [self.selectUserIndexList removeObject:indexPath];
    } else {
        [self.selectUserIndexList addObject:indexPath];
    }
    [self refreshData];
}
/**
 *  刷新数据源
 */
- (void)refreshData {
    [self.userTableView reloadData];
}

- (IBAction)createChatGroupAction:(id)sender {
    self.hidesBottomBarWhenPushed = true;
    [self createGroupInCloud];
}

-(void) createGroupInCloud {
    [self.client openWithCallback:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSArray *selectedMemberIds = [self getIdsFromUserObjectList:self.selectUserIndexList];
            [self.client createConversationWithName:@"群聊" clientIds:selectedMemberIds callback:^(AVIMConversation *conversation, NSError *error) {
                if (!error) {
                    self.conversationId = conversation.conversationId;
                    [self performSegueWithIdentifier:@"enterGroupChatSegue" sender:self];
                    NSLog(@"创建成功！");
                } else {
                    NSLog(@"%@", error);
                }
            }];
        } else {
            NSLog(@"%@", error);
        }
    
    }];
}

-(NSArray *) getIdsFromUserObjectList:(NSMutableArray *)selectedUserIndexList {
    NSMutableArray *selectedMemberIds = [NSMutableArray array];
    for (NSIndexPath *indexPath in selectedUserIndexList) {
        AVUser *user = [self.usersList objectAtIndex:indexPath.row];
        [selectedMemberIds addObject:user.username];
    }
    return  selectedMemberIds;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    ChatViewController *chatviewcontroller = segue.destinationViewController;
    NSMutableArray *selectedMember = [NSMutableArray array];
    for (int i=0; i<self.selectUserIndexList.count; i++) {
        NSIndexPath *indexPath = [self.selectUserIndexList objectAtIndex:i];
        AVUser *user = [self.usersList objectAtIndex:indexPath.row];
        [selectedMember addObject:user];
    }
    chatviewcontroller.groupMember = selectedMember;
    chatviewcontroller.conversationId = self.conversationId;
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
