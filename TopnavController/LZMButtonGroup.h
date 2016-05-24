//
//  LZMGourp.h
//  LZMGroupButton
//
//  Created by 李泽明 on 16/5/21.
//  Copyright © 2016年 lizeming. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^clickBlock)(UIButton *button);
@interface LZMButtonGroup : NSObject
- (void)addButton:(UIButton *)btn;
- (void)normalStatusByUsingBlock:(clickBlock)block;
- (void)selectedStatusByUsingBlock:(clickBlock)block;
- (UIButton *)buttonAtIndex:(NSInteger)index;
- (NSInteger)indexOfButton:(UIButton *)button;
- (void)setDefaultButton:(UIButton *)button;
- (void)clickbtn:(UIButton *)btn;
@end
