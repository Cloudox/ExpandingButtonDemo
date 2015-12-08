//
//  ViewController.h
//  ExpandingButtonDemo
//
//  Created by csdc-iMac on 15/12/7.
//  Copyright (c) 2015年 csdc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property BOOL isExpanding;// 是否点击过
@property (strong, nonatomic) UIButton *mainBtn;// 主按钮
@property (strong, nonatomic) NSArray *buttonArray;// 弹出的按钮数组

@end

