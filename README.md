# HBRunLoopThread
创建一个线程，在触发start方法时，通过代理方法触发RunLoop的时机，例如在即将进入RunLoop时添加使RunLoop持续运行的资源，在RunLoop已经退出时移除RunLoop资源。
# Usage
``` Objective-C
#import "HBRunLoopThread.h"
``` 
# Example
创建并开启线程：
``` Objective-C
HBRunLoopThread *thread = [[HBRunLoopThread alloc] init];
thread.runLoopThreadDelegate = self;
[thread start];
```
实现代理方法，以下是以NStimer为例子：
``` Objective-C
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
```
# Author
1021580211@qq.com
