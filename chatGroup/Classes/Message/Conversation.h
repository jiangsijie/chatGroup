//
//  Conversation.h
//  chatGroup
//
//  Created by sijie.jiang on 2020/3/30.
//  Copyright © 2020 sijie.jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>

NS_ASSUME_NONNULL_BEGIN

@interface Conversation : NSObject
@property (nonatomic, strong) AVUser *takeTo;
@property (nonatomic, strong) NSMutableArray *messageList;
@end

NS_ASSUME_NONNULL_END
