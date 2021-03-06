//
//  MessageTableViewCell.h
//  chatGroup
//
//  Created by sijie.jiang on 2020/3/30.
//  Copyright © 2020 sijie.jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *chatWithWhoLabel;
@property (weak, nonatomic) IBOutlet UILabel *latestMessageLabel;

@end

NS_ASSUME_NONNULL_END
