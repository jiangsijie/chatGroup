//
//  MessageContentView.h
//  chatGroup
//
//  Created by Tiancheng Chen  on 2020/3/28.
//  Copyright © 2020 sijie.jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"
#import "ActivityIndicatorView.h"
#import "MessageTextView.h"
NS_ASSUME_NONNULL_BEGIN
@class ActivityIndicatorView;
@interface MessageContentView : UIButton

// text
@property (nonatomic, retain) MessageTextView *textView;

//数据源
@property (nonatomic, retain) Message *message;

@end

NS_ASSUME_NONNULL_END
