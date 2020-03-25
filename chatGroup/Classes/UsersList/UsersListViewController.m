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
#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudIM/AVOSCloudIM.h>

@interface UsersListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *userTableView;
@property (strong, nonatomic) NSArray *usersList;
@property (strong, nonatomic) AVIMClient *client;
@property (strong, nonatomic) AVUser *currentUser;
@property (strong, nonatomic) AVUser *talkToUser;
@property (assign, nonatomic) BOOL loginFailed;

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
    
    self.currentUser = [AVUser currentUser];
    self.client = [[AVIMClient alloc] initWithUser:self.currentUser];
    [AVUser logInWithUsernameInBackground:self.currentUser.username password:self.currentUser.password block:^(AVUser * _Nullable user, NSError * _Nullable error) {
        if(!user) {
            self.loginFailed = YES;
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ConversationViewController *page = [segue destinationViewController];
    page.talkToUser = self.talkToUser;
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    AVUser *user = [self.usersList objectAtIndex:indexPath.row];
    cell.usernameLabel.text = user.username;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.usersList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.loginFailed) {
        return;
    }
    
    self.talkToUser = [self.usersList objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"fromUsersLstToConversationPage" sender:self];
}
/**
 *  刷新数据源
 */
- (void)refreshData {
    [self.userTableView reloadData];
}

//- (void)encodeWithCoder:(nonnull NSCoder *)coder {
//    <#code#>
//}
//
//- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
//    <#code#>
//}
//
//- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
//    <#code#>
//}
//
//- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
//    <#code#>
//}

//- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
//    <#code#>
//}

//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
//    <#code#>
//}
//
//- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
//    <#code#>
//}
//
//- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
//    <#code#>
//}

//- (void)setNeedsFocusUpdate {
//    <#code#>
//}
//
//- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
//    <#code#>
//}
//
//- (void)updateFocusIfNeeded {
//    <#code#>
//}

@end
