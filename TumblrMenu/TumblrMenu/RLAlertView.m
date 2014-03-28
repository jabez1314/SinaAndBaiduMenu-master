//
//  RLAlertView.m
//  TumblrMenu
//imae
//  Created by Richard Leung on 14-3-27.
//  Copyright (c) 2014年 HangChen. All rights reserved.
//

#import "RLAlertView.h"
#import "UIImage+ImageEffects.h"

@implementation RLAlertView
{
    UIImage *imageButton;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}
-(id)initBackgroundImage:(UIImage *)imageBackground andFrame:(CGRect )frame andImage:(UIImage*)image{
    if (self=[super initWithFrame:frame]) {
        
        _backgroundView =[[UIImageView alloc]initWithFrame:self.frame];
        _backgroundView.alpha = 1;
        _backgroundView.backgroundColor =[UIColor blackColor];
        //backgroundView_.alpha =0;
        
        UIImage *image =[imageBackground applyBlurWithRadius:2 tintColor:[UIColor colorWithWhite:100/255 alpha:0.1] saturationDeltaFactor:1.8 maskImage:nil];
        _backgroundView.image =image;
        //[backgroundView_ setImageToBlur:[UIImage imageNamed:@"IMG_3.jpg"] blurRadius:kLBBlurredImageDefaultBlurRadius completionBlock:nil];
        [self addSubview:_backgroundView];
        
        UIView *alertView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 150)];
        alertView.backgroundColor =[UIColor whiteColor];
        [alertView.layer setShadowColor:RGB(50, 50, 50).CGColor];
        [alertView.layer setShadowRadius:10];
        [alertView.layer setCornerRadius:10];
//        [alertView.layer setBorderWidth:1];
//        [alertView.layer setBorderColor:RGB(50, 50, 50).CGColor];
        [self addSubview:alertView];
        [alertView setCenter:self.center];
        UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        label.text =@"相机不可用";
        [alertView addSubview:label];
        [label setCenter:CGPointMake(alertView.center.x, alertView.frame.size.height/4)];
        
        UILabel *labelSub =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 280, 20)];
        labelSub.text =@"请先在 设置-隐私-相机 里开启服务";
        labelSub.font =[UIFont systemFontOfSize:12];
        labelSub.textAlignment =NSTextAlignmentCenter;
        labelSub.textColor =[UIColor grayColor];
        [alertView addSubview:labelSub];
        [labelSub setCenter:CGPointMake(alertView.center.x, alertView.frame.size.height*2/5)];
        
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor =RGB(69, 164, 72);
        button.layer.borderWidth = 0.5;
        button.layer.borderColor =RGB(50, 50, 50).CGColor;
        [button setTitle:@"我知道了" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(0, 0, 240, 40)];
        [alertView addSubview:button];
        [button setCenter:CGPointMake(alertView.frame.size.width/2, alertView.frame.size.height*3/4)];
        
        
    }
    return self;
}



- (UIImage *)resizeImageWithCapInsets:(UIEdgeInsets)capInsets {
    //CGFloat systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    CGFloat top = 25; // 顶端盖高度
    CGFloat bottom = 25 ; // 底端盖高度
    CGFloat left = 10; // 左端盖宽度
    CGFloat right = 10; // 右端盖宽度
    UIEdgeInsets inset = UIEdgeInsetsMake(top, left, bottom, right);
    imageButton = [self resizeImageWithCapInsets:inset];
    return imageButton;
}

- (void)show
{
    UIViewController *appRootViewController;
    
    UIWindow *window;
    
    window = [UIApplication sharedApplication].keyWindow;
    
    
    appRootViewController = window.rootViewController;
    
    
    
    UIViewController *topViewController = appRootViewController;
    while (topViewController.presentedViewController != nil)
    {
        topViewController = topViewController.presentedViewController;
    }
    
//    if ([topViewController.view viewWithTag:CHTumblrMenuViewTag]) {
//        [[topViewController.view viewWithTag:CHTumblrMenuViewTag] removeFromSuperview];
//    }
//
    self.frame = topViewController.view.bounds;
    [topViewController.view addSubview:self];
    
//    [UIView animateWithDuration:0.3 animations:^{
//        _backgroundView.alpha =1;
//    } completion:nil];
    
   // [self riseAnimation];
}

@end
