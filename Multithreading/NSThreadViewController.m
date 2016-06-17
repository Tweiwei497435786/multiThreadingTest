//
//  NSThreadViewController.m
//  Multithreading
//
//  Created by 田微微 on 16/6/15.
//  Copyright © 2016年 田微微. All rights reserved.
//


#import "NSThreadViewController.h"
#import "ThreadView.h"
#import "MultiThreadView.h"
#import "MultiModel.h"

@interface NSThreadViewController()

@property (nonatomic,strong) ThreadView *threadView;
@property (nonatomic,strong) MultiThreadView *multiThreadView;
@property (nonatomic,strong) NSMutableArray<NSThread *> *threadArray;

@end

@implementation NSThreadViewController

- (void)loadView
{
    [super loadView];
//    [self.view addSubview:self.threadView];
    [self.view addSubview:self.multiThreadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.threadArray = [NSMutableArray arrayWithCapacity:2];
}


#pragma mark -
#pragma mark accessor methods

- (ThreadView *)threadView
{
    if (!_threadView) {
        self.threadView = [[ThreadView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        __weak typeof(self) weakSelf = self;
        [_threadView setMultiBlock:^(NSInteger index) {
            [weakSelf multiThreadingLoadData:index];
        }];
    }
    return _threadView;
}

- (void)loadImage
{
    NSLog(@"loadImage....[NSThread currentThread].....:%@",[NSThread currentThread]);
    NSString *imageUrl = @"https://raw.githubusercontent.com/Tweiwei497435786/HexoResource/master/article/hangzhou_huangshan_lushu2.png";
    NSData *data = [self requestData:imageUrl];
    //[self updateImage:nil];
    [_threadView performSelector:@selector(updateImage:) onThread:[NSThread mainThread] withObject:data waitUntilDone:YES];
}



- (void)multiThreadingLoadData:(NSInteger)index
{
    index = 3;
    switch (index) {
        case 0:
        {
            //此时通过主线程操作，没有请求数据完成，主线程一直阻塞状态，没有请求完成无法返回到rootviewcontroller
            [self loadImage];
            break;
        }
        case 1:
        {
            //使用alloc的方式创建一个新的线程，不会阻塞当前的ui主线程的操作,无法有效的控制线程数量,管理线程的生命周期
            NSThread *myThread = [[NSThread alloc] initWithTarget:self selector:@selector(loadImage) object:nil];
            [myThread start];
            break;
        }
        case 2:
        {
            //通过类方法直接隐式创建,每次都会创建一条新的线程，无法有效的控制线程数量，管理线程的生命周期
            [NSThread detachNewThreadSelector:@selector(loadImage) toTarget:self withObject:nil];
            break;
        }
        case 3:
        {
            //通过类方法直接隐式创建,每次都会创建一条新的线程，无法有效的控制线程数量，管理线程的生命周期
            [self performSelectorInBackground:@selector(loadImage) withObject:nil];
            break;
        }
        default:
            break;
    }
}

- (NSData *)requestData:(NSString *)imageUrl
{
    NSURL *url = [NSURL URLWithString:imageUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    return data;
}

/*下面的为并发的操作*/
- (MultiThreadView *)multiThreadView
{
    if (!_multiThreadView) {
        self.multiThreadView = [[MultiThreadView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        __weak typeof(self) weakSelf = self;
        [_multiThreadView setConcurrentBlock:^(NSInteger index, NSString *imageUrl) {
            [weakSelf concurrentMulti:index imageUrl:imageUrl];
        }];
        
        [_multiThreadView exitConcurrentBlock:^{
            [weakSelf exitAllThread];
        }];
    }
    return _multiThreadView;
}

- (void)exitAllThread
{
    NSLog(@"取消所有的线程");
    //注意如果仅仅是在这里cancel，实际上是不能阻止子线程继续执行，还需要在线程加载数据的时候，取消掉exit
    [self.threadArray enumerateObjectsUsingBlock:^(NSThread * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isFinished]) {
            [obj cancel];
        }
    }];
}

- (void)concurrentMulti:(NSInteger)index imageUrl:(NSString *)imageUrl
{
    NSInteger random = arc4random() % 10;
    random = 4;
    MultiModel *model = [[MultiModel alloc] init];
    model.index = index;
    model.imagUrl = imageUrl;
    switch (random) {
        case 0:
        {
            //当前主线程阻塞，在点击加载按钮后图片没有请求完成的情况下无法，点击顶部的返回操作
            //所有图片全部请求完成后一起显示
            [self changeImage:model];
            break;
        }
        case 1:
        {
            //不能传递多个数据，如果要传递多个数据，需要封装为对象的方式传递
            //不会阻塞当前的主线程，点击加载按钮后，可点击返回，没有对线程进行管理，页面都释放后，线程继续执行相关的操作
            NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(changeImage:) object:model];
            thread.name = [NSString stringWithFormat:@"线程%ld",index];
            [thread start];
            break;
        }
        case 2:
        {
            //延迟加载第一张图片到最后展示
            NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(delay:) object:model];
            thread.name = [NSString stringWithFormat:@"线程%ld",index];
            [thread start];
            break;
        }
        case 3:
        {
            //延迟加载第一张图片到最后展示
            NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(priority:) object:model];
            thread.name = [NSString stringWithFormat:@"线程%ld",index];
            [thread start];
            break;
        }
        case 4:
        {
            //取消所有的线程操作
            NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(changeImageExit:) object:model];
            thread.name = [NSString stringWithFormat:@"线程%ld",index];
            [self.threadArray addObject:thread];
            [thread start];
            break;
        }
        default:
            break;
    }
}


- (void)changeImage:(MultiModel *)model
{
    NSLog(@"index....:%ld",model.index);
    NSData *data = [self requestData:model.imagUrl];
    model.imageData = data;
    //更新的操作放到主线程中操作
    [_multiThreadView performSelector:@selector(updateImageView:) onThread:[NSThread mainThread] withObject:model waitUntilDone:YES];
}

- (void)delay:(MultiModel *)model
{
    NSLog(@"index....:%ld",model.index);
    if (model.index == 0) {//控制最后一个，最后展示
        NSLog(@"[NSThread currentThread].....:%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:20];
    }
    NSData *data = [self requestData:model.imagUrl];
    model.imageData = data;
    //更新的操作放到主线程中操作
    [_multiThreadView performSelector:@selector(updateImageView:) onThread:[NSThread mainThread] withObject:model waitUntilDone:YES];
}

- (void)priority:(MultiModel *)model
{
    NSLog(@"index....:%ld",model.index);
    if (model.index == 8) {//控制最后一个最先加载，设置优先级最高
        NSLog(@"[NSThread currentThread].....:%@",[NSThread currentThread]);
        [NSThread setThreadPriority:1.0];
    }
    NSData *data = [self requestData:model.imagUrl];
    model.imageData = data;
    //更新的操作放到主线程中操作
    [_multiThreadView performSelector:@selector(updateImageView:) onThread:[NSThread mainThread] withObject:model waitUntilDone:YES];
}

- (void)changeImageExit:(MultiModel *)model
{
    NSLog(@"index....:%ld",model.index);
    if (model.index > 6) {
       [NSThread sleepForTimeInterval:2];//等待主线程中取消后2s再判断，7，8线程是否取消，取消后则退出当前线程，配合断点不怎好控制
        if ([[NSThread currentThread] isCancelled]) {//当前在主线程中已经被cancle了
            [NSThread exit];//取消掉当前的线程
        }
    }
    NSData *data = [self requestData:model.imagUrl];
    model.imageData = data;
    //更新的操作放到主线程中操作
    [_multiThreadView performSelector:@selector(updateImageView:) onThread:[NSThread mainThread] withObject:model waitUntilDone:YES];
}


@end
