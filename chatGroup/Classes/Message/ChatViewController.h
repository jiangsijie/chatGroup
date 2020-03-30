//
//  ChatViewController.h
//  chatGroup
//
//  Created by Tiancheng Chen  on 2020/3/25.
//  Copyright © 2020 sijie.jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *groupMember;
@property (strong, nonatomic) NSString *conversationId;
@end

NS_ASSUME_NONNULL_END
