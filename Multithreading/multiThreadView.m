//
//  multiThreadView.m
//  Multithreading
//
//  Created by 田微微 on 16/6/15.
//  Copyright © 2016年 田微微. All rights reserved.
//

#import "multiThreadView.h"

@interface MultiThreadView()

@property (nonatomic,copy) NSArray *imgUrlArray;
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,strong) UIButton *exitBtn;
@property (nonatomic,strong) NSMutableArray *imgViewArray;
@property (nonatomic,copy) ConcurrentBlock myBlock;
@property (nonatomic,copy) ExitBlock exitBlock;

@end

@implementation MultiThreadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imgViewArray = [NSMutableArray arrayWithCapacity:9];
        self.imgUrlArray = @[@"https://raw.githubusercontent.com/Tweiwei497435786/HexoResource/master/article/078CC6A2-339F-460E-8097-2D87AFDD8CFB.png",
                             @"https://raw.githubusercontent.com/Tweiwei497435786/HexoResource/master/article/1C0CBECF-6991-4960-ABC8-426B4F5174B9.png",
                             @"https://raw.githubusercontent.com/Tweiwei497435786/HexoResource/master/article/2016-01-13_4.56.29.png",
                             @"https://raw.githubusercontent.com/Tweiwei497435786/HexoResource/master/article/2016-01-13_4.56.29.png",
                             @"https://raw.githubusercontent.com/Tweiwei497435786/HexoResource/master/article/96C581C1-831C-463A-8F2E-547FFE618229.png",
                             @"https://raw.githubusercontent.com/Tweiwei497435786/HexoResource/master/article/FB38FDA1-F9BD-423C-8353-186994CBDBF1.png",
                             @"https://raw.githubusercontent.com/Tweiwei497435786/HexoResource/master/article/jiaodongbandao_lushu.png",
                             @"https://raw.githubusercontent.com/Tweiwei497435786/HexoResource/master/article/BC5F3ECA-AF6C-4E2F-8A83-133F85721BC3.png",
                             @"https://raw.githubusercontent.com/Tweiwei497435786/HexoResource/master/article/jiaodongbandao_lushu.png"
                             ];
        [self createImageView];
        [self addSubview:self.button];
        [self addSubview:self.exitBtn];
    }
    return self;
}

- (void)createImageView
{
    CGFloat seperatorWH = 10;
    CGFloat itemWH = (self.frame.size.width- 4*seperatorWH) /3.0;
    for (NSInteger i = 0; i< [_imgUrlArray count]; i++) {
        NSInteger row = i / 3;
        NSInteger line = i % 3;
        CGFloat oriX = seperatorWH * (line + 1) + itemWH * line;
        CGFloat oriY = seperatorWH * (row + 1) + itemWH * row;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(oriX, oriY, itemWH, itemWH)];
        imageView.layer.borderColor = [[UIColor blueColor] CGColor];
        imageView.layer.borderWidth = 1;
        imageView.tag = 1000 + i;
        [_imgViewArray addObject:imageView];
        [self addSubview:imageView];
    }
}

- (UIButton *)button
{
    if (!_button) {
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake((self.frame.size.width - 100)/2.0, self.frame.size.height - 64 - 60 - 50, 100, 30);
        [_button addTarget:self action:@selector(multiThreadingLoadData:) forControlEvents:UIControlEventTouchUpInside];
        [_button setTitle:@"加载图片" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    return _button;
}

- (UIButton *)exitBtn
{
    if (!_exitBtn) {
        self.exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _exitBtn.frame = CGRectMake((self.frame.size.width - 100)/2.0, self.frame.size.height - 64 - 50, 100, 30);
        [_exitBtn addTarget:self action:@selector(exitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_exitBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_exitBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    return _exitBtn;
}

- (void)multiThreadingLoadData:(id)sender
{
    NSLog(@"点击了加载图片");
    for (NSInteger i = 0; i < [_imgViewArray count]; i++) {
        [self loadImage:i];
    }
}

- (void)exitBtnClick:(id)sender
{
    self.exitBlock();
}

- (void)loadImage:(NSInteger)index
{
    NSString *imgUrl = [_imgUrlArray objectAtIndex:index];
    self.myBlock(index,imgUrl);
}

- (void)setConcurrentBlock:(ConcurrentBlock)block
{
    self.myBlock = block;
}


- (void)exitConcurrentBlock:(ExitBlock)block
{
    self.exitBlock = block;
}

- (void)updateImageView:(MultiModel *)model
{
    UIImageView *imageView = [_imgViewArray objectAtIndex:model.index];
    NSLog(@"imageView.tag.....:%ld",imageView.tag);
    imageView.image = [UIImage imageWithData:model.imageData];
}
@end
