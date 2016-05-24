//
//  LZMTopNavView.m
//  TopnavController
//
//  Created by 李泽明 on 16/5/13.
//  Copyright © 2016年 lizeming. All rights reserved.
//

#import "LZMTopNavView.h"
#import "LZMButtonGroup.h"
#import "LZMTopEditViewController.h"

#define ChannelCount (self.childVcs.count >= 5 ? 5 : self.childVcs.count)
#define ChannelSelectedFont [UIFont systemFontOfSize:18.0]
#define ChannelNormalFont [UIFont systemFontOfSize:15.0]
#define SelfWidth self.bounds.size.width * 0.9
#define SelfHeight self.bounds.size.height
#define ViewDefaultColor [UIColor colorWithRed:236/255.0 green:235/255.0 blue:242/255.0 alpha:1]
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface LZMTopNavView ()


@property (weak, nonatomic) UIButton *selectedBtn;
@property (weak, nonatomic) UIView *redline;
@property (strong, nonatomic) NSArray *childVcs;
@property (strong, nonatomic) LZMButtonGroup *group;
@property (assign, nonatomic) BOOL enable;
@property (weak, nonatomic) LZMTopEditViewController *editVc;


@end
@implementation LZMTopNavView

- (instancetype)initWithFrame:(CGRect)frame ChildsVcs:(NSMutableArray *)childVcs
{
    self = [super initWithFrame:frame];
    if (self) {
        //背景色
        self.backgroundColor = [UIColor clearColor];
        
        self.enable = YES;
        
        _childVcs = childVcs;
        
        //border
        self.layer.borderWidth = 1;
        self.layer.borderColor = ViewDefaultColor.CGColor;
        
        //创建内部scrollview
        [self settingUI];
    }
    return self;
}

- (void)settingUI{
    UIScrollView *scrollview = [[UIScrollView alloc] init];
    scrollview.delegate = self;
    scrollview.frame = CGRectMake(0, 0, SelfWidth, SelfHeight);
    scrollview.backgroundColor = [UIColor whiteColor];
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.showsVerticalScrollIndicator = NO;
    self.scrollview = scrollview;
    [self addSubview:scrollview];
    scrollview.contentSize = CGSizeMake(self.scrollview.frame.size.width / ChannelCount * self.childVcs.count, 0);
    
    UIButton *editBtn = [[UIButton alloc] init];
    [editBtn setImage:[UIImage imageNamed:@"card_add"] forState:UIControlStateNormal];
    editBtn.frame = CGRectMake(SelfWidth, 0, self.bounds.size.width * 0.1, SelfHeight);
    [editBtn setBackgroundColor:ViewDefaultColor];
    [editBtn addTarget:self action:@selector(editChannel) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:editBtn];
    
    if(self.childVcs.count > 0)
    [self settingChannels];
}

- (void)settingChannels{
    LZMButtonGroup *group = [[LZMButtonGroup alloc] init];
    [group selectedStatusByUsingBlock:^(UIButton *button) {
        [self selectButton:button];
        if(self.block && self.enable)
        self.block([self.group indexOfButton:button]);
    }];
    
    [group normalStatusByUsingBlock:^(UIButton *button) {
        button.titleLabel.font = ChannelNormalFont;
    }];
    self.group = group;
    
    CGFloat btnW = self.scrollview.frame.size.width / ChannelCount;
    CGFloat btnH = 33;
    
    [self.childVcs enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat btnX = idx * btnW;
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:(NSString *)dict[@"title"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        btn.titleLabel.font = ChannelNormalFont;
        btn.frame = CGRectMake(btnX, 0, btnW, btnH);
        [self.scrollview addSubview:btn];
        [self.group addButton:btn];
        if(idx == 0) [self.group setDefaultButton:btn];
    }];
    UIView *redline = [[UIView alloc] initWithFrame:CGRectMake(0, 33, btnW, 2)];
    redline.backgroundColor = [UIColor redColor];
    self.redline = redline;
    [self.scrollview addSubview:redline];
}

- (void)clickChannel:(NSInteger)index{
    self.enable = NO;
    [self.group clickbtn:[self.group buttonAtIndex:index]];
    self.enable = YES;
}

- (void)selectButton:(UIButton *)button{
    
    CGFloat newX = button.center.x - self.scrollview.center.x;
    if(newX < 0) newX = 0;
    else if(newX > self.scrollview.contentSize.width - self.scrollview.frame.size.width){
        newX = self.scrollview.contentSize.width - self.scrollview.frame.size.width;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.redline.frame;
        frame.origin.x = button.frame.origin.x;
        self.redline.frame = frame;
        button.selected = YES;
        button.titleLabel.font = ChannelSelectedFont;
        [button layoutIfNeeded];
        self.scrollview.contentOffset = CGPointMake(newX, 0);
    }];
    [self.scrollview layoutIfNeeded];
}

- (void)editChannel{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.headerReferenceSize = CGSizeMake(ScreenWidth, 30);
    layout.itemSize = CGSizeMake(ScreenWidth / 5, 25);
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    LZMTopEditViewController *editVc = [[LZMTopEditViewController alloc] initWithCollectionViewLayout:layout];
    
    editVc.block = ^(NSMutableArray *arrM){
        self.childVcs = arrM;
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        self.scrollview = nil;
        [self settingUI];
    };
    
    editVc.title = @"频道定制";
    self.editVc = editVc;
    [self.vc.navigationController pushViewController:editVc animated:YES];
}


@end
