//
//  ChooseView.h
//  myStartRating
//
//  Created by henry wong on 2019/8/20.
//  Copyright © 2019 henry. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ChooseView;
@protocol CustomChooseViewDelegate<NSObject>

-(void)chooseView:(ChooseView *) chooseView selectedResult:(NSArray *) resultStrArr;

@end

@interface ChooseView : UIView

@property(nonatomic, weak) id<CustomChooseViewDelegate>delegate;

@property(nonatomic, assign) BOOL isSingleChoose;

@end

NS_ASSUME_NONNULL_END
