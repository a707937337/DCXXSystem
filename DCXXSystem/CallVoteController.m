//
//  CallVoteController.m
//  DCXXSystem
//  **********发起投票************
//  Created by teddy on 15/9/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "CallVoteController.h"

@interface CallVoteController ()

@property (weak, nonatomic) IBOutlet UITextView *voteContent;
@property (weak, nonatomic) IBOutlet UIButton *comfirmButton;

//确认发起投票
- (IBAction)confirmCallVoteAction:(id)sender;

//取消键盘
- (IBAction)tapBackgroundAction:(id)sender;
@end

@implementation CallVoteController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //使UITextView中的内容顶着最上面显示
    [self.voteContent setContentSize:CGSizeZero];
    //设置内容向上偏移-50像素
    [self.voteContent setContentInset:UIEdgeInsetsMake(-50, 0, 0, 0)];
    self.voteContent.layer.borderWidth = 1.0f;
    self.voteContent.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.view.backgroundColor = BG_COLOR;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//确认发起投票
- (IBAction)confirmCallVoteAction:(id)sender
{
    if (self.voteContent.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"对于投票的内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
}

//取消键盘
- (IBAction)tapBackgroundAction:(id)sender
{
    [self.voteContent resignFirstResponder];
}

@end
