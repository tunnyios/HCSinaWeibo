//
//  HCHomeTableViewController.m
//  HCSinaWeibo
//
//  Created by suhongcheng on 15/6/16.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "HCHomeTableViewController.h"
#import "TestOneViewController.h"
#import "HCNewTypeButtonView.h"
#import "HCDropDownMenuView.h"

@interface HCHomeTableViewController ()

@end

@implementation HCHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //左边图标
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(leftItemClick:) image:@"navigationbar_friendsearch" heighImage:@"navigationbar_friendsearch_highlighted" title:nil];
    
    //右边图标
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightItemClick:) image:@"navigationbar_pop" heighImage:@"navigationbar_pop_highlighted" title:nil];
    
    //中间view
    HCNewTypeButtonView *titleBtn = [HCNewTypeButtonView buttonWithTitle:@"首页" icon:@"timeline_icon_more_highlighted" heighIcon:@"timeline_icon_more"];
    //监听按钮点击，弹出下拉菜单
    [titleBtn addTarget:self action:@selector(dropDownMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = titleBtn;
}

/** 点击首页的下拉菜单 */
- (void)dropDownMenu:(HCNewTypeButtonView *)button
{
    //创建下拉菜单
    HCDropDownMenuView *dropMenu = [HCDropDownMenuView dropDownMenu];
    //设置下拉菜单内容
    UITableViewController *contentController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    contentController.view.frame = CGRectMake(0, 0, 200, 200);
    dropMenu.contentController = contentController;
    //显示
    [dropMenu showFromView:button];
}

- (void)leftItemClick:(UIButton *)btn
{
    TestOneViewController *oneVc = [[TestOneViewController alloc] init];
    oneVc.view.backgroundColor = [UIColor colorWithRandom];
    [self.navigationController pushViewController:oneVc animated:YES];
}

- (void)rightItemClick:(UIButton *)btn
{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
