//
//  CHViewController.m
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

#import "CHViewController.h"
#import "CHTumblrMenuView.h"
#import "RLAlertView.h"
#import "UIImage+ImageEffects.h"


@interface CHViewController ()
{
    UIImageView *imageView;
}

@end

@implementation CHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    imageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,320 , [UIScreen mainScreen].bounds.size.height)];
    [imageView setImage:[UIImage imageNamed:@"IMG_0642"]];
    [self.view addSubview:imageView];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"tabbar_compose_voice.png"] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:@"tabbar_compose_voice.png"] forState:UIControlStateNormal];
    button.frame = CGRectMake((self.view.bounds.size.width - 59)/2.0, (self.view.bounds.size.height - 48)/2.0, 75, 75);
    [button addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(button.frame.origin.x-5,button.frame.origin.y+80 , 75, 75)];
    label.text =@"点击弹出";
    label.textColor =[UIColor whiteColor];
    [self.view addSubview:label];
    
    UIButton *buttonWrong =[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonWrong setImage:[UIImage imageNamed:@"tabbar_compose_voice.png"] forState:UIControlStateHighlighted];
    [buttonWrong setImage:[UIImage imageNamed:@"tabbar_compose_voice.png"] forState:UIControlStateNormal];
    buttonWrong.frame = CGRectMake((self.view.bounds.size.width - 59)/2.0, (self.view.bounds.size.height - 48)/2.0-200, 75, 75);
    [buttonWrong addTarget:self action:@selector(showAlertView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonWrong];
    UILabel *label1 =[[UILabel alloc]initWithFrame:CGRectMake(buttonWrong.frame.origin.x-5,buttonWrong.frame.origin.y+80 , 75, 75)];
    label1.text =@"点击弹出";
    label1.textColor =[UIColor whiteColor];
    [self.view addSubview:label1];
    
}

-(void)showAlertView{
    RLAlertView *alertView =[[RLAlertView alloc]initBackgroundImage:[self captureImage] andFrame:self.view.frame andImage:[self captureImage]];
    
    //[alertView initBackgroundImage:[self captureImage]];
    [alertView show];
}

- (UIImage *)captureImage
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

- (void)showMenu
{
    [self.view drawViewHierarchyInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) afterScreenUpdates:YES];
    
    CHTumblrMenuView *menuView = [[CHTumblrMenuView alloc] init];
    
    [menuView initBackgroundImage:[self captureImage]];
    
    [menuView addMenuItemWithTitle:@"文字" andIcon:[UIImage imageNamed:@"tabbar_compose_idea.png"] andSelectedBlock:^{
        NSLog(@"Text selected");
    }];
    [menuView addMenuItemWithTitle:@"相册" andIcon:[UIImage imageNamed:@"tabbar_compose_photo.png"] andSelectedBlock:^{
        NSLog(@"Photo selected");
    }];
    [menuView addMenuItemWithTitle:@"拍照" andIcon:[UIImage imageNamed:@"tabbar_compose_camera.png"] andSelectedBlock:^{
        NSLog(@"Quote selected");

    }];
    [menuView addMenuItemWithTitle:@"签到" andIcon:[UIImage imageNamed:@"tabbar_compose_lbs.png"] andSelectedBlock:^{
        NSLog(@"Link selected");

    }];
    [menuView addMenuItemWithTitle:@"秒拍" andIcon:[UIImage imageNamed:@"tabbar_compose_shooting.png"] andSelectedBlock:^{
        NSLog(@"Chat selected");

    }];
    [menuView addMenuItemWithTitle:@"更多" andIcon:[UIImage imageNamed:@"tabbar_compose_more.png"] andSelectedBlock:^{
        NSLog(@"Video selected");

    }];
   
    [menuView show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
