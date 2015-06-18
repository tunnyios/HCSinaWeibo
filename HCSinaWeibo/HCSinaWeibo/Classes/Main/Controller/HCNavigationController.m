//
//  HCNavigationController.m
//  HCSinaWeibo
//
//  Created by tunny on 15/6/17.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "HCNavigationController.h"

@interface HCNavigationController ()

@end

@implementation HCNavigationController

//第一次使用这个类，或者这个类的子类的时候调用
+ (void)initialize
{
    // 设置整个项目所有item的主题样式
    //取得所有的BarButtonItem
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    // 设置普通状态
    NSDictionary *norFontDict = @{NSFontAttributeName : [UIFont systemFontOfSize:13],
                                  NSForegroundColorAttributeName : [UIColor orangeColor]
                                  };
    [item setTitleTextAttributes:norFontDict forState:UIControlStateNormal];
    
    
    // 设置不可用状态
    NSDictionary *disFontDict = @{NSFontAttributeName : [UIFont systemFontOfSize:13],
                                  NSForegroundColorAttributeName : [UIColor grayColor]
                                  };
    [item setTitleTextAttributes:disFontDict forState:UIControlStateDisabled];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//拦截push方法进行重写，使所有的导航条的item图标进行统一
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (1 == self.viewControllers.count) {   //第2个push进来的控制器
        
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:nil heighImage:nil title:[self.viewControllers[0] navigationItem].title];
        
        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(more) image:@"navigationbar_more" heighImage:@"navigationbar_more_highlighted" title:nil];
    } else if (self.viewControllers.count > 1) {   //其他push进来的控制器
        
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"navigationbar_back" heighImage:@"navigationbar_back_highlighted" title:nil];
        
        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(more) image:@"navigationbar_more" heighImage:@"navigationbar_more_highlighted" title:nil];
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
    HCLog(@"pop...back");
}

- (void)more
{
    HCLog(@"push...more");
}

@end
