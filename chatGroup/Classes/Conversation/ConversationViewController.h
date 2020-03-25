//
//  ConversationViewController.h
//  chatGroup
//
//  Created by sijie.jiang on 2020/3/25.
//  Copyright © 2020 sijie.jiang. All rights reserved.
//

#import "ViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudIM/AVOSCloudIM.h>
NS_ASSUME_NONNULL_BEGIN

@interface ConversationViewController : ViewController
@property (strong, nonatomic) AVUser *talkToUser;
@end

NS_ASSUME_NONNULL_END
