//
//  AutoLayoutTextView.h
//  TextViewKeyBoardView
//
//  Created by amss on 15/12/8.
//  Copyright © 2015年 HuanXun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AutoLayoutTextViewDelegate <NSObject>

@optional

- (void)changeInputViewHeightConstraint:(CGFloat)height;

//- (void)appearAlertController:(NSString *)message;
-(void)sendMessage:(NSString*)text;  //  通过代理将文本框的文字发送出去

@end

@interface AutoLayoutTextView : UIView
@property(nonatomic,strong)UITextView* textView;
@property(nonatomic,strong)UILabel* placeHolder;
@property(nonatomic,strong)UIButton* sendButton;
@property(nonatomic,weak)id<AutoLayoutTextViewDelegate>delegate;

@property(nonatomic,assign)CGRect keyBoardUnShowFrame;
@property(nonatomic,assign)CGRect keyBoardShowFrame;
@property(nonatomic,assign)CGFloat keyBoardHeight;  // 键盘高度

@end

#pragma mark -- 这个是UIView的延展，我直接放在这个类里面了，你也可以在外部自己新建文件来写这个延展，区别就是你要自己倒入到视图控制器里面
@interface UIView(easyFrame)
-(CGFloat)height;
-(CGFloat)width;
-(CGFloat)MinX;
-(CGFloat)MinY;
-(CGFloat)MaxX;
-(CGFloat)MaxY;
-(CGFloat)MidX;
-(CGFloat)MidY;
-(void)resetHeightByNOChangeBottom:(CGFloat)height; // 左右和底部坐标不变，调整高度，重新制定高度
-(void)upGrowSpace:(CGFloat)space;  // 底部不变，在原来的基础上往上增高height
-(void)downGrowSpace:(CGFloat)space;
-(void)upMoveSpace:(CGFloat)space;
-(void)downMoveSpace:(CGFloat)space;
@end