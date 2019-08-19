//
//  ViewController.m
//  myStartRating
//
//  Created by mac on 2019/8/19.
//  Copyright © 2019 henry. All rights reserved.
//

#import "ViewController.h"
#import "CWStarRateView.h"

@interface ViewController ()<CWStarRateViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initpageView];
}

-(void)initpageView
{
    // 反馈产品
    
    //评价
    [self initStarsViewWithFrame:CGRectMake(20, 100, 200, 30) andTag:1];
    [self initStarsViewWithFrame:CGRectMake(20, 140, 200, 30) andTag:2];
    [self initStarsViewWithFrame:CGRectMake(20, 180, 200, 30) andTag:3];
    //反馈的问题
    
    //上传截图
    
}

-(void)initStarsViewWithFrame: (CGRect)frme  andTag:(int) tag
{
    CWStarRateView *starRateView = [[CWStarRateView alloc] initWithFrame:frme numberOfStars:5];
    starRateView.tag = tag;
    starRateView.allowIncompleteStar = NO;
    starRateView.hasAnimation = YES;
    starRateView.delegate = self;
    [self.view addSubview: starRateView];
}

- (void)starRateView:(CWStarRateView *)starRateView scroesDidChange:(NSUInteger)newScores
{
    if (starRateView.tag == 1) {
        NSLog(@"%lu==%ld",(unsigned long)newScores, (long)starRateView.tag);
    }
}

@end
