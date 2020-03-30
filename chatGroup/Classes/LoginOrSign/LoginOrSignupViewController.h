//
//  LoginOrSignupViewController.h
//  chatGroup
//
//  Created by sijie.jiang on 2020/3/23.
//  Copyright © 2020 sijie.jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudIM/AVOSCloudIM.h>

NS_ASSUME_NONNULL_BEGIN

NSMutableArray *gMessageList;
AVIMClient *gAVIMCient;
BOOL loginSuccessed;

@interface LoginOrSignupViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
