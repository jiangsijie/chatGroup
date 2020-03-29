//
//  ActivityIndicatorView.m
//  chatGroup
//
//  Created by Tiancheng Chen  on 2020/3/28.
//  Copyright © 2020 sijie.jiang. All rights reserved.
//

#import "ActivityIndicatorView.h"
#import "FileHelper.h"
@implementation ActivityIndicatorView

- (UIButton *) failBtn {
    if (!_failBtn) {
        _failBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _failBtn.userInteractionEnabled = NO;
        [_failBtn setBackgroundImage:[FileHelper imageNamed:@"message_fail.png"] forState:0];
        [self addSubview:_failBtn];
    }
    return _failBtn;
}

- (UIActivityIndicatorView *)activity{
    if (!_failBtn) {
        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
        [self addSubview:_activity];
    }
    return _activity;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    self.failBtn.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.activity.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);

}

- (void)setMessageState:(SendMessageStatus)messageState{
    _messageState = messageState;
    
    self.failBtn.hidden = YES;
    self.activity.hidden = YES;
    [self.activity stopAnimating];
    
    switch (messageState) {
        case SHSendMessageType_Delivering:
        {
            self.hidden = NO;
            self.activity.hidden = NO;
            [self.activity startAnimating];
        }
            break;
        case SHSendMessageType_Failed:
        {
            self.hidden = NO;
            self.activity.hidden = NO;
        }
            break;
        case SHSendMessageType_Successed:
        {
            self.hidden = YES;
        }
            break;
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
