//
//  HCOAuthViewController.m
//  HCSinaWeibo
//
//  Created by tunny on 15/6/19.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "HCOAuthViewController.h"
#import "AFNetworking.h"
#import "HCAccount.h"
#import "MBProgressHUD+MJ.h"
#import "HCAccountTools.h"


#define HCAppKey    @"2071142341"
#define HCRedirectUrl   @"https://tunnyios.github.io/"
#define HCSecret        @"127af0d161b086d9d1598d0400293721"

@interface HCOAuthViewController ()<UIWebViewDelegate>

@end

@implementation HCOAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //1. 创建UIWebView发送请求，获取未授权的Request Token
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.delegate = self;
    [self.view addSubview:webView];
    NSString *str = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@", HCAppKey, HCRedirectUrl];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
}

#pragma  mark - webView的代理事件
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showMessage:@"正在加载..."];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUD];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    DLog(@"---%@---", request);
    //2. 拦截返回的url，取出code
    NSString *urlStr = [request.URL absoluteString];
    
    NSRange range = [urlStr rangeOfString:@"code="];
    if (range.length != 0) {
        NSString *code = [urlStr substringFromIndex:(range.length + range.location)];
        
        //3. 发送一个正常的请求获取，取得access Token
        [self accessTokenWithCode:code];
        
        //禁止跳转至回调页面
        return NO;
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
    params[@"client_id"] = HCAppKey;
    params[@"client_secret"] = HCSecret;
    params[@"grant_type"] = @"authorization_code";
    params[@"redirect_uri"] = HCRedirectUrl;
    params[@"code"] = code;
    
    [mgr POST:@"https://api.weibo.com/oauth2/access_token" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        [MBProgressHUD hideHUD];
        DLog(@"请求成功---%@---", responseObject);
        
        //将responseObject字典转成模型
        HCAccount *account = [HCAccount accountWithDict:responseObject];
        
        //将返回的数据存储到沙盒
        [HCAccountTools saveAccountWithAccount:account];
        
        //判断是否需要展示新特性，否则展示主视图
        [UIWindow switchRootViewController];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        DLog(@"请求失败---%@---", error);
    }];
}

@end
