//
//  VoteCell.m
//  DCXXSystem
//
//  Created by teddy on 15/10/15.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "VoteCell.h"

@implementation VoteCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContentName:(NSDictionary *)dict
{
    self.contentVIew.editable = NO;
    self.layer.cornerRadius = 10.0;
    self.layer.shadowOffset = CGSizeMake(3, 3);//向右偏移3，向下偏移3
    self.layer.shadowOpacity = 0.8;//默认是0
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    [self.contentVIew setContentSize:CGSizeZero];
    self.backgroundColor = [UIColor whiteColor];
    
    self.dateLabel.text = [dict objectForKey:@"Sdatetime"];
    self.contentVIew.text = [dict objectForKey:@"Title"];
}

@end
