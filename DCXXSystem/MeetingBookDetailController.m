//
//  MeetingBookDetailController.m
//  DCXXSystem
//
//  Created by teddy on 15/8/13.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "MeetingBookDetailController.h"
#import "MeetingCell.h"
#import "SVProgressHUD.h"
#import "RequestObject.h"
#import "HistoryViewController.h"

@interface MeetingBookDetailController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSArray *_list;//数据源
    UITableView *_table;
}
@end

@implementation MeetingBookDetailController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        [RequestObject cancelRequest];
        [SVProgressHUD dismiss];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = [self.dic objectForKey:@"Sname"];
    self.view.backgroundColor = BG_COLOR;
    
    _table = [[UITableView alloc] initWithFrame:(CGRect){0,0,kScreen_Width,kScreen_height} style:UITableViewStyleGrouped];
    _table.delegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    
    [self initBar];
    
    [self requestHttp];
}

- (void)initBar
{
    UIButton *update_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    update_btn.frame = (CGRect){0,0,60,20};
    update_btn.titleLabel.font = [UIFont systemFontOfSize:14];
    update_btn.titleLabel.textColor = [UIColor whiteColor];
    [update_btn setTitle:@"预定情况" forState:UIControlStateNormal];
    [update_btn addTarget:self action:@selector(bookedCountAction) forControlEvents:UIControlEventTouchUpInside];
    update_btn.layer.borderColor = [UIColor whiteColor].CGColor;
    update_btn.layer.borderWidth = 0.5;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:update_btn];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//我的预定
- (void)bookedCountAction
{
    HistoryViewController *history = [[HistoryViewController alloc] init];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    back.title = @"返回";
    self.navigationItem.backBarButtonItem = back;
    [self.navigationController pushViewController:history animated:YES];
}

#pragma mark - Private Method
- (void)requestHttp
{
    NSDictionary *user = [self getUser];
    NSString *result = [NSString stringWithFormat:@"%@$%@",[user objectForKey:@"Sid"],[self.dic objectForKey:@"Sid"]];
    [SVProgressHUD showWithStatus:@"加载中.."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        if ([RequestObject fetchWithType:@"GetMyDeptMbook" withResults:result]) {
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
    [SVProgressHUD dismissWithSuccess:@"加载成功"];
    dispatch_async(dispatch_get_main_queue(), ^{
        _list = [RequestObject requestData];
        if (_list.count != 0) {
            [_table reloadData];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求的网络数据为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    });
}

//获取用户
- (NSDictionary *)getUser
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *user = [defaults objectForKey:USERNAME];
    return user;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    MeetingCell *cell = (MeetingCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = (MeetingCell *)[[[NSBundle mainBundle] loadNibNamed:@"MeetingCell" owner:nil options:nil] lastObject];
        
        for (NSObject *object in cell.contentView.subviews) {
            if ([object isKindOfClass:[UIButton class]]) {
                //添加事件
                UIButton *button = (UIButton *)object;
                [button addTarget:self action:@selector(bookMeetingAction:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    NSDictionary *dic = _list[indexPath.row];
    cell.dateLabel.text = [NSString stringWithFormat:@"%@ %@ %@",[dic objectForKey:@"Day"],
                                                                 [dic objectForKey:@"Weekday"],
                                                                 [dic objectForKey:@"Sap"]];
    if ([[dic objectForKey:@"Szt"] rangeOfString:@"true"].length > 0) {
        //已经预定
        cell.bookbtn.backgroundColor = [UIColor lightGrayColor];
        cell.bookbtn.userInteractionEnabled = NO;//不可操作
        [cell.bookbtn setTitle:@"已预定" forState:UIControlStateNormal];
    }else{
        [cell.bookbtn setTitle:@"可预定" forState:UIControlStateNormal];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)bookMeetingAction:(UIButton *)btn
{
    //也可以通过设置button的tag值来确定是哪一行
    UITableViewCell *cell = (UITableViewCell *)btn.superview.superview;
    NSIndexPath *path = [_table indexPathForCell:cell];
    NSDictionary *dic = _list[[path row]];
    
    //http://115.236.2.245:38019/DataDc.ashx?t=IntMBooking&results=2004$01$2015-08-17$0$0
    NSDictionary *user = [self getUser];
    NSString *sap = nil;//上下午
    if ([[dic objectForKey:@"Sap"] isEqualToString:@"上午"]) {
        sap = @"0"; //上午
    }else{
        sap = @"1"; //下午
    }
    NSString *result = [NSString stringWithFormat:@"%@$%@$%@$%@",[user objectForKey:@"Sid"],[dic objectForKey:@"Mid"],[dic objectForKey:@"Day"],sap];
    [self bookMeetingRoom:result];
}

#pragma mark - BookRoomAction
//预定会议室的网络服务
- (void)bookMeetingRoom:(NSString *)result
{
    [SVProgressHUD showWithStatus:@"加载中.."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if ([RequestObject fetchWithType:@"IntMBooking" withResults:result]) {
            [self BookResult];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismissWithError:@"加载失败"];
            });
        }
    });
}

- (void)BookResult
{
    [SVProgressHUD dismissWithSuccess:@"操作成功"];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *list = [RequestObject requestData];
        if (list.count != 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[list[0] objectForKey:@"result"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    });
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //重新刷新状态
        [self requestHttp];
    }
}

@end
