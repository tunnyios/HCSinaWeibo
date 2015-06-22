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
#import "HCDropDownRightMenuView.h"
#import "AFNetworking.h"
#import "HCAccountTools.h"
#import "HCStatus.h"
#import "HCUser.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "HCLoadFooterView.h"
#import "MJRefresh.h"
#import "HCStatusTableViewCell.h"
#import "HCStatusFrames.h"


typedef enum : NSUInteger {
    HCSendRequestTypeDown,  //下拉刷新
    HCSendRequestTypeUp,    //上拉刷新
    
} HCSendRequestType;

@interface HCHomeTableViewController ()
/**
 *  微博数组（里面放的都是HCStatusFrames模型，一个HCStatusFrames对象就代表一条微博）
 */
@property (nonatomic, strong) NSMutableArray *statusFramesList;

@end

@implementation HCHomeTableViewController

- (NSMutableArray *)statusFramesList
{
    if (_statusFramesList == nil) {
        _statusFramesList = [NSMutableArray array];
    }
    
    return _statusFramesList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HCAccount *account = [HCAccountTools account];
    
    //1. 设置home控制器的导航栏item
    [self setupNavItemWithAccount:account];
    
    //2. 发送请求获取用户信息(用户昵称)
    [self setUserNameWithAccount:account];
    
    //3. 设置下拉刷新
    [self dropDownRefreshStatus];
    
    //4. 设置上拉刷新
    [self dropUpRefreshStatus];
}

#pragma mark - 上拉刷新
/**
 *  实现上拉刷新(使用MJRefresh框架)
 */
- (void)dropUpRefreshStatus
{
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}


- (void)loadMoreData
{
    [self sendRequestForDataWithType:HCSendRequestTypeUp];
    
    [self.tableView.footer endRefreshing];
}

#pragma mark - 下拉刷新
/**
 *  实现下拉刷新(使用MJRefresh框架)
 */
- (void)dropDownRefreshStatus
{
    //添加刷新控件
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 马上进入刷新状态
    [self.tableView.header beginRefreshing];
}

/**
 *  下拉刷新控件的监听事件
 *  下拉刷新获取数据
 *  @param control
 */
- (void)loadNewData
{
    //1. 发送请求获取数据
    [self sendRequestForDataWithType:HCSendRequestTypeDown];
    
    //2. 关闭刷新
    [self.tableView.header endRefreshing];
}

#pragma mark 发送请求，获取微博数据
/**
 *  向服务器发送请求，获取微博数据
 *
 *  @param type 上拉刷新/下拉刷新
 */
- (void)sendRequestForDataWithType:(HCSendRequestType)type
{
    //1. 发送请求
    HCAccount *account = [HCAccountTools account];
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"access_token"] = account.access_token;

    if (HCSendRequestTypeDown == type) {
        NSString *since_id = [[self.statusFramesList firstObject] status].idstr;
        dict[@"since_id"] = since_id ? since_id : @"0";
    } else {
        NSString *max_id = [[self.statusFramesList lastObject] status].idstr;
        dict[@"max_id"] = max_id ? max_id : @"0";
    }
    
    [mgr GET:@"https://api.weibo.com/2/statuses/home_timeline.json" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"---%@--", responseObject);
        
        //将微博字典数组－－－>微博模型数组
        NSArray *newStatuses = [HCStatus objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        
        //将status模型转换成statusFrames模型
        NSArray *newStatusFrames = [self statusFramesWihtStatus:newStatuses];
        
        //将新数据添加到微博数组中
        if (HCSendRequestTypeDown == type) {
            //插入
            NSRange range = NSMakeRange(0, newStatusFrames.count);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            [self.statusFramesList insertObjects:newStatusFrames atIndexes:indexSet];
        } else {
            //追加
            [self.statusFramesList addObjectsFromArray:newStatusFrames];
        }
        
        //添加view显示此次刷新更新了多少条信息
        [self showNewStatusCount:(unsigned long)newStatusFrames.count];
        
        //刷新数据
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"请求失败.--%@--", error);
    }];
}

/**
 *  将status模型转换成statusFrames模型
 */
- (NSArray *)statusFramesWihtStatus:(NSArray *)newStatuses
{
    NSMutableArray *newStatusFrames = [NSMutableArray array];
    //将status模型转换成statusFrames模型
    [newStatuses enumerateObjectsUsingBlock:^(HCStatus *status, NSUInteger idx, BOOL *stop) {
        HCStatusFrames *statusFrames = [[HCStatusFrames alloc] init];
        statusFrames.status = status;
        [newStatusFrames addObject:statusFrames];
    }];
    
    return newStatusFrames;
}

/**
 *  添加一条label，显示此次刷新加载了多少条数据
 *
 *  @param count
 */
- (void)showNewStatusCount:(unsigned long)count
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 64 - 30, HCScreenWidth, 30)];
    
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor whiteColor];
    if (count != 0) {
        label.text = [NSString stringWithFormat:@"此次更新了%lu条微博数据", count];
    } else {
        label.text = @"没有新的微博数据，请稍后再试";
    }
    
    //此处把label添加到导航栏下面更好，label不会跟着tableView到处跑
//    [self.tableView addSubview:label];
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];

    //添加动画
    double duration = 1.0;
    [UIView animateWithDuration:duration animations:^{
        label.transform = CGAffineTransformMakeTranslation(0, label.bounds.size.height);
    } completion:^(BOOL finished) {
        //UIViewAnimationOptionCurveLinear: 线性的，表示匀速
        [UIView animateWithDuration:duration delay:duration options:UIViewAnimationOptionCurveLinear animations:^{
        label.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
}

/**
 *  发送请求获取用户信息(用户昵称)
 */
- (void)setUserNameWithAccount:(HCAccount *)account
{
    //发送请求
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    [mgr GET:@"https://api.weibo.com/2/users/show.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        //获取用户昵称,并设置
        NSString *userName = responseObject[@"screen_name"];
        HCNewTypeButtonView *button = (HCNewTypeButtonView *)self.navigationItem.titleView;
        [button setTitle:userName icon:@"navigationbar_arrow_down" heighIcon:@"navigationbar_arrow_down"];
        
        //将userName存储到沙盒,下次启动直接取
        account.screen_name = userName;
        [HCAccountTools saveAccountWithAccount:account];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark home导航栏item设置
/**
 *  设置home控制器的导航栏item
 */
- (void)setupNavItemWithAccount:(HCAccount *)account
{
    //左边图标
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(leftItemClick:) image:@"navigationbar_friendsearch" heighImage:@"navigationbar_friendsearch_highlighted" title:nil];
    
    //右边图标
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightItemClick:) image:@"navigationbar_pop" heighImage:@"navigationbar_pop_highlighted" title:nil];
    self.navigationItem.rightBarButtonItem.imageInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    
    //中间view,先取沙盒中的title
    HCNewTypeButtonView *titleBtn = [HCNewTypeButtonView buttonWithTitle:(account.screen_name ? account.screen_name : @"首页") icon:@"navigationbar_arrow_down" heighIcon:@"navigationbar_arrow_down"];
    
    //监听按钮点击，弹出下拉菜单
    [titleBtn addTarget:self action:@selector(dropDownMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = titleBtn;
}

/** 点击首页的下拉菜单 */
- (void)dropDownMenu:(HCNewTypeButtonView *)button
{
    //0. 设置button图片箭头向上
    [button setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateNormal];
    
    //创建下拉菜单
    HCDropDownMenuView *dropMenu = [HCDropDownMenuView dropDownMenu];
    //设置下拉菜单容器(即背景图片)
    dropMenu.containerImage = @"popover_background";
    //设置下拉菜单内容
    UITableViewController *contentController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    contentController.view.frame = CGRectMake(0, 0, 200, 200);
    dropMenu.contentController = contentController;
    //显示
    [dropMenu showFromView:button];
    
    //dorpMenu的block,下拉菜单销毁，修改button的image
    dropMenu.block = ^(){
        [button setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
    };
}

- (void)leftItemClick:(UIButton *)btn
{
    TestOneViewController *oneVc = [[TestOneViewController alloc] init];
    oneVc.view.backgroundColor = [UIColor colorWithRandom];
    [self.navigationController pushViewController:oneVc animated:YES];
}

/** 点击右边的下拉菜单 */
- (void)rightItemClick:(UIButton *)button
{
    HCDropDownRightMenuView *dropRightMenu = [HCDropDownRightMenuView dropDownMenu];
    dropRightMenu.containerImage = @"popover_background_right";
    
    UITableViewController *contentController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    contentController.view.frame = CGRectMake(0, 0, 200, 200);
    dropRightMenu.contentController = contentController;
    
    [dropRightMenu showFromView:button];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.statusFramesList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //初始化cell
    HCStatusTableViewCell *cell = [HCStatusTableViewCell statusWithTableView:tableView];
    
    //设置数据
    HCStatusFrames *statusFrames = self.statusFramesList[indexPath.row];
    cell.statusFrames = statusFrames;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.statusFramesList[indexPath.row] cellHeight];
}


@end
