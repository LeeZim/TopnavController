//
//  LZMTopViewController.m
//  TopnavController
//
//  Created by 李泽明 on 16/5/21.
//  Copyright © 2016年 lizeming. All rights reserved.
//

#import "LZMTopViewController.h"
#import "LZMTopNavView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height


@interface LZMTopViewController ()
@property (strong, nonatomic) NSMutableArray *childVcs;
@property (weak, nonatomic) LZMTopNavView *topnav;
@property (weak, nonatomic) UIScrollView *contentview;
@property (copy, nonatomic) NSString *plist;
@end

@implementation LZMTopViewController

- (instancetype)initWithPlist:(NSString *)plist
{
    self = [super init];
    if (self) {
        _plist = plist;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self buildTopView];
    [self buildContentView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rebuildContentView) name:@"editChannel" object:nil];
}

- (void)buildTopView{
    LZMTopNavView *topnav = [[LZMTopNavView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), [UIScreen mainScreen].bounds.size.width, 35) ChildsVcs:self.childVcs];
    topnav.vc = self;
    topnav.block = ^(NSInteger index){
        [self.contentview setContentOffset:CGPointMake(ScreenWidth * index, 0) animated:NO];
    };
    self.topnav = topnav;
    [self.view addSubview:topnav];
}

- (void)buildContentView{
    CGFloat scrollY = CGRectGetMaxY(self.topnav.frame);
    CGFloat scrollH = ScreenHeight - scrollY - (self.tabBarController.tabBar ? self.tabBarController.tabBar.frame.size.height : 0);
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, scrollY, ScreenWidth, scrollH)];
    scrollview.contentSize = CGSizeMake(ScreenWidth * self.childVcs.count, 0);
    scrollview.pagingEnabled = YES;
    scrollview.delegate = self;
    scrollview.showsHorizontalScrollIndicator = NO;
    self.contentview = scrollview;
    [self.view addSubview:scrollview];
    
    [self.childVcs enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat childVcX = idx * ScreenWidth;
        CGFloat childVcH = scrollH;
        CGFloat childVcW = ScreenWidth;
        
        Class classname = NSClassFromString(dict[@"contentview"]);
        UIView *content = [[classname alloc] initWithFrame:CGRectMake(childVcX, 0, childVcW, childVcH)];
        [scrollview addSubview:content];
    }];
}

- (void)rebuildContentView{
    self.childVcs = nil;
    [self.contentview removeFromSuperview];
    self.contentview = nil;
    [self buildContentView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger index = (scrollView.contentOffset.x + [UIScreen mainScreen].bounds.size.width * 0.5) / [UIScreen mainScreen].bounds.size.width;
    [self.topnav clickChannel:index];
}

- (NSMutableArray *)childVcs{
    if(!_childVcs){
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        path = [path stringByAppendingPathComponent:@"channellist.plist"];
        
        NSArray *arr = [NSArray arrayWithContentsOfFile:path];
        
        if(arr){
            _childVcs = arr[0];
        }else{
            arr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_plist ofType:nil]];
            _childVcs = arr[0];
            [arr writeToFile:path atomically:NO];
        }
    }
    return _childVcs;
}
@end
