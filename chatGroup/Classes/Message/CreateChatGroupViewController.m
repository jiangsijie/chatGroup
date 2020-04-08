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
#import "Group.h"
@interface CreateChatGroupViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *userTableView;
@property (strong, nonatomic) NSArray *usersList;
@property (strong, nonatomic) NSMutableArray *selectUserIndexList;
@property (strong, nonatomic) AVIMClient *client;
@property (strong, nonatomic) AVUser *currentUser;
@property (strong, nonatomic) AVUser *talkToUser;
@property (assign, nonatomic) BOOL loginFailed;
@property (strong, nonatomic) NSString *conversationId;
@property (strong, nonatomic) NSString *groupName;

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
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入群聊名称" preferredStyle:UIAlertControllerStyleAlert];

      [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];

      [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          UITextField *groupNameTextField = alertController.textFields.firstObject;
          self.hidesBottomBarWhenPushed = true;
          self.groupName = groupNameTextField.text;
          [self createGroupInCloud:groupNameTextField.text];
      }]];
      alertController.actions.lastObject.enabled = false;
      [alertController addTextFieldWithConfigurationHandler:^(UITextField*_NonnulltextField) {
          _NonnulltextField.placeholder=@"请输入群聊名称";
          [_NonnulltextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
      }];

    [self presentViewController:alertController animated:YES completion:nil];
}

-(void) textFieldChanged:(UITextField *)textFiled {
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
        //拿到doneAction按钮
    UIAlertAction * doneAction = alertController.actions.lastObject;
        //判断语句
        if (textFiled.text.length >= 3) {
            doneAction.enabled = true;
        } else {
            doneAction.enabled = false;
        }
}
-(void) createGroupInCloud:(NSString *)groupName {
    
    [self.client openWithCallback:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSArray *selectedMemberIds = [self getIdsFromUserObjectList:self.selectUserIndexList];
            [self.client createConversationWithName:groupName clientIds:selectedMemberIds callback:^(AVIMConversation *conversation, NSError *error) {
                if (!error) {
                    self.conversationId = conversation.conversationId;
                    [self saveConversationAndGroupInfo:conversation.conversationId group:groupName];
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

-(void)saveConversationAndGroupInfo:(NSString *)conversationId group:(NSString *) groupName{
    Group *group = [Group object];
    group.conversationId = conversationId;
    group.groupName = groupName;
    NSArray *members = [self getIdsFromUserObjectList:self.selectUserIndexList];
    group.members = members;
    [group saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [self performSegueWithIdentifier:@"enterGroupChatSegue" sender:self];
            NSLog(@"保存成功！");
        } else {
            NSLog(@"%@", error);
        }
    }];
}

-(NSArray *) getIdsFromUserObjectList:(NSMutableArray *)selectedUserIndexList {
    NSMutableArray *selectedMemberIds = [NSMutableArray array];
    for (NSIndexPath *indexPath in selectedUserIndexList) {
        AVUser *user = [self.usersList objectAtIndex:indexPath.row];
        [selectedMemberIds addObject:user.objectId];
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
    chatviewcontroller.groupName = self.groupName;
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
