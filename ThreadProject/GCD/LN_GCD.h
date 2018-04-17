//
//  LN_GCD.h
//  ThreadProject
//
//  Created by liuny on 2018/4/17.
//  Copyright © 2018年 liuny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LN_GCD : NSObject
//异步+并行
-(void)lnAsyncConcurrent;
//异步+串行
-(void)lnAsyncSerial;
//异步+主队列
-(void)lnAsyncMain;
//同步+并行
-(void)lnSyncConcurrent;
//同步+串行
-(void)lnSyncSerial;
//同步+主队列
-(void)lnSyncMain;

//死锁测试
-(void)testForLock;
-(void)testForLockTwo;

//异步栅栏
-(void)lnAsyncBarrier;
//group queue
-(void)lnGroupQueue;
@end
