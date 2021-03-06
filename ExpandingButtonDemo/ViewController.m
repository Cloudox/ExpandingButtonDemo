//
//  ViewController.m
//  ExpandingButtonDemo
//
//  Created by csdc-iMac on 15/12/7.
//  Copyright (c) 2015年 csdc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.isExpanding = NO;
    
    // 主按钮
    self.mainBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 400, 35, 35)];
    [self.mainBtn setBackgroundImage:[UIImage imageNamed:@"btn_quickoption_route"] forState:UIControlStateNormal];
    self.mainBtn.transform = CGAffineTransformMakeRotation(- M_PI*(45)/180.0);
    [self.mainBtn addTarget:self action:@selector(btnTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.mainBtn];
    
    CGPoint buttonCenter = CGPointMake(self.mainBtn.frame.size.width / 2.0f, self.mainBtn.frame.size.height / 2.0f);
    
    // 弹出的按钮
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"submit_pressed"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btn1Tap) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setCenter:buttonCenter];
    [btn1 setAlpha:0.0f];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"sumitmood"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btn2Tap) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setCenter:buttonCenter];
    [btn2 setAlpha:0.0f];
    [self.view addSubview:btn2];
    
    self.buttonArray = [NSArray arrayWithObjects:btn2, btn1, nil];
}

// 点击按钮1的响应
- (void)btn1Tap {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"旋转，跳跃，我闭着眼" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [av show];
}

// 点击按钮2的响应
- (void)btn2Tap {
    CGAffineTransform unangle = CGAffineTransformMakeRotation (- M_PI*(45)/180.0);
    [UIView animateWithDuration:0.3 animations:^{// 动画开始
        [self.mainBtn setTransform:unangle];
    } completion:^(BOOL finished){// 动画结束
        [self.mainBtn setTransform:unangle];
    }];
    
    [self hideButtonsAnimated];
    
    self.isExpanding = NO;
}

// 点击主按钮的响应
- (void)btnTap:(UIButton *)sender {
    /*关于M_PI
     #define M_PI     3.14159265358979323846264338327950288
     其实它就是圆周率的值，在这里代表弧度，相当于角度制 0-360 度，M_PI=180度
     旋转方向为：顺时针旋转
     */
    if (!self.isExpanding) {// 初始未展开
        CGAffineTransform angle = CGAffineTransformMakeRotation (0);
        [UIView animateWithDuration:0.3 animations:^{// 动画开始
            [sender setTransform:angle];
        } completion:^(BOOL finished){// 动画结束
            [sender setTransform:angle];
        }];
        
        [self showButtonsAnimated];
        
        self.isExpanding = YES;
    } else {// 已展开
        CGAffineTransform unangle = CGAffineTransformMakeRotation (- M_PI*(45)/180.0);
        [UIView animateWithDuration:0.3 animations:^{// 动画开始
            [sender setTransform:unangle];
        } completion:^(BOOL finished){// 动画结束
            [sender setTransform:unangle];
        }];
        
        [self hideButtonsAnimated];
        
        self.isExpanding = NO;
    }
}

// 展开按钮
- (void)showButtonsAnimated {
    NSLog(@"animate");
    float y = [self.mainBtn center].y;
    float x = [self.mainBtn center].x;
    float endY = y;
    float endX = x;
    for (int i = 0; i < [self.buttonArray count]; ++i) {
        UIButton *button = [self.buttonArray objectAtIndex:i];
        // 最终坐标
        endY -= button.frame.size.height + 30.0f;
        endX += 0.0f;
        // 反弹坐标
        float farY = endY - 30.0f;
        float farX = endX - 0.0f;
        float nearY = endY + 15.0f;
        float nearX = endX + 0.0f;
        
        // 动画集合
        NSMutableArray *animationOptions = [NSMutableArray array];
        
        // 旋转动画
        CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
        [rotateAnimation setValues:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:M_PI * 2], nil]];
        [rotateAnimation setDuration:0.4f];
        [rotateAnimation setKeyTimes:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:1.0f], nil]];
        [animationOptions addObject:rotateAnimation];
        
        // 位置动画
        CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        [positionAnimation setDuration:0.4f];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, x, y);
        CGPathAddLineToPoint(path, NULL, farX, farY);
        CGPathAddLineToPoint(path, NULL, nearX, nearY);
        CGPathAddLineToPoint(path, NULL, endX, endY);
        [positionAnimation setPath: path];
        CGPathRelease(path);
        [animationOptions addObject:positionAnimation];
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        [animationGroup setAnimations: animationOptions];
        [animationGroup setDuration:0.4f];
        [animationGroup setFillMode: kCAFillModeForwards];
        [animationGroup setTimingFunction: [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        
        NSDictionary *properties = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:button, [NSValue valueWithCGPoint:CGPointMake(endX, endY)], animationGroup, nil] forKeys:[NSArray arrayWithObjects:@"view", @"center", @"animation", nil]];
        
        [self performSelector:@selector(_expand:) withObject:properties afterDelay:0.1f * ([self.buttonArray count] - i)];
    }
}

// 收起动画
- (void) hideButtonsAnimated {
    CGPoint center = [self.mainBtn center];
    float endY = center.y;
    float endX = center.x;
    for (int i = 0; i < [self.buttonArray count]; ++i) {
        UIButton *button = [self.buttonArray objectAtIndex:i];
        
        // 动画集合
        NSMutableArray *animationOptions = [NSMutableArray array];
        
        // 旋转动画
        CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
        [rotateAnimation setValues:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:M_PI * -2], nil]];
        [rotateAnimation setDuration:0.4f];
        [rotateAnimation setKeyTimes:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:1.0f], nil]];
        [animationOptions addObject:rotateAnimation];
        
        // 透明度？
        CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        [opacityAnimation setValues:[NSArray arrayWithObjects:[NSNumber numberWithFloat:1.0f], [NSNumber numberWithFloat:0.0f], nil]];
        [opacityAnimation setDuration:0.4];
        [animationOptions addObject:opacityAnimation];
        
        // 位置动画
        float y = [button center].y;
        float x = [button center].x;
        CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        [positionAnimation setDuration:0.4f];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, x, y);
        CGPathAddLineToPoint(path, NULL, endX, endY);
        [positionAnimation setPath: path];
        CGPathRelease(path);
        [animationOptions addObject:positionAnimation];
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        [animationGroup setAnimations: animationOptions];
        [animationGroup setDuration:0.4f];
        [animationGroup setFillMode: kCAFillModeForwards];
        [animationGroup setTimingFunction: [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        
        NSDictionary *properties = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:button, animationGroup, nil] forKeys:[NSArray arrayWithObjects:@"view", @"animation", nil]];
        [self performSelector:@selector(_close:) withObject:properties afterDelay:0.1f * ([self.buttonArray count] - i)];
    }
}

// 弹出
- (void) _expand:(NSDictionary*)properties
{
    NSLog(@"expand");
    UIView *view = [properties objectForKey:@"view"];
    CAAnimationGroup *animationGroup = [properties objectForKey:@"animation"];
    NSValue *val = [properties objectForKey:@"center"];
    CGPoint center = [val CGPointValue];
    [[view layer] addAnimation:animationGroup forKey:@"Expand"];
    [view setCenter:center];
    [view setAlpha:1.0f];
}

// 收起
- (void) _close:(NSDictionary*)properties
{
    UIView *view = [properties objectForKey:@"view"];
    CAAnimationGroup *animationGroup = [properties objectForKey:@"animation"];
    CGPoint center = [self.mainBtn center];
    [[view layer] addAnimation:animationGroup forKey:@"Collapse"];
    [view setAlpha:0.0f];
    [view setCenter:center];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
