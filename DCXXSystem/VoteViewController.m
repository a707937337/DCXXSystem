//
//  VoteViewController.m
//  DCXXSystem
//  *************投票***********
//  Created by teddy on 15/9/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "VoteViewController.h"
#import "RequestObject.h"
#import "SVProgressHUD.h"
#import "VoteCell.h"

@interface VoteViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSArray *_list;//数据源
    NSString *_userId;//用户id
    NSString *_selectItem;//反对或者赞成
    NSString *_selectTid;//选择的tid
    BOOL _isVote;//是否投票
}

@property (weak, nonatomic) IBOutlet UITableView *voteTable;
@end

@implementation VoteViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //加载网络
    [self getWebDataWithRequestType:@"GetVote" results:@""];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.voteTable.delegate = self;
    self.voteTable.dataSource = self;
    self.voteTable.backgroundColor = BG_COLOR;
    self.view.backgroundColor = BG_COLOR;
    
    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [users objectForKey:USERNAME];
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

#pragma mark - WebDataAction
- (void)getWebDataWithRequestType:(NSString *)type results:(NSString *)result
{
    [SVProgressHUD showWithStatus:@"加载中"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([RequestObject fetchWithType:type withResults:result]) {
            //更新主界面
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
            if (!_isVote) {
                [SVProgressHUD dismissWithSuccess:@"加载成功"];
                _list = list;
                [self.voteTable reloadData];
            }else{
                //投票返回
                _isVote = NO;
                [SVProgressHUD dismissWithSuccess:[list[0] objectForKey:@"result"]];

            }

        }else{
            [SVProgressHUD dismissWithError:@"加载失败"];
        }
    });
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VoteCell *cell = (VoteCell *)[[[NSBundle mainBundle] loadNibNamed:@"VoteCell" owner:nil options:nil] lastObject];
    //添加投票事件
    [cell.approvalBtn addTarget:self action:@selector(voteAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.aginstBtn addTarget:self action:@selector(voteAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.approvalBtn.tag = indexPath.section;
    cell.aginstBtn.tag = indexPath.section;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict = _list[indexPath.section];
    [cell setContentName:dict];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 30)];
    return view;
}

- (void)voteAction:(UIButton *)btn
{
    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
   _userId = (NSString *) [[users objectForKey:USERNAME] objectForKey:@"Sid"];
    NSString *message = nil;
    if ([btn.currentTitle isEqualToString:@"赞成"]) {
        //点击了赞成按钮
        NSLog(@"赞同");
        _selectItem = @"1";
       message = [NSString stringWithFormat:@"您要对 %@ 投赞同票",[_list[btn.tag] objectForKey:@"Title"]];
    }else{
        //点击了反对按钮
         NSLog(@"反对");
        _selectItem = @"0";
       message = [NSString stringWithFormat:@"您要对 %@ 投反对票",[_list[btn.tag] objectForKey:@"Title"]];
    }
   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
    _selectTid= [_list[btn.tag] objectForKey:@"Tid"];

    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btn.userInteractionEnabled = NO;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //确定投票
        NSString *result = [NSString stringWithFormat:@"%@$%@$%@",_userId,_selectTid,_selectItem];
        _isVote = YES;
        [self getWebDataWithRequestType:@"IntVote" results:result];
    }
}

@end
