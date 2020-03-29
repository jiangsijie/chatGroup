//
//  MessageType.h
//  chatGroup
//
//  Created by Tiancheng Chen  on 2020/3/28.
//  Copyright © 2020 sijie.jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  消息类型
 */
typedef enum {
    SHMessageBodyType_text = 1,       //文本类型
    SHMessageBodyType_image,          //图片类型
    SHMessageBodyType_voice,          //语音类型
    SHMessageBodyType_video,          //视频类型
    SHMessageBodyType_location,       //位置类型
    SHMessageBodyType_card,           //名片类型
    SHMessageBodyType_redPaper,       //红包类型
    SHMessageBodyType_gif,            //动图类型
    SHMessageBodyType_note,           //通知类型
}MessageBodyType;

/**
 *  资源类型
 */
typedef enum {
    SHMessageFileType_image = 1,    //image类型
    SHMessageFileType_wav,          //wav类型
    SHMessageFileType_amr,          //amr类型
    SHMessageFileType_gif,          //gif类型
    SHMessageFileType_video,        //video类型
    SHMessageFileType_video_image,  //video图片类型
}MessageFileType;

/**
 *  输入框类型
 */
typedef enum {
    SHInputViewType_default,     //默认
    SHInputViewType_text,        //文本
    SHInputViewType_voice,       //语音
    SHInputViewType_emotion,     //表情
    SHInputViewType_menu,        //菜单
}InputViewType;

/**
 *  地图类型
 */
typedef enum {
    SHMessageLocationType_Location = 1,   //定位
    SHMessageLocationType_Look            //查看
}MessageLocationType;

/**
 *  点击类型
 */
typedef enum {
    SHMessageClickType_click_message = 1,   //点击消息
    SHMessageClickType_long_message,        //长按消息
    SHMessageClickType_click_head,          //点击头像
    SHMessageClickType_long_head,           //长按头像
    SHMessageClickType_click_retry,         //点击重发
}MessageClickType;

/**
 *  发送方
 */
typedef enum{
    SHBubbleMessageType_Sending = 0, // 发送
    SHBubbleMessageType_Receiving, // 接收
}BubbleMessageType;

/**
 *  聊天类型
 */
typedef enum{
    SHChatType_Chat = 1,  //单聊
    SHChatType_GroupChat  //群聊
}ChatType;

/**
 *  消息发送状态
 */
typedef enum{
    SHSendMessageType_Successed = 1,  //发送成功
    SHSendMessageType_Failed,         //发送失败
    SHSendMessageType_Delivering      //发送中
}SendMessageStatus;

@interface MessageType : NSObject

@end

NS_ASSUME_NONNULL_END
