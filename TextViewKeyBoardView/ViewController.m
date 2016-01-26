//
//  ViewController.m
//  TextViewKeyBoardView
//
//  Created by amss on 15/12/8.
//  Copyright © 2015年 HuanXun. All rights reserved.
//

#import "ViewController.h"
#import "AutoLayoutTextView.h"
@interface ViewController ()<AutoLayoutTextViewDelegate>

@property(nonatomic,strong)AutoLayoutTextView* text;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registNotification];
    [self addEditingGestureRecognizer];
    
    self.text = [[AutoLayoutTextView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-40, self.view.frame.size.width, 40)];
//    self.text.keyBoardUnShowFrame = self.text.frame;
    self.text.delegate = self;
    [self.view addSubview:self.text];
    
}
//  增加手势
- (void)addEditingGestureRecognizer
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tap];
}
- (void)endEditing:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

// 注册通知
-(void)registNotification
{
    //键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];

}
#pragma mark - 键盘监控
-(void)keyboardChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
//    键盘的高度
    self.text.keyBoardHeight = keyboardEndFrame.size.height;
    
    //调整约束高度
    if (notification.name == UIKeyboardWillShowNotification) {

        NSLog(@"约束高度 %f",keyboardEndFrame.size.height);

        [self.text upMoveSpace:self.text.keyBoardHeight];
        
       
    }else{

        [self.text downMoveSpace:self.text.keyBoardHeight];
    }

    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}

#pragma mark --  delegate
//根据 textView 的高度自动约束 inputView 的高度
- (void)changeInputViewHeightConstraint:(CGFloat)height
{
    NSLog(@"++++++ %f",height);
    
        if (height <= self.text.keyBoardUnShowFrame.size.height)
        {
            [self.text resetHeightByNOChangeBottom:self.text.keyBoardUnShowFrame.size.height];
        }else
        {
            if (height > self.text.keyBoardUnShowFrame.size.height) {
                
                if (height > 80) {
                    [self.text resetHeightByNOChangeBottom:80];
                }else
                {
                    [self.text resetHeightByNOChangeBottom:height];
                }
                
            }
        }

}
//
-(void)sendMessage:(NSString *)text
{
    NSLog(@"你输入的文字是 %@",text);
}
@end
