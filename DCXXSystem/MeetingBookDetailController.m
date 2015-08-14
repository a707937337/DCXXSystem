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

@interface MeetingBookDetailController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSArray *_list;//数据源
    UITableView *_table;
    NSString *_results; //上传的参数
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
    
    
    [self requestHttp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                button.tag = indexPath.row;//设置tag值
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
//    MeetingCell *cell = (MeetingCell *)btn.superview.superview;
//    NSIndexPath *path = [_table indexPathForCell:cell];
    NSDictionary *dic = _list[btn.tag];
    
    //http://115.236.2.245:38019/DataDc.ashx?t=IntMBooking&results=2004$01$2015-08-17$0$0
    NSDictionary *user = [self getUser];
    NSString *sap = nil;//上下午
    if ([[dic objectForKey:@"Sap"] isEqualToString:@"上午"]) {
        sap = @"0"; //上午
    }else{
        sap = @"1"; //下午
    }
    _results = [NSString stringWithFormat:@"%@$%@$%@$%@",[user objectForKey:@"Sid"],[dic objectForKey:@"Mid"],[dic objectForKey:@"Day"],sap];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择是否需要投影仪" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"大投影仪", @"小投影仪",@"不需要，只预定",nil];
    [alert show];
    //[self bookMeetingRoom:result];
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
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *list = [RequestObject requestData];
        NSDictionary *dic = [list lastObject];
        if (list.count != 0) {
            if ([[dic objectForKey:@"success"] isEqualToString:@"true"]) {
                //成功直接刷新界面
               // [SVProgressHUD dismissWithSuccess:@"预约成功"];
                [self requestHttp];
                //
            }else{
                [SVProgressHUD dismissWithError:@"预定失败"];
            }
        }
    });
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *machine = nil;
    if (buttonIndex == 0) {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        return;
    }else
    if (buttonIndex == 1){
        //大投影
        machine = @"1";//表示大投影仪
    }else if (buttonIndex == 2){
        //小投影
        machine = @"2";//表示小投影仪
    }else{
        //不需要
        machine = @"0";//代表不用投影仪
    }
    NSString *res = [NSString stringWithFormat:@"%@$%@",_results,machine];
    //预定
    [self bookMeetingRoom:res];
}

@end
