//
//  Group.h
//  chatGroup
//
//  Created by Tiancheng Chen  on 2020/3/31.
//  Copyright © 2020 sijie.jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>

NS_ASSUME_NONNULL_BEGIN

@interface Group : AVObject<AVSubclassing>
@property (strong, nonatomic) NSString *conversationId;
@property (strong, nonatomic) NSString *groupName;
@property (strong, nonatomic) NSMutableArray *members;
@end

NS_ASSUME_NONNULL_END
