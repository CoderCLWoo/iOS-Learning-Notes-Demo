//
//  ViewController.m
//  社交分享
//
//  Created by WuChunlong on 2017/2/10.
//  Copyright © 2017年 WuChunlong. All rights reserved.
//

#import "ViewController.h"
#import <Social/Social.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *systemSocialBtn = [self createButtonWithFrame:CGRectMake(100, 100, 120, 120) tittle:@"系统分享" target:self action:@selector(onClick_SystemSocialBtn)];
    [self.view addSubview:systemSocialBtn];
    
    UIButton *sinaWeiboShareBtn = [self createButtonWithFrame:CGRectMake(100, 250, 150, 150) tittle:@"分享到新浪微博" target:self action:@selector(onClick_SinaWeiboShareBtn)];
    [self.view addSubview:sinaWeiboShareBtn];
    
}

#pragma mark - 系统分享
- (void)onClick_SystemSocialBtn {
    // 设置分享内容：文字、链接、图片
    NSString *shareText = @"这是分享的文字内容";
    NSURL *shareUrl = [NSURL URLWithString:@"https://www.baidu.com"];
    UIImage *shareImg = [UIImage imageNamed:@"AppIcon83.5x83.5@2x"];
    
    NSArray *activityItems = @[shareText, shareUrl];
    if (shareImg) {
        activityItems = @[shareText, shareUrl, shareImg];
    }
    
//    NSArray *applicationActivities = @[]; // (nullable NSArray<__kindof UIActivity *> *)
    
    // 服务类型控制器
    UIActivityViewController *activityVc = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    // 分享回调：iOS8以后用completionWithItemsHandler了
    
    //初始化回调方法
    UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError)
    {
        NSLog(@"activityType :%@", activityType);
        
        if (completed)
        {
            NSLog(@"系统分享成功");
        } else
        {
            NSLog(@"取消系统分享");
        }
        
        //操作成功或者取消后都会回上一级界面
//        [self dismissModalViewControllerAnimated:YES];
        
    };
    
    // 初始化completionHandler，当post发送结束之后（无论是done还是cancell）该block都会被调用
    activityVc.completionWithItemsHandler = myBlock;
   
    // 排除类型,  不显示
    /// default is nil. activity types listed will not be displayed
    activityVc.excludedActivityTypes = @[UIActivityTypeMessage,
                                         UIActivityTypeMail,
                                         UIActivityTypeAssignToContact,
                                         UIActivityTypePrint,
                                         UIActivityTypeCopyToPasteboard,
                                         UIActivityTypeAddToReadingList,
                                         UIActivityTypeAirDrop];
    
    
    // 推出界面
    [self presentViewController:activityVc animated:YES completion:nil];
    
}

#pragma mark 分享到新浪微博
- (void)onClick_SinaWeiboShareBtn {
    // 1.判断平台是否可用
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]) {
        NSLog(@"平台不可用,或者没有配置相关的帐号");
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还未绑定新浪微博,请到设置里面绑定" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alert show];
        return;
    }
    
    // 2.创建分享视图控制器，并指定分享平台
    SLComposeViewController *composeVc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
    
    
    // 2.1.添加分享的文字
    [composeVc setInitialText:@"这是分享到新浪微博的文字"];
    
    // 2.2.添加一个图片
    [composeVc addImage:[UIImage imageNamed:@"AppIcon83.5x83.5@2x"]];
    
    // 2.3.添加一个分享的链接
    [composeVc addURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    
    // 3.弹出分享控制器
    [self presentViewController:composeVc animated:YES completion:^{
        NSLog(@"进入分享界面");
    }];
    
    // 4.监听用户点击了取消还是发送  SLComposeViewControllerCompletionHandler
    composeVc.completionHandler = ^(SLComposeViewControllerResult result) {
        if (result == SLComposeViewControllerResultCancelled) {
            NSLog(@"点击了取消");
        } else if (result == SLComposeViewControllerResultDone) {
            NSLog(@"点击了发送");
        }
    };
    
    
}

#pragma mark - 快速创建Btn
- (UIButton *)createButtonWithFrame:(CGRect)frame tittle:(NSString *)title target:(nullable id)target action:(nonnull SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.layer.cornerRadius = frame.size.height * 0.5;
    btn.backgroundColor = [UIColor cyanColor];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}


@end
