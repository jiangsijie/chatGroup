//
//  MessageInputView.h
//  chatGroup
//
//  Created by Tiancheng Chen  on 2020/3/28.
//  Copyright © 2020 sijie.jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageHeader.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MessageInputViewDelegate <NSObject>

@optional

-(void) chatMessageWithSendText:(NSString *)text;

@end

@interface MessageInputView : UIView

//父视图
@property (nonatomic, strong) UIViewController *supVC;
//代理
@property (nonatomic, weak) id<MessageInputViewDelegate> delegate;
//当前输入框类型
@property (nonatomic, assign) InputViewType inputType;
//多媒体数据
@property (nonatomic, strong) NSArray *shareMenuItems;

-(void)reloadView;
@end

NS_ASSUME_NONNULL_END
