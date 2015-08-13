//
//  HistoryCell.h
//  DCXXSystem
//
//  Created by teddy on 15/8/13.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *meetingRoomName;
@property (weak, nonatomic) IBOutlet UILabel *samlabel;
@property (weak, nonatomic) IBOutlet UILabel *spmLabel;

@end
