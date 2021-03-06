//
//  ThreadView.h
//  Multithreading
//
//  Created by 田微微 on 16/6/15.
//  Copyright © 2016年 田微微. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MultiThreadingLoadDataBlock)(NSInteger index);

@interface ThreadView : UIView

- (void)setMultiBlock:(MultiThreadingLoadDataBlock)block;

- (void)updateImage:(NSData *)data;
@end
