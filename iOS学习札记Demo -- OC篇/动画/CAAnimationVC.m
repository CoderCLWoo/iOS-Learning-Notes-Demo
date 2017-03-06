//
//  CAAnimationVC.m
//  iOS学习札记 -- OC篇
//
//  Created by WuChunlong on 2016/12/25.
//  Copyright © 2016年 WuChunlong. All rights reserved.
//

#import "CAAnimationVC.h"

@interface CAAnimationVC ()

@end

@implementation CAAnimationVC
{
    UIView *_animationView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _animationView = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 300, 300)];
    _animationView.backgroundColor = [UIColor redColor];
    //    animationView.layer.cornerRadius = 100;
    _animationView.layer.borderColor = [UIColor greenColor].CGColor;
    _animationView.layer.borderWidth = 10;
    _animationView.layer.shadowColor = [UIColor yellowColor].CGColor;
    _animationView.layer.shadowOpacity = 1.0;
    [self.view addSubview:_animationView];
    
    [self performSelector:@selector(animationAction) withObject:nil afterDelay:0.1f];

    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self animationAction];
}

- (void)animationAction {
    
    NSArray *animArr = @[@"basicAnimation",@"keyFrameAnimation",@"transitonAnimation",@"groupAnimation"];
    NSUInteger animIndex = arc4random_uniform((uint32_t)animArr.count);
    NSString *actionStr = [NSString stringWithFormat:@"%@", animArr[animIndex]];
    [_animationView.layer removeAllAnimations];
    [self performSelector:NSSelectorFromString(actionStr) withObject:nil afterDelay:0];
    
//    [self basicAnimation];
//    [self keyFrameAnimation];
//    [self transitonAnimation];
//    [self groupAnimation];
    
}

//CAAnimation 没有真实改变属性值，只是模拟属性值的改变
#pragma mark - CABasicAnimation
- (void)basicAnimation {
    // 注意：keyPath写属性的名字或路径
    
    NSLog(@"前~~~~%f",_animationView.layer.cornerRadius); // 前~~~~0.000000
    // 改变圆角
    CABasicAnimation *basicAnimation1 = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    // 动画时间
    basicAnimation1.duration = 5;
    // 动画执行速度，默认为1
    basicAnimation1.speed = 2;
    // 属性值改变量
    basicAnimation1.fromValue = @0;
    basicAnimation1.toValue = @50;
    
    // 执行完后是否自动反向执行动画(Defaults to NO)
    basicAnimation1.autoreverses = NO;
    
    // 动画执行完毕是否移除属性值改变后的状态恢复原样（默认执行后移除）
//    basicAnimation1.removedOnCompletion = NO;// 设置为NO表示 动画对象不要删除
//    basicAnimation1.fillMode = kCAFillModeForwards;//保存当前的状态
    [_animationView.layer addAnimation:basicAnimation1 forKey:@"123"];
    NSLog(@"后~~~~%f",_animationView.layer.cornerRadius); // 后~~~~0.000000 由此可见，CAAnimation 没有真实改变属性值，只是模拟属性值的改变
    
    // 改变宽度
    CABasicAnimation *basicAnimation2 = [CABasicAnimation animationWithKeyPath:@"bounds.size.width"];
    basicAnimation2.duration = 1;
    basicAnimation2.speed = 0.2;
    basicAnimation2.fromValue = @300;
    basicAnimation2.toValue = @100;
    [_animationView.layer addAnimation:basicAnimation2 forKey:@"234"];
    
    // 改变尺寸
    CABasicAnimation *basicAnimation3 = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
    basicAnimation3.duration = 1;
    basicAnimation3.speed = 0.2;
    basicAnimation3.fromValue = @[@300, @300];
    basicAnimation3.toValue = @[@100, @100];
//    basicAnimation3.removedOnCompletion = NO;//动画对象不要删除
//    basicAnimation3.fillMode = kCAFillModeForwards;//保存当前的状态
    [_animationView.layer addAnimation:basicAnimation3 forKey:@"234"];
    NSLog(@"%@",NSStringFromCGSize(_animationView.bounds.size));
    
    
}

#pragma mark - CAKeyframeAnimation 关键帧动画，沿着指定路径执行的动画
- (void)keyFrameAnimation {
    _animationView.layer.anchorPoint = CGPointMake(0, 0);
    _animationView.layer.cornerRadius = 150;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    // 设置动画路径
    animation.values = @[[NSValue valueWithCGPoint:CGPointMake(0, 0)],
                         [NSValue valueWithCGPoint:CGPointMake(75, 150)],
                         [NSValue valueWithCGPoint:CGPointMake(0, 300)],
                         [NSValue valueWithCGPoint:CGPointMake(75, 400)],
                         [NSValue valueWithCGPoint:CGPointMake(0, 500)],
                         [NSValue valueWithCGPoint:CGPointMake(75, 600)]];
    // 设置动画时长
    animation.duration = 5;
    //设置动画节奏
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    /** Timing function names.
     
     *  kCAMediaTimingFunctionLinear 线性匀速
     
     *  kCAMediaTimingFunctionEaseIn 先慢后快
     
     *  kCAMediaTimingFunctionEaseOut 先快后慢
     
     *  kCAMediaTimingFunctionEaseInEaseOut 时快时慢（中间快，两边慢）
     
     *  kCAMediaTimingFunctionDefault 默认
     
     **/
    
//    animation.removedOnCompletion = NO;//动画对象不要删除
//    animation.fillMode = kCAFillModeForwards;//保存当前的状态
    [_animationView.layer addAnimation:animation forKey:nil];
    
    
}


/*
 fade kCATransitonFade 交叉淡化过度
 moveIn kCATransitionMoveIn 新视图移到旧视图上面
 push kCATransitonPush 新视图把旧视图推上去
 reveal kCATransitonReveal 将旧视图一开，显示下面的新视图
 pageCurl 向上翻一页
 pageUnCurl 向下翻一页
 rippleEffect 滴水效果
 suckEffect 收缩效果，如一块布被抽走
 cube 立方体效果
 oglFlip 上下左右翻转效果
 rotate 旋转效果
 cameraIrisHollowClose相机镜头关上效果（不支持过度方向）
 cameraIrisHollowOpen相机镜头打开效果（。。。）
 
 subtype：动画方向
 kCATransitionFromRight
 kCATransitionFromLeft
 kCATransitionFromTop
 kCATransitionFromBottom
 
 当type为@"rotate"时，它也有几个对应的subtype，分别为
 90cw 逆时针旋转90
 90ccw 顺时针旋转90、
 180cw 逆时针旋转180
 180ccw 顺时针旋转180
 
 */

#pragma mark - CATransition 转场动画、过渡动画
- (void)transitonAnimation {
    CATransition *transition = [CATransition animation];
    transition.type = @"rotate";
    transition.duration = 4;
    //设置动画的子类型
    transition.subtype = @"90cw";
    
    [_animationView.layer addAnimation:transition forKey:nil];
}


#pragma mark - CAAnimationGroup 动画组
- (void)groupAnimation {
    // 创建动画组
    CAAnimationGroup *group = [CAAnimationGroup animation];
    
    // 第1个动画： 平移
    CABasicAnimation *position = [CABasicAnimation animation];
    position.keyPath = @"position";
    position.toValue = [NSValue valueWithCGPoint:CGPointMake(250, 450)];
    
    // 第2个动画：旋转
    CABasicAnimation *rotation = [CABasicAnimation animation];
    rotation.keyPath = @"transform.rotation.z";
    rotation.toValue = @(M_PI_2 - 0.25);
    
    // 第3个动画：缩放
    CABasicAnimation *scale = [CABasicAnimation animation];
    scale.keyPath = @"transform.scale";
    scale.toValue = @(0.5);
    
    // 设置动画时长
    group.duration = 5;
    
    // 将动画添加到组
    group.animations = @[position, rotation, scale];
    
//    group.removedOnCompletion = NO;
//    group.fillMode = kCAFillModeForwards;
    
    [_animationView.layer addAnimation:group forKey:@"group"];
    
    
}

@end
