//
//  ViewController.m
//  DCXXSystem
//
//  Created by teddy on 15/7/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "ViewController.h"
#import "PeopleSelectController.h"
#import "RestaurantViewController.h"

@interface ViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *reserve_btn;
@property (weak, nonatomic) IBOutlet UIButton *count_btn;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;

@property (weak, nonatomic) IBOutlet UIView *bgView;
- (IBAction)selectPeopleAction:(id)sender;
- (IBAction)bookAction:(id)sender;


@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSDictionary *user = [self getUserName];
    NSString *name = (NSString *)[user objectForKey:@"Sname"];
    if ([name length] == 0) {
        self.userLabel.text = @"未知用户";
    }else{
        self.userLabel.text = name;
    }
    
}

//获取保存在本地的信息
- (NSDictionary *)getUserName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *user = [defaults objectForKey:USERNAME];
    return user;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //设置UINavigationbar
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:235/255.0 green:133/255.0 blue:50/255.0 alpha:1];//背景颜色
   // [self insertBarGradient];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];//返回按钮的颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:19]}];//设置标题的样式
    self.navigationController.navigationBar.translucent = YES;//不模糊
    
  //  self.bgView.backgroundColor =  [UIColor colorWithRed:234/255.0 green:86/255.0 blue:14/255.0 alpha:0.8];
    self.bgView.layer.borderColor = [UIColor whiteColor].CGColor;
   // self.bgView.layer.borderWidth = 1;
    
    self.userLabel.font = [UIFont boldSystemFontOfSize:17];
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    
    [self insertColorGradient];
    
}

- (void)insertColorGradient
{
    UIColor *colorOne = [UIColor colorWithRed:234/255.0 green:86/255.0 blue:14/255.0 alpha:0.8];
    
    UIColor *colorTwo = [UIColor colorWithRed:234/255.0 green:86/255.0 blue:14/255.0 alpha:1.0];
    
    NSArray *colors = @[(id)colorOne.CGColor,(id)colorTwo.CGColor];
    
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    NSArray *locations = @[stopOne,stopTwo];
    
    CAGradientLayer *headersLayers = [CAGradientLayer layer];
    headersLayers.colors = colors;
    headersLayers.locations = locations;
    headersLayers.frame = self.bgView.bounds;
    [self.bgView.layer insertSublayer:headersLayers atIndex:0];
}

- (void)insertBarGradient
{
    UIColor *colorOne = [UIColor colorWithRed:234/255.0 green:86/255.0 blue:14/255.0 alpha:0.7];
    
    UIColor *colorTwo = [UIColor colorWithRed:234/255.0 green:86/255.0 blue:14/255.0 alpha:0.8];
    
    NSArray *colors = @[(id)colorOne.CGColor,(id)colorTwo.CGColor];
    
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    NSArray *locations = @[stopOne,stopTwo];
    
    CAGradientLayer *headersLayers = [CAGradientLayer layer];
    headersLayers.colors = colors;
    headersLayers.locations = locations;
    headersLayers.frame = self.navigationController.navigationBar.bounds;
    [self.navigationController.navigationBar.layer insertSublayer:headersLayers atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)selectPeopleAction:(id)sender {
    //选择人员信息
    PeopleSelectController *people = [[PeopleSelectController alloc] init];
    [self.navigationController pushViewController:people animated:YES];
}

//点餐
- (IBAction)bookAction:(id)sender
{
    NSDictionary *user = [self getUserName];
    NSString *name = (NSString *)[user objectForKey:@"Sname"];
    NSString *Sid = (NSString *)[user objectForKey:@"Sid"];
    if ([name length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先选择订餐人员" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    //[self.navigationController performSegueWithIdentifier:@"bookPush" sender:nil];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RestaurantViewController *restaurant = [story instantiateViewControllerWithIdentifier:@"BookController"];
    restaurant.personId = Sid;//将人员编号传递进去
    [self.navigationController pushViewController:restaurant animated:YES];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //直接进入组织架构选人
        [self performSelector:@selector(selectPeopleAction:) withObject:nil];
    }
}
@end
