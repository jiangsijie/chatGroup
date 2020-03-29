//
//  FileHelper.m
//  chatGroup
//
//  Created by Tiancheng Chen  on 2020/3/28.
//  Copyright © 2020 sijie.jiang. All rights reserved.
//

#import "FileHelper.h"
#import "MessageHeader.h"

@implementation FileHelper

//获取图片
+ (UIImage *)imageNamed:(NSString *)name{
    
    return [UIImage imageNamed:[NSString stringWithFormat:@"ChatGroup.bundle/%@",name]];
}
@end
