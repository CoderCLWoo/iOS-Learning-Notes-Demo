//
//  UIViewAnimationVC.m
//  iOS学习札记 -- OC篇
//
//  Created by WuChunlong on 2016/12/25.
//  Copyright © 2016年 WuChunlong. All rights reserved.
//

#import "UIViewAnimationVC.h"

@interface UIViewAnimationVC ()

@end

@implementation UIViewAnimationVC
{
    UIView *_animationView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _animationView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    _animationView.backgroundColor = [UIColor greenColor];
    _animationView.layer.cornerRadius = 100;
    [self.view addSubview:_animationView];
    
    [self performSelector:@selector(animationAction) withObject:nil afterDelay:0.1f];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self animationAction];
}

- (void)animationAction {
    
    NSArray *animArr = @[@"propertyAnimation",@"transitionAnimation",@"blockAnimation"];
    NSUInteger animIndex = arc4random_uniform((uint32_t)animArr.count);
    NSString *actionStr = [NSString stringWithFormat:@"%@", animArr[animIndex]];
    [_animationView.layer removeAllAnimations];
    [self performSelector:NSSelectorFromString(actionStr) withObject:nil afterDelay:0];
    
//    [self propertyAnimation];
//    [self transitionAnimation];
//    [self blockAnimation];
}

#pragma mark - 属性动画
- (void)propertyAnimation {
    //动画块，以beginAnimations:context开头，以commitAntions结尾，在中间写动画的该变量
    //参数一：动画的标识，参数二：上下文
    //开始动画
    [UIView beginAnimations:@"aaa" context:NULL];
    //延时
    //    [UIView setAnimationStartDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    //    [UIView setAnimationDelay:1];
    //设置动画时长
    [UIView setAnimationDuration:3];//设置动画时长
    //设置动画曲线
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    //设置重复次数
    [UIView setAnimationRepeatCount:1];
    _animationView.center = CGPointMake(arc4random() % 375, arc4random() % 667);
    [UIView commitAnimations];
    
}

#pragma mark - block动画
- (void)blockAnimation {
    [UIView animateWithDuration:3.0 animations:^{
        _animationView.center = CGPointMake(arc4random() % 375, arc4random() % 667);
    }];
    // 如果需要设置动画执行完毕的操作，使用这个方法：
    //    [UIView animateWithDuration:3.0 animations:^{
    //
    //    } completion:^(BOOL finished) {
    //
    //    }];
}

#pragma mark - 过渡动画
- (void)transitionAnimation {
    [UIView beginAnimations:@"ddd" context:NULL];
    [UIView setAnimationDuration:3];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:_animationView cache:NO];
    _animationView.center = CGPointMake(arc4random() % 375, arc4random() % 667);
    [UIView commitAnimations];
    
}

@end
