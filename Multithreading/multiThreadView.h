//
//  multiThreadView.h
//  Multithreading
//
//  Created by 田微微 on 16/6/15.
//  Copyright © 2016年 田微微. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiModel.h"

typedef void(^ConcurrentBlock)(NSInteger index,NSString *imageUrl);
typedef void(^ExitBlock)(void);

@interface MultiThreadView : UIView

- (void)setConcurrentBlock:(ConcurrentBlock)block;
- (void)exitConcurrentBlock:(ExitBlock)block;

- (void)updateImageView:(MultiModel *)model;
@end

