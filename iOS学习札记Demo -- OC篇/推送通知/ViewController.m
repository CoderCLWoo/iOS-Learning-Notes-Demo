//
//  ViewController.m
//  通知
//
//  Created by WuChunlong on 2016/12/20.
//  Copyright © 2016年 WuChunlong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self showIconBadgeNumber:7];

}

// 显示提醒数字
- (void)showIconBadgeNumber:(NSInteger)num {
    
    /*
     @property(nonatomic) NSInteger applicationIconBadgeNumber __TVOS_PROHIBITED;  // set to 0 to hide. default is 0. In iOS 8.0 and later, your application must register for user notifications using -[UIApplication registerUserNotificationSettings:] before being able to set the icon badge.
     */
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
    
    UIApplication *app = [UIApplication sharedApplication];
    [app registerUserNotificationSettings:settings];
    app.applicationIconBadgeNumber = num;
}

@end
