//
//  MessageTextView.m
//  chatGroup
//
//  Created by Tiancheng Chen  on 2020/3/28.
//  Copyright © 2020 sijie.jiang. All rights reserved.
//

#import "MessageTextView.h"


@interface MessageTextView()<UITextViewDelegate>

@end

@implementation MessageTextView

- (instancetype)init
{
    self = [super init];
    if (self) {
        //配置
        [self setup];
    }
    return self;
}

#pragma mark - 配置
- (void)setup{
    
    CGFloat padding = self.textContainer.lineFragmentPadding;
    
    self.editable = NO;
    self.scrollEnabled = NO;
    self.textContainerInset = UIEdgeInsetsMake(0, -padding, 0, -padding);
    self.dataDetectorTypes = UIDataDetectorTypePhoneNumber | UIDataDetectorTypeLink;
    self.delegate = self;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(nonnull NSTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction{
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
