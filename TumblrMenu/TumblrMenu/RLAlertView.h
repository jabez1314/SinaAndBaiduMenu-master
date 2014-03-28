//
//  RLAlertView.h
//  TumblrMenu
//
//  Created by Richard Leung on 14-3-27.
//  Copyright (c) 2014年 HangChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RLAlertView : UIView
@property(nonatomic,strong)UIImageView *backgroundView;


-(id)initBackgroundImage:(UIImage *)imageBackground andFrame:(CGRect )frame andImage:(UIImage *)image;


- (void)show;
@end
