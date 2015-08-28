//
//  BookDetailController.m
//  DCXXSystem
//
//  Created by teddy on 15/8/26.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "BookDetailController.h"
#import "SelectTimeCell.h"
#import "LIstViewController.h"

@interface BookDetailController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
}

@end

@implementation BookDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = BG_COLOR;
    self.title = @"预定选项";
    [self initBar];
    
    _tableView = [[UITableView alloc] initWithFrame:(CGRect){0,0,kScreen_Width,(kScreen_height/3)*2} style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)initBar
{
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    back = @"返回";
    self.navigationItem.backBarButtonItem= back;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;//开始时间和结束时间
            break;
        case 1:
            return 1; //已预约时间段
            break;
        case 2:
            return 1;//是否需要投影仪
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            SelectTimeCell *cell = (SelectTimeCell *)[[[NSBundle mainBundle] loadNibNamed:@"selectTimeCell" owner:nil options:nil] lastObject];
            if (indexPath.row == 0) {
                cell.ttitleLabel.text = @"开始时间";
                cell.valueLabel.text = @"8:30";
            }else{
                cell.ttitleLabel.text = @"结束时间";
                cell.valueLabel.text = @"9:00";
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
            break;
        case 1:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.text = @"已经预约时段";
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
            break;
        case 2:
        {
            SelectTimeCell *cell = (SelectTimeCell *)[[[NSBundle mainBundle] loadNibNamed:@"selectTimeCell" owner:nil options:nil] lastObject];
            cell.ttitleLabel.text = @"是否需要投影仪";
            cell.valueLabel.text = @"不需要";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            LIstViewController *list = [[LIstViewController alloc] init];
            list.index = 1;
            [self.navigationController pushViewController:list animated:YES];
        }
            break;
        case 1:
        {
            LIstViewController *list = [[LIstViewController alloc] init];
            list.index = 1;
            [self.navigationController pushViewController:list animated:YES];
        }
            break;
        case 2:
        {
            
        }
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
