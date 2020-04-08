//
//  Group.m
//  chatGroup
//
//  Created by Tiancheng Chen  on 2020/3/31.
//  Copyright © 2020 sijie.jiang. All rights reserved.
//

#import "Group.h"

@implementation Group
@dynamic conversationId;
@dynamic groupName;
@dynamic members;
+ (NSString *)parseClassName {
    return @"Group";
}

@end
