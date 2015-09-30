//
//  VoteViewController.m
//  DCXXSystem
//  *************投票***********
//  Created by teddy on 15/9/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "VoteViewController.h"

@interface VoteViewController ()
@property (weak, nonatomic) IBOutlet UITextView *contentTextVIew; //投票内容
@property (weak, nonatomic) IBOutlet UIButton *agreeButton; //同意按钮
@property (weak, nonatomic) IBOutlet UIButton *againstButton; //反对按钮

//投票操作
- (IBAction)voteAction:(id)sender;
@end

@implementation VoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.contentTextVIew.editable = NO;//禁止编辑
    //使内容可以顶着最上面显示
    [self.contentTextVIew setContentSize:CGSizeZero];
    self.contentTextVIew.layer.borderWidth = 1.0;
    self.contentTextVIew.layer.borderColor = [UIColor blackColor].CGColor;
    self.view.backgroundColor = BG_COLOR;
    
    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
    NSString *name = (NSString *)[[users objectForKey:USERNAME] objectForKey:@"Sname"];
    if ([name isEqualToString:@"郑毅"]) {
        
        UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:@[@"发起投票",@"投票统计"]];
        seg.momentary = YES;
        seg.segmentedControlStyle = UISegmentedControlStyleBar;
        seg.apportionsSegmentWidthsByContent = YES;
        [seg addTarget:self action:@selector(tapSegAction:) forControlEvents: UIControlEventValueChanged];
        
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:seg];
        self.navigationItem.rightBarButtonItem = left;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击segmentedControl触发的操作
- (void)tapSegAction:(UISegmentedControl *)seg
{
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    back.title = @"返回";
    self.navigationItem.backBarButtonItem = back;
    if (seg.selectedSegmentIndex == 0) {
        //发起投票
        [self performSegueWithIdentifier:@"callVote" sender:nil];
    }else{
        //投票统计
        [self performSegueWithIdentifier:@"voteCount" sender:nil];
    }
}


- (IBAction)voteAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (button.tag == 101) {
        //赞同
    }else{
        //反对
    }
    
    
}
@end
