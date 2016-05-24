//
//  LZMTopEditViewController.m
//  TopnavController
//
//  Created by 李泽明 on 16/5/21.
//  Copyright © 2016年 lizeming. All rights reserved.
//

#import "LZMTopEditViewController.h"
#import "LZMTopEditHeaderView.h"
@interface LZMTopEditViewController ()
@property (strong, nonatomic) NSMutableArray *ChannelList;
@end

@implementation LZMTopEditViewController

static NSString * const reuseIdentifier = @"Cell";



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerClass:[LZMTopEditHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finishEdit)];
    self.navigationItem.rightBarButtonItem = backBtn;
    self.tabBarController.tabBar.hidden = YES;
    
//    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    
    [self.collectionView addGestureRecognizer:pan];
//    [self.collectionView addGestureRecognizer:longpress];

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [self.ChannelList[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell.subviews[0] removeFromSuperview];
    NSMutableArray *arrM = self.ChannelList[indexPath.section];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = cell.bounds;
    btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btn.layer.borderWidth = 1;
    btn.layer.cornerRadius = btn.frame.size.height * 0.5;
    btn.tag = indexPath.item;
    [btn setTitle:arrM[indexPath.item][@"title"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(channelBtn:) forControlEvents:UIControlEventTouchUpInside];
    if(indexPath.section == 1) btn.selected = YES;
    [cell addSubview:btn];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    LZMTopEditHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    
    header.labeltext.text = indexPath.section == 0 ? @"点击取消选择，拖动排序" : @"点击选择频道";
    return  header;
}

#pragma mark - 手势方法 - 拖拽排序
- (void)panAction:(UIPanGestureRecognizer *)pan{
    NSIndexPath *indexpath = [self.collectionView indexPathForItemAtPoint:[pan locationInView:self.collectionView]];
    if(indexpath.section != 0){
        [self.collectionView endInteractiveMovement];
        [self.collectionView cancelInteractiveMovement];
        return;
    }
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{
            if(indexpath == nil){
                break;
            }
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexpath];
        }
        case UIGestureRecognizerStateChanged:
            if(indexpath.section == 0)
                [self.collectionView updateInteractiveMovementTargetPosition:[pan locationInView:self.collectionView]];
            break;
        case UIGestureRecognizerStateEnded:
            [self.collectionView endInteractiveMovement];
            break;
        default:
            [self.collectionView cancelInteractiveMovement];
            break;
    }
}

#pragma mark - 代理方法 - collection元素排序
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    NSDictionary *dict = self.ChannelList[0][sourceIndexPath.item];
    [self.ChannelList[0] removeObjectAtIndex:sourceIndexPath.item];
    [self.ChannelList[0] insertObject:dict atIndex:destinationIndexPath.item];
}

#pragma mark - 代理方法 - 允许collection元素移动
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)finishEdit{
    self.block(self.ChannelList[0]);
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    path = [path stringByAppendingPathComponent:@"channellist.plist"];
    
    [self.ChannelList writeToFile:path atomically:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"editChannel" object:nil];
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)channelBtn:(UIButton *)sender{
    if(sender.isSelected && [self.ChannelList[1] count] > 1){
        NSDictionary *dict = self.ChannelList[1][sender.tag];
        [self.ChannelList[1] removeObjectAtIndex:sender.tag];
        [self.ChannelList[0] addObject:dict];
    }else if(!sender.isSelected  && [self.ChannelList[0] count] > 1){
        NSDictionary *dict = self.ChannelList[0][sender.tag];
        [self.ChannelList[0] removeObjectAtIndex:sender.tag];
        [self.ChannelList[1] addObject:dict];
    }
    sender.selected = !sender.isSelected;
    [self.collectionView reloadData];
}

- (void)setChannelArrM:(NSMutableArray<NSDictionary *> *)channelArrM{
    _channelArrM = channelArrM;

}

- (NSMutableArray *)ChannelList{
    if(!_ChannelList){
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        path = [path stringByAppendingPathComponent:@"channellist.plist"];
        
        NSMutableArray *arrM = [NSMutableArray arrayWithContentsOfFile:path];

        _ChannelList = [NSMutableArray arrayWithArray:arrM];
    }
    return _ChannelList;
}


@end
