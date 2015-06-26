//
//  HCComposeViewController.m
//  HCSinaWeibo
//
//  Created by tunny on 15/6/25.
//  Copyright (c) 2015年 tunny. All rights reserved.
//

#import "HCComposeViewController.h"
#import "HCAccountTools.h"
#import "HCPlaceHolderTextView.h"
#import "HCComposTextToolBar.h"

@interface HCComposeViewController ()

@property (nonatomic, weak) HCPlaceHolderTextView *comTextView;

@property (nonatomic, weak) HCComposTextToolBar *textToolBar;

@end

@implementation HCComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏
    [self setupNav];
    
    //创建文本框
    [self setupTextView];
    
    //创建文本框工具条
    [self setupTextToolBar];
}

#pragma mark - 文本框工具条
- (void)setupTextToolBar
{
    HCComposTextToolBar *toolBar = [[HCComposTextToolBar alloc] init];
    toolBar.frame = CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44);
    self.textToolBar = toolBar;
    [self.view addSubview:toolBar];
}

#pragma mark - 键盘位置的处理
- (void)keyboradWillChangeFrame:(NSNotification *)notify
{
    /**
     userInfo = {
     UIKeyboardFrameBeginUserInfoKey = NSRect: {{0, 883}, {320, 253}};
     UIKeyboardCenterEndUserInfoKey = NSPoint: {160, 441.5};
     UIKeyboardBoundsUserInfoKey = NSRect: {{0, 0}, {320, 253}};
     UIKeyboardFrameEndUserInfoKey = NSRect: {{0, 315}, {320, 253}};
     UIKeyboardAnimationDurationUserInfoKey = 0.4;
     UIKeyboardCenterBeginUserInfoKey = NSPoint: {160, 1009.5};
     UIKeyboardAnimationCurveUserInfoKey = 7;
     }
     */

    CGFloat keyboardY = [notify.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].origin.y;
    CGFloat viewH = self.view.bounds.size.height;
    
    self.textToolBar.transform = CGAffineTransformMakeTranslation(0, keyboardY - viewH);
}

#pragma mark - 文本框部分

- (void)setupTextView
{
    HCPlaceHolderTextView *comTextView = [[HCPlaceHolderTextView alloc] init];
    comTextView.placeHolderText = @"苏宏程天才！";
    comTextView.font = [UIFont systemFontOfSize:15];
    comTextView.frame = self.view.bounds;
//    [comTextView becomeFirstResponder];
    [self.view addSubview:comTextView];
    
    
    self.comTextView = comTextView;
    
    //监听textView发出的 UITextViewTextDidChangeNotification通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChanged) name:UITextViewTextDidChangeNotification object:self.comTextView];
    
    //监听键盘位置改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboradWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

/**
 *  监听通知的回调函数
 */
- (void)textDidChanged
{
    //修改发送按钮的状态
    self.navigationItem.rightBarButtonItem.enabled = self.comTextView.hasText;
}



#pragma mark - 导航栏部分
/**
 *  设置导航栏
 */
- (void)setupNav
{
    //左
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    //右
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(send)];
    //    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    //中
    HCAccount *account = [HCAccountTools account];
    NSString *prefix = @"发微博";
    
    if (account.screen_name) {
        NSString *str = [NSString stringWithFormat:@"%@\n%@", prefix, account.screen_name];
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attributedStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:[str rangeOfString:prefix]];
        [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[str rangeOfString:account.screen_name]];
        
        UILabel *midLabel = [[UILabel alloc] init];
        midLabel.bounds = CGRectMake(0, 0, 100, 44);
        midLabel.numberOfLines = 0;
        midLabel.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = midLabel;
        midLabel.attributedText = attributedStr;
    } else {
        self.navigationItem.title = prefix;
    }

}

/**
 *  取消发送微博
 */
- (void)cancel
{
    [self.comTextView endEditing:YES];
    [super dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  发送微博
 */
- (void)send
{
    DLog(@"发送微博");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
#warning 为什么写到这里才生效...写在viewDidload不生效
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
