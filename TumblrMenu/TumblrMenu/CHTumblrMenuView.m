//
//  CHTumblrMenuView.m
//  TumblrMenu
//
//  Created by HangChen on 12/9/13.
//  Copyright (c) 2013 Hang Chen (https://github.com/cyndibaby905)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "CHTumblrMenuView.h"
#define CHTumblrMenuViewTag 1999
#define CHTumblrMenuViewImageHeight 70
#define CHTumblrMenuViewTitleHeight 20
#define CHTumblrMenuViewVerticalPadding 10
#define CHTumblrMenuViewHorizontalMargin 10
#define CHTumblrMenuViewRriseAnimationID @"CHTumblrMenuViewRriseAnimationID"
#define CHTumblrMenuViewDismissAnimationID @"CHTumblrMenuViewDismissAnimationID"
#define CHTumblrMenuViewAnimationTime 0.36
#define CHTumblrMenuViewAnimationInterval (CHTumblrMenuViewAnimationTime / 5)
//#import "RLImageView.h"
#import "CHAppDelegate.h"
#import "UIImage+ImageEffects.h"
//#import "Global.h"


@interface CHTumblrMenuItemButton : UIControl
- (id)initWithTitle:(NSString*)title andIcon:(UIImage*)icon andSelectedBlock:(CHTumblrMenuViewSelectedBlock)block;
@property(nonatomic,copy)CHTumblrMenuViewSelectedBlock selectedBlock;
@end

@implementation CHTumblrMenuItemButton
{
    UIImageView *iconView_;
    UILabel *titleLabel_;
   
    
}
- (id)initWithTitle:(NSString*)title andIcon:(UIImage*)icon andSelectedBlock:(CHTumblrMenuViewSelectedBlock)block
{
    self = [super init];
    if (self) {
        iconView_ = [UIImageView new];
        iconView_.image = icon;
        titleLabel_ = [UILabel new];
        titleLabel_.textAlignment = NSTextAlignmentCenter;
        titleLabel_.backgroundColor = [UIColor clearColor];
        titleLabel_.textColor = [UIColor whiteColor];
        titleLabel_.text = title;
        _selectedBlock = block;
        [self addSubview:iconView_];
        [self addSubview:titleLabel_];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    iconView_.frame = CGRectMake(0, 0, CHTumblrMenuViewImageHeight, CHTumblrMenuViewImageHeight);
    titleLabel_.frame = CGRectMake(0, CHTumblrMenuViewImageHeight, CHTumblrMenuViewImageHeight, CHTumblrMenuViewTitleHeight);
}


@end

@implementation CHTumblrMenuView
{
    UIImageView *backgroundView_;
    NSMutableArray *buttons_;
    BOOL isRise;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.backgroundColor =[UIColor blackColor];
        
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
        ges.delegate = self;
        [self addGestureRecognizer:ges];
        [UIView animateWithDuration:0.2 animations:^{
            backgroundView_.alpha =1;
        }];
        //self.backgroundColor = [UIColor blackColor];
        buttons_ = [[NSMutableArray alloc] initWithCapacity:6];
    }
    return self;
}

-(void)initBackgroundImage:(UIImage *)imageBackground{
    backgroundView_ =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
    backgroundView_.backgroundColor =[UIColor blackColor];
    //backgroundView_.alpha =0;
    
    UIImage *image =[imageBackground applyBlurWithRadius:10 tintColor:[UIColor colorWithRed:70/255 green:70/255 blue:70/255 alpha:0.5] saturationDeltaFactor:1.8 maskImage:nil];
    backgroundView_.image =image;
    //[backgroundView_ setImageToBlur:[UIImage imageNamed:@"IMG_3.jpg"] blurRadius:kLBBlurredImageDefaultBlurRadius completionBlock:nil];
    [self addSubview:backgroundView_];
}

- (void)addMenuItemWithTitle:(NSString*)title andIcon:(UIImage*)icon andSelectedBlock:(CHTumblrMenuViewSelectedBlock)block
{
    CHTumblrMenuItemButton *button = [[CHTumblrMenuItemButton alloc] initWithTitle:title andIcon:icon andSelectedBlock:block];
    
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    button.tag =buttons_.count+100;
    [buttons_ addObject:button];
}

- (CGRect)frameForButtonAtIndex:(NSUInteger)index
{
    NSUInteger columnCount = 3;
    NSUInteger columnIndex =  index % columnCount;

    NSUInteger rowCount = buttons_.count / columnCount + (buttons_.count%columnCount>0?1:0);
    NSUInteger rowIndex = index / columnCount;

    CGFloat itemHeight = (CHTumblrMenuViewImageHeight + CHTumblrMenuViewTitleHeight) * rowCount + (rowCount > 1?(rowCount - 1) * CHTumblrMenuViewHorizontalMargin:0);
    CGFloat offsetY = (self.bounds.size.height - itemHeight) / 2.0;
    CGFloat verticalPadding = (self.bounds.size.width - CHTumblrMenuViewHorizontalMargin * 2 - CHTumblrMenuViewImageHeight * 3) / 2.0;
    
    CGFloat offsetX = CHTumblrMenuViewHorizontalMargin;
    offsetX += (CHTumblrMenuViewImageHeight+ verticalPadding-20) * columnIndex;
    
    offsetY += (CHTumblrMenuViewImageHeight + CHTumblrMenuViewTitleHeight + CHTumblrMenuViewVerticalPadding) * rowIndex;

    
    return CGRectMake(offsetX+20, offsetY+20, CHTumblrMenuViewImageHeight, (CHTumblrMenuViewImageHeight+CHTumblrMenuViewTitleHeight));

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (NSUInteger i = 0; i < buttons_.count; i++) {
        CHTumblrMenuItemButton *button = buttons_[i];
        if (isRise ==YES) {
            return;
            isRise =NO;
        }
        button.frame = [self frameForButtonAtIndex:i];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer.view isKindOfClass:[CHTumblrMenuItemButton class]]) {
        return NO;
    }
    
    CGPoint location = [gestureRecognizer locationInView:self];
    for (UIView* subview in buttons_) {
        if (CGRectContainsPoint(subview.frame, location)) {
            return NO;
        }
    }
    
    return YES;
}

- (void)dismiss:(id)sender
{
//    [UIView animateWithDuration:0.3 animations:^{
//        for (NSUInteger i = 0; i < buttons_.count; i++) {
//            CHTumblrMenuItemButton *button = buttons_[i];
//            [button setCenter:CGPointMake(self.center.x, self.center.y)];
//            button.alpha =0;
//        }
//    }];
//    [UIView animateWithDuration:0.4 animations:^{
//        for (NSUInteger i = 0; i < buttons_.count; i++) {
//            CHTumblrMenuItemButton *button = buttons_[i];
//            if (button.tag ==101) {
//                [button setFrame:CGRectMake(button.frame.origin.x, button.frame.origin.y, button.frame.size.width*2, button.frame.size.height*2)];
//            }else{
//                button.alpha =0;
//            }
//
//        }
//    } completion:^(BOOL finished) {
        for (NSUInteger i = 0; i < buttons_.count; i++) {
            CHTumblrMenuItemButton *button = buttons_[i];
            [button removeFromSuperview];
            button =nil;
            [self removeFromSuperview];
        }
//    }];
}


- (void)buttonTapped:(CHTumblrMenuItemButton*)btn
{
    isRise =YES;
    NSInteger tagBtn;
    __unsafe_unretained CHTumblrMenuView *menuView =self;
    CGRect frame =btn.frame;
    btn.layer.anchorPoint =CGPointMake(0.5, 0.5);
    btn.frame =frame;
    tagBtn = btn.tag;
    NSLog(@"%d",tagBtn);
    [UIView animateWithDuration:0.3 animations:^{
        btn.transform =CGAffineTransformScale(btn.transform, 1.5, 1.5);
        btn.alpha =0;
        for (int i = 0; i<6; i++) {
            UIButton *button =(UIButton *)[menuView viewWithTag:100+i];
            NSLog(@"%d",100+i);
            if (button.tag != tagBtn) {
                button.transform =CGAffineTransformScale(button.transform, 0.8, 0.8);
                button.alpha =0;
            }
        }
    }completion:^(BOOL finished) {
        [self dismiss:nil];
    }];
    double delayInSeconds = CHTumblrMenuViewAnimationTime  + CHTumblrMenuViewAnimationInterval * (buttons_.count + 1);
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        btn.selectedBlock();

    });
}


- (void)riseAnimation
{

    NSUInteger columnCount = 3;
    NSUInteger rowCount = buttons_.count / columnCount + (buttons_.count%columnCount>0?1:0);


    for (NSUInteger index = 0; index < buttons_.count; index++) {
        CHTumblrMenuItemButton *button = buttons_[index];
        button.layer.opacity = 0;
        CGRect frame = [self frameForButtonAtIndex:index];
        NSUInteger rowIndex = index / columnCount;
        NSUInteger columnIndex = index % columnCount;
        CGPoint fromPosition = CGPointMake(frame.origin.x + CHTumblrMenuViewImageHeight / 2.0,frame.origin.y +  (rowCount - rowIndex + 2)*200 + (CHTumblrMenuViewImageHeight + CHTumblrMenuViewTitleHeight) / 2.0);
        
        CGPoint toPosition = CGPointMake(frame.origin.x + CHTumblrMenuViewImageHeight / 2.0,frame.origin.y + (CHTumblrMenuViewImageHeight + CHTumblrMenuViewTitleHeight) / 2.0);
        
        double delayInSeconds = rowIndex * columnCount * CHTumblrMenuViewAnimationInterval;
        if (!columnIndex) {
            delayInSeconds += CHTumblrMenuViewAnimationInterval;
        }
        else if(columnIndex == 2) {
            delayInSeconds += CHTumblrMenuViewAnimationInterval * 2;
        }

        CABasicAnimation *positionAnimation;
        
        positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:fromPosition];
        positionAnimation.toValue = [NSValue valueWithCGPoint:toPosition];
        positionAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.45f :1.2f :0.75f :1.0f];
        positionAnimation.duration = CHTumblrMenuViewAnimationTime;
        positionAnimation.beginTime = [button.layer convertTime:CACurrentMediaTime() fromLayer:nil] + delayInSeconds;
        [positionAnimation setValue:[NSNumber numberWithUnsignedInteger:index] forKey:CHTumblrMenuViewRriseAnimationID];
        positionAnimation.delegate = self;
        
        [button.layer addAnimation:positionAnimation forKey:@"riseAnimation"];
    }
}

- (void)dropAnimation
{
    NSUInteger columnCount = 3;
    for (NSUInteger index = 0; index < buttons_.count; index++) {
        CHTumblrMenuItemButton *button = buttons_[index];
        CGRect frame = [self frameForButtonAtIndex:index];
        NSUInteger rowIndex = index / columnCount;
        NSUInteger columnIndex = index % columnCount;

        CGPoint toPosition = CGPointMake(frame.origin.x + CHTumblrMenuViewImageHeight / 2.0,frame.origin.y +  (rowIndex + 2)*200 + (CHTumblrMenuViewImageHeight + CHTumblrMenuViewTitleHeight) / 2.0);
        
        CGPoint fromPosition = CGPointMake(frame.origin.x + CHTumblrMenuViewImageHeight / 2.0,frame.origin.y + (CHTumblrMenuViewImageHeight + CHTumblrMenuViewTitleHeight) / 2.0);
        
        double delayInSeconds = rowIndex * columnCount * CHTumblrMenuViewAnimationInterval;
        if (!columnIndex) {
            delayInSeconds += CHTumblrMenuViewAnimationInterval;
        }
        else if(columnIndex == 2) {
            delayInSeconds += CHTumblrMenuViewAnimationInterval * 2;
        }
        CABasicAnimation *positionAnimation;
        
        positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:fromPosition];
        positionAnimation.toValue = [NSValue valueWithCGPoint:toPosition];
        positionAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.3 :0.5f :1.0f :1.0f];
        positionAnimation.duration = CHTumblrMenuViewAnimationTime;
        positionAnimation.beginTime = [button.layer convertTime:CACurrentMediaTime() fromLayer:nil] + delayInSeconds;
        [positionAnimation setValue:[NSNumber numberWithUnsignedInteger:index] forKey:CHTumblrMenuViewDismissAnimationID];
        positionAnimation.delegate = self;
        
        [button.layer addAnimation:positionAnimation forKey:@"riseAnimation"];
    }

}

- (void)animationDidStart:(CAAnimation *)anim
{
    NSUInteger columnCount = 3;
    if([anim valueForKey:CHTumblrMenuViewRriseAnimationID]) {
        NSUInteger index = [[anim valueForKey:CHTumblrMenuViewRriseAnimationID] unsignedIntegerValue];
        UIView *view = buttons_[index];
        CGRect frame = [self frameForButtonAtIndex:index];
        CGPoint toPosition = CGPointMake(frame.origin.x + CHTumblrMenuViewImageHeight / 2.0,frame.origin.y + (CHTumblrMenuViewImageHeight + CHTumblrMenuViewTitleHeight) / 2.0);
        CGFloat toAlpha = 1.0;
        
        view.layer.position = toPosition;
        view.layer.opacity = toAlpha;
        
    }
    else if([anim valueForKey:CHTumblrMenuViewDismissAnimationID]) {
        NSUInteger index = [[anim valueForKey:CHTumblrMenuViewDismissAnimationID] unsignedIntegerValue];
        NSUInteger rowIndex = index / columnCount;

        UIView *view = buttons_[index];
        CGRect frame = [self frameForButtonAtIndex:index];
        CGPoint toPosition = CGPointMake(frame.origin.x + CHTumblrMenuViewImageHeight / 2.0,frame.origin.y -  (rowIndex + 2)*200 + (CHTumblrMenuViewImageHeight + CHTumblrMenuViewTitleHeight) / 2.0);
        
        view.layer.position = toPosition;
    }
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
    
    if ([topViewController.view viewWithTag:CHTumblrMenuViewTag]) {
        [[topViewController.view viewWithTag:CHTumblrMenuViewTag] removeFromSuperview];
    }
    
    self.frame = topViewController.view.bounds;
    [topViewController.view addSubview:self];
    
    [self riseAnimation];
}


@end
