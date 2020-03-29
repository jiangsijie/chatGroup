//
//  ActivityIndicatorView.h
//  chatGroup
//
//  Created by Tiancheng Chen  on 2020/3/28.
//  Copyright © 2020 sijie.jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageType.h"

NS_ASSUME_NONNULL_BEGIN

@interface ActivityIndicatorView : UIButton

@property(nonatomic, assign) SendMessageStatus messageState;
//失败按钮
@property (nonatomic, strong) UIButton *failBtn;
//菊花图标
@property (nonatomic, strong) UIActivityIndicatorView *activity;

@end

NS_ASSUME_NONNULL_END
