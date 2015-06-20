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


typedef enum : NSUInteger {
    HCSendRequestTypeDown,  //下拉刷新
    HCSendRequestTypeUp,    //上拉刷新
    
} HCSendRequestType;

@interface HCHomeTableViewController ()
/** 微博数组 */
@property (nonatomic, strong) NSMutableArray *statusList;

@end

@implementation HCHomeTableViewController

- (NSMutableArray *)statusList
{
    if (_statusList == nil) {
        _statusList = [NSMutableArray array];
    }
    
    return _statusList;
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
    
}

/**
 *  实现上拉刷新
 */
- (void)dropUpRefreshStatus
{
    //添加footView
    
}

/**
 *  实现下拉刷新(apple自带下拉刷新控件)
 */
- (void)dropDownRefreshStatus
{
    //1. 添加刷新控件
    UIRefreshControl *control = [[UIRefreshControl alloc] init];
    //只有用户通过手动下拉刷新，才会出发valueChanged事件
    [control addTarget:self action:@selector(dropDownRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:control];
    
    //2. 开始刷新(只是显示刷新，但是valueChange并不会改变)
    [control beginRefreshing];
    
    //3. 刷新
    [self dropDownRefresh:control];
}

/**
 *  下拉刷新控件的监听事件
 *  下拉刷新获取数据
 *  @param control
 */
- (void)dropDownRefresh:(UIRefreshControl *)control
{
    //1. 发送请求获取数据
    [self sendRequestForDataWithType:HCSendRequestTypeDown];
    
    //2. 关闭刷新
    [control endRefreshing];
}

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
        NSString *since_id = [[self.statusList firstObject] idstr];
        dict[@"since_id"] = since_id ? since_id : @"0";
    } else {
        NSString *max_id = [[self.statusList lastObject] idstr];
        dict[@"max_id"] = max_id ? max_id : @"0";
    }
    
    [mgr GET:@"https://api.weibo.com/2/statuses/home_timeline.json" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //将微博字典数组－－－>微博模型数组
        NSArray *newArray = [HCStatus objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        
        //将新数据添加到微博数组中
        if (HCSendRequestTypeDown == type) {
            //插入
            NSRange range = NSMakeRange(0, newArray.count);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            [self.statusList insertObjects:newArray atIndexes:indexSet];
        } else {
            //追加
            [self.statusList addObjectsFromArray:newArray];
        }
        
        //添加view显示此次刷新更新了多少条信息
        [self showNewStatusCount:(unsigned long)newArray.count];
        
        //刷新数据
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"请求失败.--%@--", error);
    }];
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
    
    return self.statusList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    //设置数据
    HCStatus *status = self.statusList[indexPath.row];
    cell.textLabel.text = status.user.name;
    cell.detailTextLabel.text = status.text;
    
    NSURL *url = [NSURL URLWithString:status.user.profile_image_url];
    [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];

    return cell;
}


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
