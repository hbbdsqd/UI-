//
//  ViewController.m
//  手势解锁demo
//
//  Created by 苏秋东 on 16/5/10.
//  Copyright © 2016年 com.hyde.carelink. All rights reserved.
//

#import "TouchIdUnlock.h"
#import "ViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.view.backgroundColor = [UIColor grayColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClick:(id)sender
{

    [[TouchIdUnlock sharedInstance] startVerifyTouchID:^{

        CGFloat red = ((arc4random() % 255)) / 256.0;
        CGFloat green = ((arc4random() % 255)) / 256.0;
        CGFloat blue = ((arc4random() % 255)) / 256.0;
        self.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];

        //        self.view.backgroundColor = [UIColor orangeColor];

    }];
}
@end
