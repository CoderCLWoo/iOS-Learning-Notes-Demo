//
//  ViewController.m
//  App 国际化
//
//  Created by WuChunlong on 2016/12/26.
//  Copyright © 2016年 WuChunlong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setUpLabel];
}

// 国际化字符串
- (void)setUpLabel
{
    UILabel *label=[[UILabel alloc]init];
    label.frame=CGRectMake(100, 100, 200, 50);
    label.backgroundColor=[UIColor redColor];
//        label.text=[[NSBundle mainBundle]localizedStringForKey:@"labelText" value:@"" table:@"ceshi"];  // 指定使用的语言包
//        label.text = NSLocalizedStringFromTable(@"text", @"LocalString", @"");
    
    //括号里第一个参数是要显示的内容,与各Localizable.strings中的id对应 //第二个是对第一个参数的注释,一般可以为空串
    label.text = NSLocalizedString(@"text", nil); // 系统默认表名：Localizable
    
    [self.view addSubview:label];
    
}

@end
