//
//  UsersListViewController.m
//  chatGroup
//
//  Created by sijie.jiang on 2020/3/24.
//  Copyright © 2020 sijie.jiang. All rights reserved.
//

#import "UsersListViewController.h"
#import "UserTableViewCell.h"
#import "ConversationViewController.h"
#import "Group.h"
#import "ChatViewController.h"
#import "FileHelper.h"

extern AVIMClient *gAVIMCient;
extern BOOL loginSuccessed;

@interface UsersListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *userTableView;
@property (strong, nonatomic) NSArray *usersList;
@property (strong, nonatomic) AVUser *talkToUser;
@property (strong, nonatomic) NSArray *groupList;
@property (assign, nonatomic) BOOL isClickGroup;
@property (assign, nonatomic) BOOL isClickCreate;
@property (strong, nonatomic) Group *currentSelectGroup;
@end

@implementation UsersListViewController

- (IBAction)createNewGroup:(id)sender {
    self.isClickCreate = true;
    self.hidesBottomBarWhenPushed = YES;
    [self performSegueWithIdentifier:@"enterCreateGroupSegue" sender:self];
    self.hidesBottomBarWhenPushed = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.userTableView.delegate = self;
    self.userTableView.dataSource = self;

    self.usersList = [NSArray array];
    self.groupList = [NSArray array];
    AVQuery *query = [AVQuery queryWithClassName:@"_User"];
    [query selectKeys:@[@"objectId", @"username"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        self.usersList = users;
        [self refreshData];
    }];
    
    AVQuery *groupQuery = [Group query];
    [groupQuery orderByDescending:@"createdAt"];
    [groupQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray *groupsContainCurrentUser = [NSMutableArray array];
            for (Group *group in objects) {
                if ([self checkCurrentUserIsMember:group]) {
                    [groupsContainCurrentUser addObject:group];
                }
            }
            self.groupList = groupsContainCurrentUser;
            [self refreshData];
        }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
        AVUser *user = [self.usersList objectAtIndex:indexPath.row];
        cell.usernameLabel.text = user.username;
        cell.userHeader.image = [FileHelper imageNamed:@"headImage.jpeg"];
        return cell;
    } else {
        Group *group = [self.groupList objectAtIndex:indexPath.row];
        UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
        cell.usernameLabel.text = group.groupName;
        cell.userHeader.image = [FileHelper imageNamed:@"sharemore_friendcard.png"];
        return cell;
    }
}

-(BOOL) checkCurrentUserIsMember:(Group *)group{
    AVUser *currentUser = [AVUser currentUser];
    if ([group.members containsObject:currentUser.objectId]) {
        return true;
    }
    return false;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section == 0 ? @"好友" : @"群聊";
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return self.usersList.count;
    }
    return self.groupList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(!loginSuccessed) {
        return;
    }
    
    if (indexPath.section == 0) {
         self.isClickGroup = false;
         self.isClickCreate = false;
         self.talkToUser = [self.usersList objectAtIndex:indexPath.row];
         self.hidesBottomBarWhenPushed = YES;
         [self performSegueWithIdentifier:@"enterConversationSegue" sender:self];
         self.hidesBottomBarWhenPushed = NO;
    } else {
        self.isClickGroup = true;
        self.isClickCreate = false;
        Group *group = [self.groupList objectAtIndex:indexPath.row];
        self.currentSelectGroup = group;
        self.hidesBottomBarWhenPushed = YES;
        [self performSegueWithIdentifier:@"enterGroupChatSegue" sender:self];
        self.hidesBottomBarWhenPushed = NO;
    }
}

/**
 *  刷新数据源
 */
- (void)refreshData {
    [self.userTableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (self.isClickGroup && !self.isClickCreate) {
        ChatViewController *destination = segue.destinationViewController;
        destination.conversationId = self.currentSelectGroup.conversationId;
        destination.groupName = self.currentSelectGroup.groupName;
        destination.groupMember = self.currentSelectGroup.members;
    }
    
    if (!self.isClickGroup && !self.isClickCreate) {
        ConversationViewController *destination = segue.destinationViewController;
        destination.talkToUser = self.talkToUser;
    }
}

@end
