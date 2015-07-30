//
//  ViewController.m
//  DCXXSystem
//
//  Created by teddy on 15/7/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "ViewController.h"
#import "PeopleSelectController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *reserve_btn;
@property (weak, nonatomic) IBOutlet UIButton *count_btn;
- (IBAction)selectPeopleAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;


@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *user = [defaults objectForKey:USERNAME];
    NSString *name = (NSString *)[user objectForKey:@"Sname"];
    if ([name length] == 0) {
        self.userLabel.text = @"未知用户";
    }else{
        self.userLabel.text = name;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
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
@end
