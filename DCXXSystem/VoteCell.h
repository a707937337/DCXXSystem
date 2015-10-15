//
//  VoteCell.h
//  DCXXSystem
//
//  Created by teddy on 15/10/15.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoteCell : UITableViewCell
//时间标签
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
//内容
@property (weak, nonatomic) IBOutlet UITextView *contentVIew;
//赞同按钮
@property (weak, nonatomic) IBOutlet UIButton *approvalBtn;
//反对按钮
@property (weak, nonatomic) IBOutlet UIButton *aginstBtn;
//状态标签
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

- (void)setContentName:(NSDictionary *)dict;

@end
