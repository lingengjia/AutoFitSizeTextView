//
//  AutoLayoutTextView.m
//  TextViewKeyBoardView
//
//  Created by amss on 15/12/8.
//  Copyright © 2015年 HuanXun. All rights reserved.
//

#import "AutoLayoutTextView.h"
#define kWidth self.bounds.size.width
#define kHeight self.bounds.size.height

#define TopSpace 4
#define BottomSpace 4

@interface AutoLayoutTextView()<UITextViewDelegate>

@end

@implementation AutoLayoutTextView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
       
        self.backgroundColor = [UIColor blackColor];
        
        self.keyBoardUnShowFrame = frame;
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(7, 4, kWidth-80-7, kHeight-8)];
        self.textView.delegate = self;
        self.textView.backgroundColor = [UIColor yellowColor];
        [self addSubview:self.textView];
        
        self.placeHolder = [[UILabel alloc] initWithFrame:CGRectMake(14, 5, CGRectGetWidth(self.textView.frame)-14, kHeight-10)];
        self.placeHolder.text = @"请在此输入评论内容";
        self.placeHolder.font = [UIFont systemFontOfSize:15];
        self.placeHolder.textColor = [UIColor colorWithWhite:0 alpha:0.3];
//        self.placeHolder.backgroundColor = [UIColor orangeColor];
        [self addSubview:self.placeHolder];
        
        self.sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.sendButton.frame = CGRectMake(CGRectGetMaxX(self.placeHolder.frame)+14, 4, kWidth-(CGRectGetMaxX(self.textView.frame)+8)-8, kHeight-8);
        
        [self.sendButton setImage:[[UIImage imageNamed:@"selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
         [self.sendButton setImage:[[UIImage imageNamed:@"unSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
//        [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
        
        self.sendButton.backgroundColor = [UIColor orangeColor];
        [self.sendButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.sendButton];
        
    
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.textView.frame = CGRectMake(7, 4, kWidth-80-7, kHeight-8);
     self.sendButton.frame = CGRectMake(CGRectGetMaxX(self.placeHolder.frame)+14, kHeight-4-30, kWidth-(CGRectGetMaxX(self.textView.frame)+8)-8, 30);
}

#pragma mark -- sendButtonAction
-(void)sendMessage:(UIButton*)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendMessage:)]) {
        [self.delegate sendMessage:self.textView.text];
    }
    
    if ([self.textView.text isEqualToString:@""]) {
        NSLog(@"请先输入内容，这里可以交给外部处理，通过代理");
    }else
    {
        self.textView.text = nil;
        self.placeHolder.hidden = NO;
        if (self.delegate && [self.delegate respondsToSelector:@selector(changeInputViewHeightConstraint:)]) {

                [self.delegate changeInputViewHeightConstraint:0];
        }
    }
    
}

#pragma mark -- UITextViewDelegate
#pragma mark - 回车键执行方法, 清空内容
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self sendMessage:nil];
        return NO;
    }
    return YES;
}

#pragma mark - textView的代理方法, 开始输出, 正在输入, 结束输入
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.placeHolder.hidden = textView.text.length > 0;
    //    [self.sendButton setImage:[UIImage imageNamed:@"fasong_normal"] forState:UIControlStateNormal];
//    self.placeHolder.hidden = YES;
    NSLog(@"开始编辑");
}

- (void)textViewDidChange:(UITextView *)textView
{

    self.placeHolder.hidden = textView.text.length > 0;
    
    NSLog(@"文字的高度  %f",textView.contentSize.height);
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeInputViewHeightConstraint:)]) {
        
                [self.delegate changeInputViewHeightConstraint:textView.contentSize.height];
    }
    NSLog(@"文字改变");
   
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.placeHolder.hidden = textView.text.length > 0;

    //    [self.sendButton setImage:[UIImage imageNamed:@"yuyin_normal"] forState:UIControlStateNormal];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeInputViewHeightConstraint:)]) {
        
            [self.delegate changeInputViewHeightConstraint:textView.contentSize.height];
    }
    NSLog(@"结束编辑");
}
@end


@implementation UIView(easyFrame)

-(CGFloat)height
{
    return self.frame.size.height;
}
-(CGFloat)width
{
    return self.frame.size.width;
}
-(CGFloat)MinX
{
    return CGRectGetMinX(self.frame);
}
-(CGFloat)MinY
{
    return CGRectGetMinY(self.frame);
}
-(CGFloat)MidX
{
    return CGRectGetMidX(self.frame);
}
-(CGFloat)MidY
{
    return CGRectGetMidY(self.frame);
}
-(CGFloat)MaxX
{
    return CGRectGetMaxX(self.frame);
}
-(CGFloat)MaxY
{
    return CGRectGetMaxY(self.frame);
}
-(void)resetHeightByNOChangeBottom:(CGFloat)height
{
    self.frame = CGRectMake(self.frame.origin.x, self.MaxY-height, self.width, height);
}
-(void)upGrowSpace:(CGFloat)space
{
    self.frame = CGRectMake(self.frame.origin.x, self.MinY-space, self.width, self.height+space);
}
-(void)downGrowSpace:(CGFloat)space
{
    self.frame = CGRectMake(self.frame.origin.x, self.MinY, self.width, space+self.height);
}
-(void)upMoveSpace:(CGFloat)space
{
    self.frame = CGRectMake(self.frame.origin.x, self.MinY-space, self.width, self.height);
}
-(void)downMoveSpace:(CGFloat)space
{
    self.frame = CGRectMake(self.frame.origin.x, self.MinY+space, self.width, self.height);
}
//-(CGFloat)X
//{
//    return self.frame.origin.x;
//}
//-(CGFloat)Y
//{
//    return self.frame.origin.y;
//}

@end