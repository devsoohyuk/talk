//
//  MyBubbleTableViewCell.h
//  Talk
//
//  Created by 홍수혁 on 2019/11/28.
//  Copyright © 2019 홍수혁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyBubbleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *textView;
@property (weak, nonatomic) IBOutlet UILabel *textBody;

@end

NS_ASSUME_NONNULL_END
