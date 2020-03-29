//
//  ChatMessageTableViewCell.h
//  chatGroup
//
//  Created by Tiancheng Chen  on 2020/3/28.
//  Copyright © 2020 sijie.jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityIndicatorView.h"
#import "MessageHeader.h"

@class MessageContentView;
@class MessageFrame;
@class ChatMessageTableViewCell;

@protocol ChatMessageCellDelegate <NSObject>

@optional
-(void)didSelectWithCell:(ChatMessageTableViewCell *_Nullable)cell
                    type:(MessageClickType)type message:(Message *_Nullable)message;
@end

NS_ASSUME_NONNULL_BEGIN

@interface ChatMessageTableViewCell : UITableViewCell
//点击位置
@property (nonatomic, assign) CGPoint tapPoint;

//代理
@property (nonatomic, weak) id <ChatMessageCellDelegate>delegate;
//坐标
@property (nonatomic, retain) MessageFrame *messageFrame;
//内容
@property (nonatomic, retain) MessageContentView *btnContent;
//时间
@property (nonatomic, retain) UILabel *labelTime;
//ID
@property (nonatomic, retain) UILabel *labelNum;
//头像
@property (nonatomic, retain) UIButton *btnHeadImage;
//消息状态
@property (nonatomic, retain) ActivityIndicatorView *activityView;
@end

NS_ASSUME_NONNULL_END
