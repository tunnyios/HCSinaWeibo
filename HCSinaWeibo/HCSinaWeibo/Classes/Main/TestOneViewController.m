//
//  TestOneViewController.m
//  HCSinaWeibo
//
//  Created by tunny on 15/6/17.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "TestOneViewController.h"
#import "TestTwoViewController.h"

@interface TestOneViewController ()

@end

@implementation TestOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:nil action:nil image:@"navigationbar_back" heighImage:@"navigationbar_back_highlighted" title:nil];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:nil action:nil image:@"navigationbar_more" heighImage:@"navigationbar_pop_highlighted" title:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    TestTwoViewController *twoVc = [[TestTwoViewController alloc] init];
    twoVc.view.backgroundColor = [UIColor colorWithRandom];
    [self.navigationController pushViewController:twoVc animated:YES];
    NSLog(@"---%@---", self.navigationController);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
