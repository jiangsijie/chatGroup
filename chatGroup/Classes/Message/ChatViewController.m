//
//  ChatViewController.m
//  chatGroup
//
//  Created by Tiancheng Chen  on 2020/3/25.
//  Copyright © 2020 sijie.jiang. All rights reserved.
//

#import "ChatViewController.h"
#import "MessageInputView.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

#import "MessageHelper.h"

@interface ChatViewController ()<MessageInputViewDelegate,
ChatMessageCellDelegate,
UITableViewDelegate,
UITableViewDataSource>
{
    UIMenuItem * _copyMenuItem;
    UIMenuItem * _deleteMenuItem;
}

@property (nonatomic, strong) UITableView *chatTableView;
@property (nonatomic, strong) MessageInputView *chatInputView;
@property (nonatomic, strong) UIImageView *bgImageView;
//未读
@property (nonatomic, strong) UIButton *unreadBtn;
//加载控件
@property (nonatomic, strong) UIRefreshControl *refresh;

//当前点击的Cell
@property (nonatomic, weak) ChatMessageTableViewCell *selectCell;

//数据源
@property (nonatomic, strong) NSMutableArray *dataSource;

//显示的时间集合
@property (nonatomic, strong) NSMutableArray *timeArr;
@end

@implementation ChatViewController

static NSString * const reuseIdentifier = @"ChatMessageCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kInPutViewColor;
    self.dataSource = [[NSMutableArray alloc] init];
    
    [self config];
    // Do any additional setup after loading the view.
}

-(void) config{
    [self.view addSubview:self.chatInputView];
    [self.view addSubview:self.chatTableView];
    [self.view addSubview:self.bgImageView];
    [self.view sendSubviewToBack:self.bgImageView];
    
    self.chatTableView.refreshControl = self.refresh;
    [self addKeyboardNote];
    
    self.unreadBtn.tag =20;
    [self configUnread:20];
    
    [self tableViewScrollToBottom];
}


-(void)loadData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.dataSource.count) {
            
            NSArray *tmp = [self loadMessageDataWithNum:10 isLoad:YES];
            
            if (tmp.count) {
                 NSMutableIndexSet *indexes = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, tmp.count)];
                               [self.dataSource insertObjects:tmp atIndexes:indexes];

                               [self.chatTableView reloadData];
                               //滚动到刷新位置
                               [self tableViewScrollToIndex:tmp.count];
                
            }
            [self configUnread:(self.unreadBtn.tag - tmp.count)];
        }else{
                //获取数据
                NSArray *temp = [self loadMessageDataWithNum:10 isLoad:NO];
                
                if (temp.count) {
                    //添加数据
                    [self.dataSource addObjectsFromArray:temp];
                    
                    [self.chatTableView reloadData];
                    //滚动到最下方
                    [self tableViewScrollToBottom];
                }
                
                //配置未读控件
                [self configUnread:(self.unreadBtn.tag - temp.count)];
            }
            
            [self.refresh endRefreshing];
    });
}

-(NSArray <MessageFrame *> *)loadMessageDataWithNum:(NSUInteger)num isLoad:(BOOL)isLoad{
    NSMutableArray *temp = [[NSMutableArray alloc]init];
        NSMutableArray *loadTimeArr = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < num; i++) {
            
            Message *message;
            
            switch (arc4random()%8) {
                case 0:
                    message = [self getTextMessage];
                    break;
                default:
                    message = [self getTextMessage];
                    break;
            }
            
            message.messageState = SHSendMessageType_Successed;
            
            MessageFrame *messageFrame = [self dealDataWithMessage:message dateSoure:temp setTime:isLoad?loadTimeArr.lastObject:self.timeArr.lastObject];
            
            if (messageFrame) {//做添加
                
                if (messageFrame.showTime) {
                    
                    if (isLoad) {
                        [loadTimeArr addObject:message.sendTime];
                    }else{
                        [self.timeArr addObject:message.sendTime];
                    }
                }
                
                [temp addObject:messageFrame];
            }
        }
        
        if (loadTimeArr.count) {
            NSMutableIndexSet *indexes = [NSMutableIndexSet indexSetWithIndex:0];
            [indexes addIndex:0];
            
            [self.timeArr insertObjects:loadTimeArr atIndexes:indexes];
        }
        
        return temp;
}

#pragma mark 获取文本
- (Message *)getTextMessage{
    
    Message *message = [MessageHelper addPublicParameters];
    
    message.messageType = SHMessageBodyType_text;
    message.text = @"GitHub：https://github.com/CCSH";
    
    return message;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageFrame *messageFrame = self.dataSource[indexPath.row];
    return messageFrame.cell_h;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChatMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[ChatMessageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.delegate = self;
    }
    
    MessageFrame *messageFrame = self.dataSource[indexPath.row];
    cell.messageFrame = messageFrame;
    
    return cell;
}

#pragma mark - ScrollVIewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    //默认输入
    self.chatInputView.inputType = SHInputViewType_default;
}

#pragma mark - SHMessageInputViewDelegate
#pragma mark 发送文本
- (void)chatMessageWithSendText:(NSString *)text{
    
    Message *message = [MessageHelper addPublicParameters];
    
    message.messageType = SHMessageBodyType_text;
    message.text = text;
    
    //添加到聊天界面
    [self addChatMessageWithMessage:message isBottom:YES];
}

- (void)toolbarHeightChange{
    
    //改变聊天界面高度
    CGRect frame = self.chatTableView.frame;
    frame.size.height = self.chatInputView.y;
    self.chatTableView.frame = frame;
    [self.view layoutIfNeeded];
    //滚动到底部
    [self tableViewScrollToBottom];
}

#pragma mark - SHChatMessageCellDelegate
- (void)didSelectWithCell:(ChatMessageTableViewCell *)cell type:(MessageClickType)type message:(Message *)message{
    
    //默认输入
    self.chatInputView.inputType = SHInputViewType_default;
    
    switch (type) {
        case SHMessageClickType_click_message://点击消息
        {
            NSLog(@"点击消息");
            //点击消息
            [self didSelectMessageWithMessage:message];
        }
            break;
        case SHMessageClickType_long_message://长按消息
        {
            NSLog(@"长按消息");
            self.selectCell = cell;
            
            //设置菜单内容
            NSArray *menuArr = [self getMenuControllerWithMessage:message];
            //显示菜单
//            [MenuController showMenuControllerWithView:cell menuArr:menuArr showPiont:cell.tapPoint];
            
            cell.tapPoint = CGPointZero;
        }
            break;
        case SHMessageClickType_click_head://点击头像
        {
            NSLog(@"点击头像");
        }
            break;
        case SHMessageClickType_long_head://长按头像
        {
            NSLog(@"长按头像");
        }
            break;
        case SHMessageClickType_click_retry://点击重发
        {
            NSLog(@"点击重发");
//            [self resendChatMessageWithMessageId:message.messageId];
        }
            break;
        default:
            break;
    }
}

#pragma mark 点击消息处理
- (void)didSelectMessageWithMessage:(Message *)message{
    
    //判断消息类型
    switch (message.messageType) {
        case SHMessageBodyType_image://图片
        {
            NSLog(@"点击了 --- 图片消息");

        }
            break;
        case SHMessageBodyType_voice://语音
        {
//            NSLog(@"点击了 --- 语音消息");
//            SHAudioPlayerHelper *audio = [SHAudioPlayerHelper shareInstance];
//            audio.delegate = self;
//
//            if (self.selectCell.btnContent.isPlaying) {
//                //正在播放
//                self.selectCell.btnContent.isPlaying = NO;
//                [audio stopAudio];//停止
//            }else{
//                //未播放
//                self.selectCell.btnContent.isPlaying = YES;
//                [audio managerAudioWithFileArr:@[message] isClear:YES];
//            }
        }
            break;
        case SHMessageBodyType_location://位置
        {
            NSLog(@"点击了 --- 位置消息");
            //跳转地图界面
//            SHChatMessageLocationViewController *location = [[SHChatMessageLocationViewController alloc]init];
//            location.message = message;
//            location.locType = SHMessageLocationType_Look;
//            [self.navigationController pushViewController:location animated:YES];
        }
            break;
        case SHMessageBodyType_video://视频
        {
            NSLog(@"点击了 --- 视频消息");
//            //本地路径
//            NSString *videoPath = [FileHelper getFilePathWithName:message.videoName type:SHMessageFileType_video];
//
//            if ([[NSFileManager defaultManager] fileExistsAtPath:videoPath]) {//如果本地路径存在
//
//                AVPlayer *player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:videoPath]];
//                AVPlayerViewController *playerViewController = [AVPlayerViewController new];
//                playerViewController.player = player;
//                [self.navigationController pushViewController:playerViewController animated:YES];
//                [playerViewController.player play];
//
//            }else{//使用URL
//
//                if (message.videoUrl.length) {
//                    AVPlayer *player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:message.videoUrl]];
//                    AVPlayerViewController *playerViewController = [AVPlayerViewController new];
//                    playerViewController.player = player;
//                    [self.navigationController pushViewController:playerViewController animated:YES];
//                    [playerViewController.player play];
//                }
//            }
        }
            break;
        case SHMessageBodyType_card://名片
        {
            NSLog(@"点击了 --- 名片消息");
        }
            break;
        case SHMessageBodyType_redPaper://红包
        {
            NSLog(@"点击了 --- 红包消息");
        }
            break;
        case SHMessageBodyType_gif://Gif
        {
            NSLog(@"点击了 --- gif消息");
        }
            break;
        default:
            break;
    }
    
    //修改消息状态
    message.messageRead = YES;
}

#pragma mark 获取长按菜单内容
- (NSArray *)getMenuControllerWithMessage:(Message *)message{
    
    //初始化列表
    if (!_copyMenuItem) {
        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyItem)];
    }
    if (!_deleteMenuItem) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteItem)];
    }
    
    NSMutableArray *menuArr = [[NSMutableArray alloc]init];
    //复制
    if (message.messageType == SHMessageBodyType_text) {//文本有复制
        //添加复制
        [menuArr addObject:_copyMenuItem];
    }
    //添加删除
    [menuArr addObject:_deleteMenuItem];
    
    return menuArr;
}

#pragma mark 添加第一响应
- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark - 长按菜单内容点击
#pragma mark 复制
- (void)copyItem{
    [UIPasteboard generalPasteboard].string = self.selectCell.messageFrame.message.text;
}

#pragma mark 删除
- (void)deleteItem{
    NSLog(@"删除");
    
    //删除消息
    [self deleteChatMessageWithMessageId:self.selectCell.messageFrame.message.messageId];
}

#pragma mark - SHAudioPlayerHelperDelegate
#pragma mark 开始播放
- (void)didAudioPlayerBeginPlay:(NSString *)playerName{
    
//    for (SHChatMessageTableViewCell *cell in self.chatTableView.visibleCells) {
//        if ([cell.btnContent.message.voiceName isEqualToString:playerName]) {
//            [cell.btnContent playVoiceAnimation];
//            cell.btnContent.readMarker.hidden = YES;
//        }else{
//            cell.btnContent.isPlaying = NO;
//            [cell.btnContent stopVoiceAnimation];
//        }
//    }
}

#pragma mark 结束播放
- (void)didAudioPlayerStopPlay:(NSString *)playerName error:(NSString *)error{
    
//    for (SHChatMessageTableViewCell *cell in self.chatTableView.visibleCells) {
//        if ([cell.btnContent.message.voiceName isEqualToString:playerName]) {
//            [cell.btnContent stopVoiceAnimation];
//            cell.btnContent.isPlaying = NO;
//        }
//    }
}

#pragma mark 暂停播放
- (void)didAudioPlayerPausePlay:(NSString *)playerName{
//    for (ChatMessageTableViewCell *cell in self.chatTableView.visibleCells) {
//        if ([cell.btnContent.message.voiceName isEqualToString:playerName]) {
//            [cell.btnContent stopVoiceAnimation];
//        }
//    }
}

#pragma mark - 数据处理
#pragma mark 添加到下方聊天界面
- (void)addChatMessageWithMessage:(Message *)message isBottom:(BOOL)isBottom{
    
    if (message.messageState == SHSendMessageType_Delivering) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            message.messageState = SHSendMessageType_Failed;
            [self addChatMessageWithMessage:message isBottom:NO];
        });
    }
    
    //判断是否重复
    MessageFrame *messageFrame = [self dealDataWithMessage:message dateSoure:self.dataSource  setTime:self.timeArr.lastObject];
    
    if (messageFrame) {//做添加
        
//        if (messageFrame.showTime) {
//            [self.timeArr addObject:message.sendTime];
//        }
        [self.dataSource addObject:messageFrame];
    }
    
    [self.chatTableView reloadData];
    
    if (isBottom) {
        //滚动到底部
        [self tableViewScrollToBottom];
    }
}

#pragma mark 处理数据属性
- (MessageFrame *)dealDataWithMessage:(Message *)message dateSoure:(NSMutableArray *)dataSoure setTime:(NSString *)setTime{
    
    MessageFrame *messageFrame = [[MessageFrame alloc]init];
    
    //是否需要添加
    __block BOOL isAdd = YES;
    
    //为了判断是否有重复的数据
    [dataSoure enumerateObjectsUsingBlock:^(MessageFrame *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([message.messageId isEqualToString:obj.message.messageId]) {//同一条消息
             *stop = YES;
            
            if ([message.sendTime isEqualToString:obj.message.sendTime]) {//时间相同做刷新
                
                isAdd = NO;
                
                messageFrame.showTime = obj.showTime;
                messageFrame.showName = obj.showName;
                
                [messageFrame setMessage:message];
                [dataSoure replaceObjectAtIndex:idx withObject:messageFrame];
                
            }else{//时间不同做添加
                
                [dataSoure removeObject:obj];
            }
        }
    }];
    
    //已经更新则不用进行处理
    if (isAdd) {
        
        //是否显示时间
        messageFrame.showTime = [MessageHelper isShowTimeWithTime:message.sendTime setTime:setTime];
        
        [messageFrame setMessage:message];
        return messageFrame;
    }
    
    return nil;
}

#pragma mark 删除聊天消息消息
- (void)deleteChatMessageWithMessageId:(NSString *)messageId{
    
    //删除此条消息
    [self.dataSource enumerateObjectsUsingBlock:^(MessageFrame *obj, NSUInteger idx, BOOL * _Nonnull stop){
        
        if ([obj.message.messageId isEqual:messageId]) {
            *stop = YES;
        
            //删除数据源
            [self.dataSource removeObject:obj];
            
            //处理时间操作
            [self dealTimeMassageDataWithCurrent:obj idx:idx];
        }
    }];
    
    [self.chatTableView reloadData];
}

#pragma mark 重发聊天消息消息
- (void)resendChatMessageWithMessageId:(NSString *)messageId{
    
    [self.dataSource enumerateObjectsUsingBlock:^(MessageFrame *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.message.messageId isEqualToString:messageId]) {
            *stop = YES;
            
            //删除之前数据
            [self.dataSource removeObject:obj];
            
            //处理时间操作
            [self dealTimeMassageDataWithCurrent:obj idx:idx];
            
            //添加公共配置
            Message *model = [MessageHelper addPublicParametersWithMessage:obj.message];
            
            //模拟数据
            model.messageState = SHSendMessageType_Successed;
            model.bubbleMessageType = SHBubbleMessageType_Sending;
            //添加消息到聊天界面
            [self addChatMessageWithMessage:model isBottom:YES];
        }
    }];
}

#pragma mark 处理时间操作
- (void)dealTimeMassageDataWithCurrent:(MessageFrame *)current idx:(NSInteger)idx{
    
    //操作的此条是显示时间的
    if (current.showTime) {
        if (self.dataSource.count > idx) {//操作的是中间的
            
            MessageFrame *frame = self.dataSource[idx];
            
            [self.timeArr enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isEqualToString:current.message.sendTime]) {
                    *stop = YES;
                    [self.timeArr replaceObjectAtIndex:idx withObject:frame.message.sendTime];
                }
            }];
            
            frame.showTime = YES;
            //重新计算高度
            [frame setMessage:frame.message];
            [self.dataSource replaceObjectAtIndex:idx withObject:frame];
            
        }else{//操作的是最后一条
            [self.timeArr removeObject:current.message.sendTime];
        }
    }
}

#pragma mark - 界面滚动
#pragma mark 处理是否滚动到底部
- (void)dealScrollToBottom{
    
    if (self.dataSource.count > 1) {
        
        //整个tableview的倒数第二个cell
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataSource.count - 2 inSection:0];
        ChatMessageTableViewCell *lastCell = (ChatMessageTableViewCell *)[self.chatTableView cellForRowAtIndexPath:indexPath];
        
        CGRect last_rect = [lastCell convertRect:lastCell.frame toView:self.chatTableView];
        
        if (last_rect.size.width) {
            //滚动到底部
            [self tableViewScrollToBottom];
        }
    }
}
#pragma mark 滚动最上方
- (void)tableViewScrollToTop{
    
    //界面滚动到指定位置
    [self tableViewScrollToIndex:0];
}

#pragma mark 滚动最下方
- (void)tableViewScrollToBottom{
    
    //界面滚动到指定位置
    [self tableViewScrollToIndex:self.dataSource.count - 1];
}

#pragma mark 滚动到指定位置
- (void)tableViewScrollToIndex:(NSInteger)index{

    @synchronized (self.dataSource) {
        
        if (self.dataSource.count > index) {
            
            [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
}

#pragma mark - 键盘通知
#pragma mark 添加键盘通知
- (void)addKeyboardNote {
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    // 1.显示键盘
    [center addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    
    // 2.隐藏键盘
    [center addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark 键盘通知执行
- (void)keyboardChange:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect newFrame = self.chatInputView.frame;
    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height;
    
    if ([notification.name isEqualToString:@"UIKeyboardWillHideNotification"]) {
        newFrame.origin.y -= kSHBottomSafe;
    }
    self.chatInputView.frame = newFrame;
    
    [UIView commitAnimations];
}

#pragma mark - 懒加载
#pragma mark 背景图片
- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        //设置背景
        _bgImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        _bgImageView.image = [FileHelper imageNamed:@"message_bg.jpeg"];
        _bgImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _bgImageView;
}

#pragma mark 聊天界面
- (UITableView *)chatTableView{
    if (!_chatTableView) {
        _chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSHWidth, self.chatInputView.y) style:UITableViewStylePlain];
        _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _chatTableView.backgroundColor = [UIColor clearColor];
        _chatTableView.delegate = self;
        _chatTableView.dataSource = self;
        
        _chatTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _chatTableView;
}

#pragma mark 下方输入框
- (MessageInputView *)chatInputView{
    
    if (!_chatInputView) {
        _chatInputView = [[MessageInputView alloc]init];
        _chatInputView.frame = CGRectMake(0, self.view.height - kSHInPutHeight - kSHBottomSafe, kSHWidth, kSHInPutHeight);
        _chatInputView.delegate = self;
        _chatInputView.supVC = self;
        
        //图标
        NSArray *plugIcons = @[@"sharemore_pic.png", @"sharemore_video.png",@"sharemore_voipvoice.png", @"sharemore_location.png",  @"sharemore_myfav.png", @"sharemore_friendcard.png"];
        //标题
        NSArray *plugTitle = @[@"照片", @"拍摄", @"通话", @"位置", @"红包", @"名片"];
        
        // 添加第三方接入数据
        NSMutableArray *shareMenuItems = [NSMutableArray array];
        
        //配置Item按钮
        [plugIcons enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop)  {
            
//            SHShareMenuItem *shareMenuItem = [[SHShareMenuItem alloc] initWithIcon:[SHFileHelper imageNamed:obj] title:plugTitle[idx]];
//            [shareMenuItems addObject:shareMenuItem];
        }];
        
        _chatInputView.shareMenuItems = shareMenuItems;
        [_chatInputView reloadView];
        
        if (kSHBottomSafe) {
            UIView *view = [[UIView alloc]init];
            view.frame = CGRectMake(0, _chatInputView.maxY, kSHWidth, kSHBottomSafe);
            view.backgroundColor = kInPutViewColor;
            [self.view addSubview:view];
        }
    }
    return _chatInputView;
}

#pragma mark 时间集合
- (NSMutableArray *)timeArr{
    if (!_timeArr) {
        _timeArr = [[NSMutableArray alloc]init];
    }
    return _timeArr;
}

#pragma mark 加载
- (UIRefreshControl *)refresh{
    if (!_refresh) {
        _refresh = [[UIRefreshControl alloc]init];
        [_refresh addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    }
    return _refresh;
}

#pragma mark 未读按钮
- (UIButton *)unreadBtn{
    if (!_unreadBtn) {
        _unreadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _unreadBtn.frame = CGRectMake(kSHWidth - 135, 20 + 44 + kSHTopSafe, 135, 35);
        
        _unreadBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_unreadBtn setTitleColor:[UIColor redColor] forState:0];
        [_unreadBtn setBackgroundImage:[FileHelper imageNamed:@"unread_bg.png"] forState:0];
        [_unreadBtn addTarget:self action:@selector(unreadClick:) forControlEvents:UIControlEventTouchUpInside];
        _unreadBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self.view addSubview:_unreadBtn];
    }
    
    return _unreadBtn;
}

#pragma mark 配置未读控件
- (void)configUnread:(NSInteger)unreadNum{
    
    if (!self.unreadBtn.tag) {
        return;
    }
    
    if (unreadNum > 0) {//只有大于一屏的时候才显示未读控件
        
        self.unreadBtn.tag = unreadNum;
        if (unreadNum > 99) {
            [self.unreadBtn setTitle:@"99+ 条新消息 " forState:0];
        }else{
            [self.unreadBtn setTitle:[NSString stringWithFormat:@"%ld 条新消息 ",(long)unreadNum] forState:0];
        }
    }else{
        
        self.unreadBtn.tag = 0;
        [self.unreadBtn removeFromSuperview];
    }
}

#pragma mark - VC界面周期函数
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title = @"晶晶";
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.selectCell = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 销毁
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
