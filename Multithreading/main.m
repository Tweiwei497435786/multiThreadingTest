//
//  main.m
//  Multithreading
//
//  Created by 田微微 on 16/6/15.
//  Copyright © 2016年 田微微. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    NSLog(@"应用程序启动的时候在main函数中创建了主线程.......:%@",[NSThread currentThread]);
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
