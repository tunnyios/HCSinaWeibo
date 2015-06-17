//
//  TestTwoViewController.m
//  HCSinaWeibo
//
//  Created by tunny on 15/6/17.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "TestTwoViewController.h"
#import "TestThreeViewController.h"

@interface TestTwoViewController ()

@end

@implementation TestTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    TestThreeViewController *threeVc = [[TestThreeViewController alloc] init];
    threeVc.view.backgroundColor = [UIColor colorWithRandom];
    [self.navigationController pushViewController:threeVc animated:YES];
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
