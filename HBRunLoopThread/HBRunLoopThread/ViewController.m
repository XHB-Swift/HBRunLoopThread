//
//  ViewController.m
//  HBRunLoopThread
//
//  Created by 谢鸿标 on 2019/7/11.
//  Copyright © 2019 谢鸿标. All rights reserved.
//

#import "ViewController.h"
#import "HBRunLoopThread.h"

@interface ViewController () <HBRunLoopThreadDelegate>

@property (nonatomic, weak) NSTimer *testTimer;
@property (nonatomic, strong) NSMutableArray<HBRunLoopThread *> *threadsPool;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.threadsPool = [NSMutableArray array];
    UIButton *button1 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button1.frame = (CGRect){50,80,100,30};
    [button1 setTitle:@"计时" forState:(UIControlStateNormal)];
    [button1 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [button1 addTarget:self action:@selector(startCount:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button2.frame = (CGRect){50,120,100,30};
    [button2 setTitle:@"停止" forState:(UIControlStateNormal)];
    [button2 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [button2 addTarget:self action:@selector(stopCount:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button2];
}

- (void)startCount:(UIButton *)sender {
    HBRunLoopThread *thread = [[HBRunLoopThread alloc] init];
    thread.runLoopThreadDelegate = self;
    [thread start];
    [self.threadsPool addObject:thread];
}

- (void)stopCount:(UIButton *)sender {
    HBRunLoopThread *thread = self.threadsPool.firstObject;
    if (thread) {
        [self.threadsPool removeObject:thread];
    }
}

- (void)runLoopThread:(HBRunLoopThread *)thread willEnterRunLoop:(NSRunLoop *)runLoop {
    NSTimer *timer = [NSTimer timerWithTimeInterval:5.f target:self selector:@selector(timerAction:) userInfo:nil repeats:NO];
    [runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
    self.testTimer = timer;
}

- (void)runLoopThread:(HBRunLoopThread *)thread didExitRunLoop:(NSRunLoop *)runLoop {
    CFRunLoopRef r1 = runLoop.getCFRunLoop;
    CFRunLoopTimerRef timer = (__bridge CFRunLoopTimerRef)self.testTimer;
    CFRunLoopRemoveTimer(r1, timer, kCFRunLoopDefaultMode);
    NSLog(@"self.testTimer = %@", self.testTimer);
}

- (void)timerAction:(NSTimer *)sender {
    NSLog(@"sender = %@", sender);
}

@end
