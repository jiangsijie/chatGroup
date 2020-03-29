//
//  MessageFrame.h
//  chatGroup
//
//  Created by Tiancheng Chen  on 2020/3/28.
//  Copyright © 2020 sijie.jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageHeader.h"

@class Message;

//内容最大宽度（截取到气泡）
#define kChat_content_maxW (kSHWidth - 4*kChat_margin - 2*kChat_icon_wh - kChat_angle_w - 40)
//消息中控件与内容间隔
static NSInteger const kChat_margin = 10;

//单行气泡高度
static NSInteger const kChat_min_h = 45;

//time
//时间间隙
static NSInteger const kChat_margin_time = 7;

//icon
//头像宽高
static NSInteger const kChat_icon_wh = 45;

//name
//名字高度
static NSInteger const kChat_name_h = 15;

//聊天气泡角的宽度
static NSInteger const kChat_angle_w = 4;

//内容的宽
//图片
//图片宽高
static NSInteger const kChat_pic_wh = 160;
//语音
//语音最大宽度
static NSInteger const kChat_voice_maxW = 160;
//位置
//位置宽
static NSInteger const kChat_location_w = 200;
//位置高
static NSInteger const kChat_location_h = 100;
//名片
//名片的宽
static NSInteger const kChat_card_w = 200;
//名片的高
static NSInteger const kChat_card_h = 80;
//视频
//视频宽高
static NSInteger const kChat_video_wh = 120;
//动图
//Gif的宽高
static NSInteger const kChat_gif_wh = 100;
//红包
//红包的宽
static NSInteger const kChat_redPackage_w = 200;
//红包的高
static NSInteger const kChat_redPackage_h = 80;

//字体
//时间字体
#define kChatFont_time [UIFont systemFontOfSize:11]
//ID字体
#define kChatFont_name [UIFont systemFontOfSize:11]
//内容字体
#define kChatFont_content [UIFont systemFontOfSize:16]
//提示内容字体
#define kChatFont_note [UIFont systemFontOfSize:12]

NS_ASSUME_NONNULL_BEGIN

@interface MessageFrame : NSObject

@property (nonatomic, assign, readonly) CGRect time;
@property (nonatomic, assign, readonly) CGRect name;
@property (nonatomic, assign, readonly) CGRect icon;
@property (nonatomic, assign, readonly) CGRect content;
@property (nonatomic, assign, readonly) CGFloat cell_h;
@property (nonatomic, strong) Message *message;
@property (nonatomic, assign) BOOL showTime;
@property (nonatomic, assign) BOOL showName;

@end

NS_ASSUME_NONNULL_END
