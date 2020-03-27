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
    [self performSegueWithIdentifier:@"enterConversationSegue" sender:self];
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

- (IBAction)doSomething:(id)sender {

}
//    if segue.identifier == "backMainForP1"{
//        //获取返回的控制器
//        let backVC = segue.source as! P1ViewController
//        mainLabel.text = backVC.backSting//获取返回值
//    }
//    if segue.identifier == "backMainForP2"{
//        //获取返回的控制器
//        let backVC = segue.source as! P2ViewController
//        mainLabel.text = backVC.backSting//获取返回值
//    }

@end