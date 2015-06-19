//
//  HCOAuthViewController.m
//  HCSinaWeibo
//
//  Created by tunny on 15/6/19.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "HCOAuthViewController.h"
#import "AFNetworking.h"
#import "HCMainViewController.h"
#import "HCNewFeatureViewController.h"

@interface HCOAuthViewController ()<UIWebViewDelegate>

@end

@implementation HCOAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建UIWebView发送请求，获取未授权的Request Token
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.delegate = self;
    [self.view addSubview:webView];
    NSString *str = @"https://api.weibo.com/oauth2/authorize?client_id=1533842430&redirect_uri=https://tunnyios.github.io/";
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
}

#pragma  mark - webView的代理事件
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    HCLog(@"---%@---", request);
    //2. 拦截返回的url，取出code
    NSString *urlStr = [request.URL absoluteString];
    
    NSRange range = [urlStr rangeOfString:@"code="];
    if (range.length != 0) {
        NSString *code = [urlStr substringFromIndex:(range.length + range.location)];
        
        //3. 发送一个正常的请求获取，取得access Token
        [self accessTokenWithCode:code];
    }

    return YES;
}

/**
 *  发送请求获取access Token
 *
 *  @param code
 */
- (void)accessTokenWithCode:(NSString *)code
{
    //创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    //设置参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client_id"] = @"1533842430";
    params[@"client_secret"] = @"7a3d4de75cf1fa7e5bf8a6b13d044be2";
    params[@"grant_type"] = @"authorization_code";
    params[@"redirect_uri"] = @"https://tunnyios.github.io/";
    params[@"code"] = code;
    
    [mgr POST:@"https://api.weibo.com/oauth2/access_token" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        HCLog(@"请求成功---%@---", responseObject);
        //将返回的数据存储到沙盒
        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [doc stringByAppendingPathComponent:@"account.plist"];
        [responseObject writeToFile:path atomically:YES];
        
        //判断是否需要展示新特性，否则展示主视图
        NSString *key = @"CFBundleVersion";
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *savedVersion = [defaults objectForKey:key];
        NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
        if ([savedVersion isEqualToString:currentVersion]) {
            //不需要展示新特性
            window.rootViewController = [[HCMainViewController alloc] init];
        } else {
            //展示新特性
            window.rootViewController = [[HCNewFeatureViewController alloc] init];
            //将新版本号存入沙盒
            [defaults setObject:currentVersion forKey:key];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HCLog(@"请求失败---%@---", error);
    }];
}

@end
