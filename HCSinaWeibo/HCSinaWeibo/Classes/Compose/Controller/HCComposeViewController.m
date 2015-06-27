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
#import "HCComposEmotionKeyborad.h"

@interface HCComposeViewController () <HCComposTextToolBarDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate>
/** 文本框view */
@property (nonatomic, strong) HCPlaceHolderTextView *comTextView;
/** 文本框工具条 */
@property (nonatomic, weak) HCComposTextToolBar *textToolBar;
/** 自定义表情键盘 */
@property (nonatomic, strong) HCComposEmotionKeyborad *emotionKeyboard;


/** 用作代码中的标识，是否正在切换键盘 */
@property (nonatomic, assign) BOOL isSwitchKeyboard;

@end

@implementation HCComposeViewController

- (HCPlaceHolderTextView *)comTextView
{
    if (_comTextView == nil) {
        _comTextView = [[HCPlaceHolderTextView alloc] init];
        _comTextView.placeHolderText = @"苏宏程天才！";
        _comTextView.font = [UIFont systemFontOfSize:15];
        _comTextView.frame = self.view.bounds;
        
        _comTextView.alwaysBounceVertical = YES;
        _comTextView.delegate = self;
        //    [comTextView becomeFirstResponder];
        [self.view addSubview:_comTextView];
        
    }
    
    return _comTextView;
}

- (HCComposEmotionKeyborad *)emotionKeyboard
{
    if (_emotionKeyboard == nil) {
        _emotionKeyboard = [[HCComposEmotionKeyborad alloc] init];
        _emotionKeyboard.frame = CGRectMake(0, 0, self.view.bounds.size.width, 253);
    }
    
    return _emotionKeyboard;
}

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

#pragma mark - 文本框工具条处理
- (void)setupTextToolBar
{
    HCComposTextToolBar *toolBar = [[HCComposTextToolBar alloc] init];
    toolBar.frame = CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44);
    self.textToolBar = toolBar;
    self.textToolBar.delegate = self;
    [self.view addSubview:toolBar];
}

/**
 *  文本框工具条代理 点击事件处理
 *
 *  @param type 被点击的按钮类型
 */
- (void)composTextToolBarClickedWithType:(HCComposTextToolBarType)type
{
    switch (type) {
        case HCComposTextToolBarTypeCarema:
            /** 相机按钮被点击 */
            [self caremaBtnClick];
            break;
        case HCComposTextToolBarTypeAlbum:
            /** 相册按钮被点击 */
            [self albumBtnClick];
            break;
        case HCComposTextToolBarTypeAite:
            /** @按钮被点击 */
            [self aiteBtnClick];
            break;
        case HCComposTextToolBarTypeTopic:
            /** ##按钮被点击 */
            [self topicBtnClick];
            break;
        case HCComposTextToolBarTypeEmotion:
            /** 表情被点击 */
            [self emotionBtnClick];
            break;
        default:
            break;
    }
}

#pragma mark - 表情键盘处理
/** 表情被点击 */
- (void)emotionBtnClick
{
    DLog(@"表情钮被点击");
    if (self.textToolBar.isEmotion) {
        self.comTextView.inputView = nil;
    } else {
        self.comTextView.inputView = self.emotionKeyboard;
    }
    
    //正在切换键盘
    self.isSwitchKeyboard = YES;
    
    [self.comTextView endEditing:YES];
    //切换键盘结束
    self.isSwitchKeyboard = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.comTextView becomeFirstResponder];
    });
}

/** ##按钮被点击 */
- (void)topicBtnClick
{
    DLog(@"##钮被点击");
}

/** @按钮被点击 */
- (void)aiteBtnClick
{
    DLog(@"@@按钮被点击");
}

#pragma mark - 相册、相机按钮点击事件处理
/** 相册按钮被点击 */
- (void)albumBtnClick
{
    DLog(@"相册按钮被点击");
    [self openPickerControllerWithType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
}

/** 相机按钮被点击 */
- (void)caremaBtnClick
{
    [self openPickerControllerWithType:UIImagePickerControllerSourceTypeCamera];
}

/**
 *  创建并显示图片查看器
 *
 *  @param type 图片查看器源类型
 */
- (void)openPickerControllerWithType:(UIImagePickerControllerSourceType)type
{
    if (![UIImagePickerController isSourceTypeAvailable:type]) return;
    //图片查看器
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = type;
    
    [self presentViewController:picker animated:YES completion:nil];
}

/**
 *  pickerController中选中图片后的事件处理
 *
 *  @param picker
 *  @param info 存放着选中的图片iamgeView
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    DLog(@"%@", info);
}

/**
 *  pickerController的取消按钮点击
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

    //如果正在切换键盘，工具条不作处理
    if (self.isSwitchKeyboard) return;
    
    CGFloat keyboardY = [notify.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].origin.y;
    CGFloat viewH = self.view.bounds.size.height;
    
    self.textToolBar.transform = CGAffineTransformMakeTranslation(0, keyboardY - viewH);
}

/** textViewDelegate */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - 文本框部分

- (void)setupTextView
{
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
