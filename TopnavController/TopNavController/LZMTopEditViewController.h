//
//  LZMTopEditViewController.h
//  TopnavController
//
//  Created by 李泽明 on 16/5/21.
//  Copyright © 2016年 lizeming. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^editBlock)();
@interface LZMTopEditViewController : UICollectionViewController
{
    NSMutableArray<NSDictionary *> *_channelArrM;
}
@property (copy, nonatomic) editBlock block;
@end
