//
//  MessageContentView.m
//  chatGroup
//
//  Created by Tiancheng Chen  on 2020/3/28.
//  Copyright © 2020 sijie.jiang. All rights reserved.
//

#import "MessageContentView.h"
#import "MessageHeader.h"
#import "MessageFrame.h"

@implementation MessageContentView


- (MessageTextView *)textView{
    if (!_textView) {
        _textView = [[MessageTextView alloc] init];
        _textView.backgroundColor = [UIColor clearColor];
        [self addSubview:_textView];
    }
    return _textView;
}

#pragma mark - 设置内部控件Frame
- (void)setMessage:(Message *)message {
    
    _message = message;
    
    // 初始化
    [self setBackgroundImage:nil forState:0];
    //文本
    self.textView.hidden = YES;
    
    BOOL isSend = (message.bubbleMessageType == SHBubbleMessageType_Sending);
    
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = 0;
    self.clipsToBounds = NO;
    
    // 背景颜色与描边
    switch (message.messageType) {
        case SHMessageBodyType_note:
        {
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
            self.layer.cornerRadius = 5;
            self.clipsToBounds = YES;
        }
            break;
        case SHMessageBodyType_image:case SHMessageBodyType_video://图片、视频
        {
            self.backgroundColor = [UIColor blackColor];
            self.layer.cornerRadius = 5;
            self.clipsToBounds = YES;
            
            if (isSend) {
                self.x -= kChat_angle_w;
            }else{
                self.x += kChat_angle_w;
            }
        }
            break;
        case SHMessageBodyType_gif:
        {
            if (isSend) {
                self.x -= kChat_angle_w;
            }else{
                self.x += kChat_angle_w;
            }
        }
            break;
        default:
            break;
    }
    
    // 设置聊天气泡背景
    UIImage *normal = nil;
    if (isSend) {
        normal = [FileHelper imageNamed:@"chat_message_send@2x.png"];
    }else{
        normal = [FileHelper imageNamed:@"chat_message_receive@2x.png"];
    }
    
    normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(30, 25, 10, 25)];
    [self setBackgroundImage:normal forState:UIControlStateNormal];
    
    // 设置其他内容
    [self setContentWithMessage:message image:normal];
}

#pragma mark 设置内容
- (void)setContentWithMessage:(Message *)message image:(UIImage *)image{
    
    BOOL isSend = (message.bubbleMessageType == SHBubbleMessageType_Sending);
    
    NSInteger set_space = 5;
    
    //判断消息类型
    switch (message.messageType) {
        case SHMessageBodyType_text://文字
        {
            self.textView.hidden = NO;
            
            NSMutableAttributedString *str = (NSMutableAttributedString *)[SHEmotionTool getAttWithStr:message.text font:kChatFont_content];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, str.length)];
            
            self.textView.attributedText = str;
            //设置frame
            CGFloat view_y = kChat_margin;
            if (kChatFont_content.lineHeight < kChat_min_h) {//为了使聊天内容与最小高度对齐
                view_y = (kChat_min_h - kChatFont_content.lineHeight)/2;
            }
            
            self.textView.frame = CGRectMake(kChat_margin + (isSend?0:kChat_angle_w), view_y, self.width - (2*kChat_margin + kChat_angle_w), self.height - 2*view_y);
        }
            break;
//        case SHMessageBodyType_image://图片
//        {
//            NSString *filePath = [SHFileHelper getFilePathWithName:message.imageName type:SHMessageFileType_image];
//            UIImage *image = [UIImage imageWithContentsOfFile:filePath];
//
//            if (image) {//本地
//                [self setBackgroundImage:image forState:0];
//            }else{//网络
//                //sdwebimage
//                [self setBackgroundImage:[SHFileHelper imageNamed:@"chat_picture.png"] forState:0];
//            }
//        }
//            break;
        default:
            break;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
