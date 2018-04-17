//
//  LN_GCD.m
//  ThreadProject
//
//  Created by liuny on 2018/4/17.
//  Copyright © 2018年 liuny. All rights reserved.
//

#import "LN_GCD.h"

@implementation LN_GCD

#pragma mark - queue
//自定义并行队列
-(dispatch_queue_t)createConcurrentQueue{
    dispatch_queue_t queue = dispatch_queue_create("LN_Concurrent", DISPATCH_QUEUE_CONCURRENT);
    return queue;
}

//自定义串行队列
-(dispatch_queue_t)createSerialQueue{
    dispatch_queue_t queue = dispatch_queue_create("LN_Serial", DISPATCH_QUEUE_SERIAL);
    return queue;
}

//获取主线程串行队列
-(dispatch_queue_t)getMainSerialQueue{
    dispatch_queue_t queue = dispatch_get_main_queue();
    return queue;
}

//获取全局并发队列
-(dispatch_queue_t)getGlobalConcurrentQueue{
    /*
     * 第一个参数：优先级别
     DISPATCH_QUEUE_PRIORITY_HIGH
     DISPATCH_QUEUE_PRIORITY_DEFAULT
     DISPATCH_QUEUE_PRIORITY_LOW
     DISPATCH_QUEUE_PRIORITY_GACKGROUND
     */
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    return queue;
}

#pragma mark - task
//异步
-(void)addTaskWithAsyncInQueue:(dispatch_queue_t)queue{
    dispatch_async(queue, ^{
        NSLog(@"任务1开始");
        sleep(5);
        NSLog(@"任务1结束");
    });
    dispatch_async(queue, ^{
        NSLog(@"任务2开始");
        sleep(2);
        NSLog(@"任务2结束");
    });
    dispatch_async(queue, ^{
        NSLog(@"任务3开始");
        sleep(1);
        NSLog(@"任务3结束");
    });
}

//同步
-(void)addTaskWithSyncInQueue:(dispatch_queue_t)queue{
    dispatch_sync(queue, ^{
        NSLog(@"任务1开始");
        sleep(5);
        NSLog(@"任务1结束");
    });
    dispatch_sync(queue, ^{
        NSLog(@"任务2开始");
        sleep(2);
        NSLog(@"任务2结束");
    });
    dispatch_sync(queue, ^{
        NSLog(@"任务3开始");
        sleep(1);
        NSLog(@"任务3结束");
    });
}

#pragma mark - function
//异步+并行
-(void)lnAsyncConcurrent{
    dispatch_queue_t queue = [self createConcurrentQueue];
    NSLog(@"======start=====");
    [self addTaskWithAsyncInQueue:queue];
    NSLog(@"======end=====");
}
//异步+串行
-(void)lnAsyncSerial{
    dispatch_queue_t queue = [self createSerialQueue];
    NSLog(@"======start=====");
    [self addTaskWithAsyncInQueue:queue];
    NSLog(@"======end=====");
}
//异步+主队列
-(void)lnAsyncMain{
    dispatch_queue_t queue = dispatch_get_main_queue();
    NSLog(@"======start=====");
    [self addTaskWithAsyncInQueue:queue];
    NSLog(@"======end=====");
}
//同步+并行
-(void)lnSyncConcurrent{
    dispatch_queue_t queue = [self createConcurrentQueue];
    NSLog(@"======start=====");
    [self addTaskWithSyncInQueue:queue];
    NSLog(@"======end=====");
}
//同步+串行
-(void)lnSyncSerial{
    dispatch_queue_t queue = [self createSerialQueue];
    NSLog(@"======start=====");
    [self addTaskWithSyncInQueue:queue];
    NSLog(@"======end=====");
}
//同步+主队列
-(void)lnSyncMain{
    dispatch_queue_t queue = dispatch_get_main_queue();
    NSLog(@"======start=====");
    [self addTaskWithSyncInQueue:queue];
    NSLog(@"======end=====");
}

#pragma mark - 死锁测试
//嵌套 同步+并行 (不会产生死锁)
-(void)testForLock{
    dispatch_queue_t queue = [self createConcurrentQueue];
    NSLog(@"======start=====");
    dispatch_sync(queue, ^{
        NSLog(@"任务1开始");
        dispatch_sync(queue, ^{
            NSLog(@"任务2开始");
            NSLog(@"任务2结束");
        });
        NSLog(@"任务1结束");
    });
    NSLog(@"======end=====");
}

//嵌套 同步+串行（会产生死锁）
-(void)testForLockTwo{
    dispatch_queue_t queue = [self createSerialQueue];
    NSLog(@"======start=====");
    dispatch_sync(queue, ^{
        NSLog(@"任务1开始");
        dispatch_sync(queue, ^{
            NSLog(@"任务2开始");
            NSLog(@"任务2结束");
        });
        NSLog(@"任务1结束");
    });
    NSLog(@"======end=====");
}

//异步栅栏(多读单写场景)
-(void)lnAsyncBarrier{
    dispatch_queue_t queue = [self createConcurrentQueue];
    NSLog(@"======start=====");
    [self addTaskWithAsyncInQueue:queue];
    /*
     *1、等待dispatch_barrier_async之前的任务全部执行完
     *2、执行dispatch_barrier_async的任务
     *3、执行dispatch_barrier_async之后的任务
     */
    dispatch_barrier_async(queue, ^{
        NSLog(@"栅栏方法");
    });
    dispatch_async(queue, ^{
        NSLog(@"任务5开始");
        sleep(3);
        NSLog(@"任务5结束");
    });
    dispatch_async(queue, ^{
        NSLog(@"任务6开始");
        sleep(1);
        NSLog(@"任务6结束");
    });
    NSLog(@"======end=====");
}

//group queue
-(void)lnGroupQueue{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = [self createConcurrentQueue];
    //假设这个数组用于存放图片的下载地址
    NSArray *arrayURLs = @[@"图片下载地址1",@"图片下载地址2",@"图片下载地址3"];
    for(NSString *url in arrayURLs){
        dispatch_group_async(group, queue, ^{
            //根据url去下载图片
            
            NSLog(@"%@",url);
        });
    }
    //主线程上操作
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 当添加到组中的所有任务执行完成之后会调用该Block
        NSLog(@"所有图片已全部下载完成");
    });
}
@end
