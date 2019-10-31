//
//  ChooseView.m
//  myStartRating
//
//  Created by henry wong on 2019/8/20.
//  Copyright © 2019 henry. All rights reserved.
//

#import "ChooseView.h"

@interface ChooseView()

@property(nonatomic, strong) NSArray *titles;
@property(nonatomic, strong) NSArray *selectedArr;

@end

@implementation ChooseView

-(instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles
{
    if (self = [super initWithFrame:frame]) {
        _titles = titles;
        [self buildDataAndUI];
    }
    return self;
}

-(void)buildDataAndUI
{
    
}

@end
