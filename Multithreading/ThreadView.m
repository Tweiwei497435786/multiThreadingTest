//
//  ThreadView.m
//  Multithreading
//
//  Created by 田微微 on 16/6/15.
//  Copyright © 2016年 田微微. All rights reserved.
//

#import "ThreadView.h"

@interface ThreadView()

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,copy) MultiThreadingLoadDataBlock block;

@end

@implementation ThreadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.button];
    }
    return self;
}

- (void)updateImage:(NSData *)data
{
    NSLog(@"updateImage....[NSThread currentThread].....:%@",[NSThread currentThread]);
    _imageView.image = [UIImage imageWithData:data];//在非主线程操作ui发现也没有问题,但是不建议这样做
}

#pragma mark -
#pragma mark accessor methods

- (UIImageView *)imageView
{
    if (!_imageView) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width/2.0)];
        _imageView.layer.borderColor = [[UIColor blueColor] CGColor];
        _imageView.layer.borderWidth = 1;
    }
    return _imageView;
}

- (UIButton *)button
{
    if (!_button) {
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake((self.frame.size.width - 100)/2.0, _imageView.frame.size.height + 5, 100, 30);
        [_button addTarget:self action:@selector(multiThreadingLoadData:) forControlEvents:UIControlEventTouchUpInside];
        [_button setTitle:@"加载图片" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    return _button;
}

- (void)setMultiBlock:(MultiThreadingLoadDataBlock)block
{
    self.block = block;
}

- (void)multiThreadingLoadData:(id)sender
{
    NSLog(@"点击按钮");
    _imageView.image = [UIImage imageNamed:@""];
    NSInteger random = arc4random() % 10;
    self.block(random);
}

@end
