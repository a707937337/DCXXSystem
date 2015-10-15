//
//  VoteCountController.m
//  DCXXSystem
//  ***********投票统计***********
//  Created by teddy on 15/9/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "VoteCountController.h"
#import "RequestObject.h"
#import "SVProgressHUD.h"
#import "VoteCountCell.h"

@interface VoteCountController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_listData;//数据源
}
@property (weak, nonatomic) IBOutlet UITableView *countTableView;

@end

@implementation VoteCountController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.countTableView.delegate = self;
    self.countTableView.dataSource = self;
    self.countTableView.backgroundColor = BG_COLOR;

    
    [self callRequestAction];
    
}

- (void)callRequestAction
{
    [SVProgressHUD showWithStatus:@"上传中..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([RequestObject fetchWithType:@"GetVoteCount" withResults:@""]) {
            [self updateUI];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismissWithError:@"加载失败"];
            });
        }
    });
}

- (void)updateUI
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *list = [RequestObject requestData];
        if (list.count != 0) {
            [SVProgressHUD dismissWithSuccess:@"加载成功"];
            _listData = [NSMutableArray arrayWithArray:list];
            [self.countTableView reloadData];
        }else{
            [SVProgressHUD dismissWithError:@"加载失败"];
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _listData.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

   VoteCountCell *cell = (VoteCountCell *)[[[NSBundle mainBundle] loadNibNamed:@"VoteCount" owner:nil options:nil] lastObject];
    [cell.closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.closeBtn.tag = indexPath.section;
    [cell upgateCell:_listData[indexPath.section]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)closeAction:(UIButton *)btn
{
    NSDictionary *dict = _listData[btn.tag];
    [SVProgressHUD showWithStatus:@"正在关闭"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([RequestObject fetchWithType:@"ShutVote" withResults:[dict objectForKey:@"Tid"]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray *list = [RequestObject requestData];
                if (list.count != 0) {
                    NSDictionary *dict = [list objectAtIndex:0];
                    if ([[dict objectForKey:@"success"] isEqualToString:@"true"]) {
                        [btn setBackgroundImage:[UIImage imageNamed:@"close_selected"] forState:UIControlStateNormal];
                        [SVProgressHUD dismissWithSuccess:[dict objectForKey:@"result"]];
                        btn.userInteractionEnabled = NO;
                    }else{
                        [SVProgressHUD dismissWithError:[dict objectForKey:@"result"]];
                    }
                }
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismissWithError:@"关闭失败"];
            });
        }
    });
}

/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.countTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [_listData removeObjectAtIndex:indexPath.section];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
 */

@end
