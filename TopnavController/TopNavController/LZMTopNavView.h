//
//  LZMTopNavView.h
//  TopnavController
//
//  Created by 李泽明 on 16/5/13.
//  Copyright © 2016年 lizeming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LZMContentView;
typedef void(^myBlock)(NSInteger index);

@interface LZMTopNavView : UIView<UIScrollViewDelegate>

@property (copy, nonatomic) myBlock block;
@property (weak, nonatomic) UIScrollView *scrollview;
@property (weak, nonatomic) UIViewController *vc;

- (instancetype)initWithFrame:(CGRect)frame ChildsVcs:(NSMutableArray<LZMContentView *> *)childVcs;
- (void)clickChannel:(NSInteger)index;
@end
