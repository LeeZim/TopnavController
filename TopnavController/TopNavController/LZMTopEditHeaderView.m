//
//  TTNewsTopChannelHeaderView.m
//  TTNews
//
//  Created by 李泽明 on 16/5/13.
//  Copyright © 2016年 lizeming. All rights reserved.
//

#import "LZMTopEditHeaderView.h"

@implementation LZMTopEditHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *sectionTitle = [[UILabel alloc] init];
        sectionTitle.textAlignment = NSTextAlignmentLeft;
        sectionTitle.frame = CGRectMake(10, 5, [UIScreen mainScreen].bounds.size.width, 21);
        self.labeltext = sectionTitle;
        [self addSubview:sectionTitle];
        
    }
    return self;
}
@end
