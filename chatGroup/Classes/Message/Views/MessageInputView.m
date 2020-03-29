//
//  MessageInputView.m
//  chatGroup
//
//  Created by Tiancheng Chen  on 2020/3/28.
//  Copyright © 2020 sijie.jiang. All rights reserved.
//

#import "MessageInputView.h"

@interface MessageInputView()<
UITableViewDelegate,
UINavigationControllerDelegate
>

//改变输入状态按钮（语音、文字）
@property (nonatomic, strong) UIButton *changeBtn;
//语音输入按钮
@property (nonatomic, strong) UIButton *voiceBtn;
//文本输入框
@property (nonatomic, strong) UITextView *textView;
//表情按钮
@property (nonatomic, strong) UIButton *emojiBtn;
//菜单按钮
@property (nonatomic, strong) UIButton *menuBtn;
@end

@implementation MessageInputView


static CGFloat start_maxy;

#pragma mark - 公共方法
#pragma mark 刷新界面
- (void)reloadView{
    //设置背景颜色
    self.backgroundColor = kInPutViewColor;
    
    //分割线
    self.layer.cornerRadius = 1;
    self.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4].CGColor;
    self.layer.borderWidth = 0.4;
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    start_maxy = self.maxY;
    
    //添加改变输入状态按钮（语音、文字）
    [self addSubview:self.changeBtn];
    //添加表情按钮
    [self addSubview:self.emojiBtn];
    //添加菜单按钮
    [self addSubview:self.menuBtn];
    //添加文本输入框
    [self addSubview:self.textView];
    //添加语音输入框
    [self addSubview:self.voiceBtn];
    
    //设置输入框类型
    self.inputType = SHInputViewType_default;
        
    //添加监听
    [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

#pragma mark - 懒加载
#pragma mark 改变输入状态按钮（语音、文字）
- (UIButton *)changeBtn{
    if (!_changeBtn) {
        ////改变输入状态按钮（语音、文字）
        _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeBtn.frame = CGRectMake(kSHInPutSpace, self.height - kSHInPutSpace - kSHInPutIcon_WH, kSHInPutIcon_WH, kSHInPutIcon_WH);

        [_changeBtn setBackgroundImage:[FileHelper imageNamed:@"chat_voice.png"] forState:UIControlStateNormal];
        [_changeBtn setBackgroundImage:[FileHelper imageNamed:@"chat_keyboard.png"] forState:UIControlStateSelected];

        [_changeBtn addTarget:self action:@selector(changeClick:) forControlEvents:UIControlEventTouchUpInside];

        _changeBtn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return _changeBtn;
}

#pragma mark 文本输入框
- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.frame = CGRectMake(2*kSHInPutSpace + kSHInPutIcon_WH, self.height - kSHInPutIcon_WH - kSHInPutSpace, self.emojiBtn.x - self.changeBtn.maxX -  2*kSHInPutSpace, kSHInPutIcon_WH);
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:17];
        _textView.returnKeyType = UIReturnKeySend;
        _textView.autocorrectionType = UITextAutocorrectionTypeNo;
        _textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        //UITextView内部判断send按钮是否可以用
        _textView.enablesReturnKeyAutomatically = YES;
        
        _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _textView.layer.cornerRadius = 4;
        _textView.layer.masksToBounds = YES;
        _textView.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
        _textView.layer.borderWidth = 1;
    }
    return _textView;
}

#pragma mark 语音输入按钮
- (UIButton *)voiceBtn{
    if (!_voiceBtn) {
        _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _voiceBtn.frame = CGRectMake(self.textView.x, self.changeBtn.y, self.textView.width, kSHInPutIcon_WH);
        _voiceBtn.hidden = YES;
        //文字颜色
        [_voiceBtn setTitleColor:kRGB(76, 76, 76, 1) forState:UIControlStateNormal];
        [_voiceBtn setTitleColor:kRGB(76, 76, 76, 1) forState:UIControlStateHighlighted];
        //文字内容
        [_voiceBtn setTitle:@"按住说话" forState:UIControlStateNormal];
        [_voiceBtn setTitle:@"松开发送" forState:UIControlStateHighlighted];
        
        _voiceBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _voiceBtn.layer.cornerRadius = 4;
        _voiceBtn.layer.masksToBounds = YES;
        _voiceBtn.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
        _voiceBtn.layer.borderWidth = 1;
    }
    return _voiceBtn;
}

- (UIButton *)emojiBtn{
    if (!_emojiBtn) {
        _emojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _emojiBtn.frame = CGRectMake(self.width - 2*(kSHInPutIcon_WH + kSHInPutSpace), self.changeBtn.y, kSHInPutIcon_WH, kSHInPutIcon_WH);
        [_emojiBtn setBackgroundImage:[FileHelper imageNamed:@"chat_face.png"] forState:UIControlStateNormal];
        [_emojiBtn setBackgroundImage:[FileHelper imageNamed:@"chat_keyboard.png"] forState:UIControlStateSelected];
        [_menuBtn setBackgroundImage:[UIImage new] forState:UIControlStateHighlighted];
        [_emojiBtn addTarget:self action:@selector(emojiClick:) forControlEvents:UIControlEventTouchUpInside];
        _emojiBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    }
    return _emojiBtn;
}

#pragma mark 菜单按钮
- (UIButton *)menuBtn{
    if (!_menuBtn) {
        _menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _menuBtn.frame = CGRectMake(self.width - kSHInPutSpace - kSHInPutIcon_WH, self.changeBtn.y, kSHInPutIcon_WH, kSHInPutIcon_WH);
        [_menuBtn setBackgroundImage:[FileHelper imageNamed:@"chat_menu.png"] forState:UIControlStateNormal];
        [_menuBtn addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
        _menuBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    }
    return _menuBtn;
}


#pragma mark 监听输入框类型
- (void)setInputType:(InputViewType)inputType{
    
    if (_inputType == inputType) {
        return;
    }
    
    if (_inputType == SHInputViewType_voice && inputType == SHInputViewType_default) {
        _inputType = inputType;
        return;
    }
    
    _inputType = inputType;
    
    //初始化
    self.menuBtn.selected = NO;
    self.emojiBtn.selected = NO;
    self.changeBtn.selected = NO;
    
    self.textView.hidden  = YES;
    self.voiceBtn.hidden = YES;
//    self.emojiView.hidden = YES;
//    self.menuView.hidden = YES;
    
    self.textView.inputView = nil;
    
    [self.textView resignFirstResponder];
    
    switch (inputType) {
        case SHInputViewType_default://默认
        {
            self.textView.hidden  = NO;
            
            [UIView animateWithDuration:0.25 animations:^{
                self.y = start_maxy - self.height;
            }];
        }
            break;
        case SHInputViewType_text://文本
        {
            self.textView.hidden  = NO;
            
            [self.textView reloadInputViews];
            
            //弹出键盘
            [self.textView becomeFirstResponder];
        }
            break;
        case SHInputViewType_voice://语音
//        {
//            self.changeBtn.selected = YES;
//
//            self.voiceBtn.hidden = NO;
//
//            [UIView animateWithDuration:0.25 animations:^{
//                self.y = start_maxy - self.height;
//            }];
//            [self remakesView];
//        }
            break;
        case SHInputViewType_emotion://表情
//        {
//            self.emojiBtn.selected = YES;
//
//            self.textView.hidden  = NO;
//            self.emojiView.hidden = NO;
//
//            self.textView.inputView = self.emojiView;
//            [self.textView reloadInputViews];
//
//            //弹出键盘
//            [self.textView becomeFirstResponder];
//
//            //位置变化
////            self.emojiView.y = self.superview.height;
////            [UIView animateWithDuration:0.25 animations:^{
////
////                self.y = start_maxy - self.height - self.emojiView.height;
////                self.emojiView.y = self.maxY;
////            }];
////
////            [self textViewDidChange:self.textView];
//        }
            break;
        case SHInputViewType_menu://菜单
//        {
//            self.menuBtn.selected = YES;
//            
//            self.textView.hidden  = NO;
//            self.menuView.hidden = NO;
//            
//            //位置变化
//            self.menuView.y = self.superview.height;
//            [UIView animateWithDuration:0.25 animations:^{
//                
//                self.y = start_maxy - self.height - self.menuView.height;
//                self.menuView.y = self.maxY;
//            }];
//            [self textViewDidChange:self.textView];
//        }
            break;
        default:
            break;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        //回调
//        if ([self.delegate respondsToSelector:@selector(toolbarHeightChange)]) {
//            [self.delegate toolbarHeightChange];
//        }
    }
}

#pragma mark - 发送消息
#pragma mark 发送文字
- (void)sendMessageWithText:(NSString *)text {
    
    if ([_delegate respondsToSelector:@selector(chatMessageWithSendText:)]) {
        [_delegate chatMessageWithSendText:text];
    }
    
    self.textView.text = @"";
    [self textViewDidChange:self.textView];
}

#pragma mark - UITextViewDelegate
#pragma mark 键盘上功能点击
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {//点击了发送
        //发送文字
        [self sendMessageWithText:[SHEmotionTool getRealStrWithAtt:textView.attributedText]];
        return NO;
    }
    return YES;
}

#pragma mark 开始编辑
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    if (self.inputType == SHInputViewType_default) {
        //输入文本
        self.inputType = SHInputViewType_text;
    }
    
    [self textViewDidChange:textView];
}

#pragma mark 文字改变
- (void)textViewDidChange:(UITextView *)textView{
    
    CGFloat padding = textView.textContainer.lineFragmentPadding;
    
    CGFloat maxH = ceil(textView.font.lineHeight*3 + 2*padding);
    
    CGFloat textH = [textView.text boundingRectWithSize:CGSizeMake(textView.width - 2*padding, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:textView.font} context:nil].size.height;
    textH = ceil(MIN(maxH, textH));
    textH = ceil(MAX(textH, kSHInPutIcon_WH));
    
    if (self.textView.height != textH) {
        self.y += (self.textView.height - textH);
        self.height = textH + 2*kSHInPutSpace;
        [textView scrollRangeToVisible:NSMakeRange(textView.text.length, 1)];
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
