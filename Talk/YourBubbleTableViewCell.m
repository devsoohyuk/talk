//
//  YourBubbleTableViewCell.m
//  Talk
//
//  Created by 홍수혁 on 2019/11/28.
//  Copyright © 2019 홍수혁. All rights reserved.
//

#import "YourBubbleTableViewCell.h"

@implementation YourBubbleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.userImg.layer.cornerRadius = 30/2;
    self.textView.layer.cornerRadius = 10;
    self.textBody.numberOfLines = 0;
    self.textBody.lineBreakMode = NSLineBreakByCharWrapping;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
