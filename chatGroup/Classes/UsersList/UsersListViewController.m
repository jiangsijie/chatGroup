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

extern AVIMClient *gAVIMCient;
extern BOOL loginSuccessed;

@interface UsersListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *userTableView;
@property (strong, nonatomic) NSArray *usersList;
@property (strong, nonatomic) AVUser *talkToUser;

@end

@implementation UsersListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.userTableView.delegate = self;
    self.userTableView.dataSource = self;

    self.usersList = [NSArray array];

    AVQuery *query = [AVQuery queryWithClassName:@"_User"];
    [query selectKeys:@[@"objectId", @"username"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        self.usersList = users;
        [self refreshData];
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
        AVUser *user = [self.usersList objectAtIndex:indexPath.row];
        cell.usernameLabel.text = user.username;
        return cell;
    } else {
        UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
        cell.usernameLabel.text = @"新建群聊";
        return cell;
    }
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
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(!loginSuccessed) {
        return;
    }
    
    if (indexPath.section == 0) {
         self.talkToUser = [self.usersList objectAtIndex:indexPath.row];
         self.hidesBottomBarWhenPushed = YES;
         [self performSegueWithIdentifier:@"enterConversationSegue" sender:self];
         self.hidesBottomBarWhenPushed = NO;
    } else {
         self.talkToUser = [self.usersList objectAtIndex:indexPath.row];
         self.hidesBottomBarWhenPushed = YES;
         [self performSegueWithIdentifier:@"enterCreateGroupSegue" sender:self];
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
    ConversationViewController *destination = segue.destinationViewController;
    destination.talkToUser = self.talkToUser;
}

@end
