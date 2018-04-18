//
//  OperationObject.m
//  ThreadProject
//
//  Created by liuny on 2018/4/17.
//  Copyright © 2018年 liuny. All rights reserved.
//

#import "OperationObject.h"
#import "LNOperation.h"
#import "SaleTicketObject.h"

@interface OperationObject()
@property(nonatomic, strong) SaleTicketObject *saleTicketObject;
@end

@implementation OperationObject
/*
 NSOperation 是个抽象类，不能用来封装操作。我们只有使用它的子类来封装操作。我们有三种方式来封装操作。
 
 使用子类 NSInvocationOperation
 使用子类 NSBlockOperation
 自定义继承自 NSOperation 的子类，通过实现内部相应的方法来封装操作。
*/

/**在不使用 NSOperationQueue，单独使用 NSOperation 的情况下系统同步执行操作**/


-(void)taskOne{
    NSLog(@"taskOne");
}
#pragma mark - NSInvocationOperation
//不开启新线程，在当前线程执行
-(void)useInvocationOperation{
    // 1.创建 NSInvocationOperation 对象
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(taskOne) object:nil];
    // 2.调用 start 方法开始执行操作
    [op start];
}

#pragma mark - NSBlockOperation
//不开启新线程，在当前线程执行
-(void)useBlockOperation{
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"==%@==",[NSThread currentThread]);
    }];
    [op start];
}

/*使用子类 NSBlockOperation
 *调用方法 AddExecutionBlock:
 1、blockOperationWithBlock中的操作也可能会在其他线程（非当前线程）中执行，这是由系统决定的，并不是说添加到blockOperationWithBlock中的操作一定会在当前线程中执行。
 2、addExecutionBlock开启新线程。
 3、使用addExecutionBlock添加的任务是异步并行操作
 */
-(void)useBlockAddExecution{
    //
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"block--%@",[NSThread currentThread]);
    }];
    [op addExecutionBlock:^{
        NSLog(@"startOne");
        sleep(3);
        NSLog(@"executionOne--%@",[NSThread currentThread]);
    }];
    [op addExecutionBlock:^{
        NSLog(@"startTwo");
        sleep(2);
        NSLog(@"executionTwo--%@",[NSThread currentThread]);
    }];
    [op addExecutionBlock:^{
        NSLog(@"startThree");
        sleep(3);
        NSLog(@"executionThree--%@",[NSThread currentThread]);
    }];
    [op addExecutionBlock:^{
        NSLog(@"startFour");
        sleep(1);
        NSLog(@"executionFour--%@",[NSThread currentThread]);
    }];
    [op start];
}

#pragma mark - custom
-(void)useCustomOperation{
    LNOperation *op = [[LNOperation alloc] init];
    [op start];
}

#pragma mark - NSOperationQueue
//获取主队列
-(NSOperationQueue *)getMainOperationQueue{
    return [NSOperationQueue mainQueue];
}
//自定义队列
-(NSOperationQueue *)createCustomOperationQueue{
    return [[NSOperationQueue alloc] init];
}

-(void)useOperationQueue{
    NSOperationQueue *queue = [self createCustomOperationQueue];
    
    /*使用maxConcurrentOperationCount来控制队列是并发还是串行。
      maxConcurrentOperationCount=1时是串行
      maxConcurrentOperationCount默认是-1，表示不进行限制，可进行并发执行。
      maxConcurrentOperationCount 控制的不是并发线程的数量，而是一个队列中同时能并发执行的最大操作数
     */
    queue.maxConcurrentOperationCount = 1;
    //第一种方式添加operation
    [queue addOperationWithBlock:^{
        NSLog(@"start");
        sleep(3);
        NSLog(@"taskOne -%@ ",[NSThread currentThread]);
    }];
    
    //第二种方式添加
    NSInvocationOperation *opOne = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(taskOne) object:nil];
    [queue addOperation:opOne];
    
    //添加NSBlockOperation
    NSBlockOperation *opTwo = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"taskTwo -%@ ",[NSThread currentThread]);
    }];
    [queue addOperation:opTwo];
    [opTwo addExecutionBlock:^{
        NSLog(@"taskTwo Execution -%@ ",[NSThread currentThread]);
    }];
}


/*NSOperation操作依赖,适用于不同操作队列
 - (void)addDependency:(NSOperation *)op; 添加依赖
 - (void)removeDependency:(NSOperation *)op; 移除依赖
 @property (readonly, copy) NSArray<NSOperation *> *dependencies;查看依赖
 */
-(void)useOperationDependency{
    NSOperationQueue *queue = [self createCustomOperationQueue];
    NSBlockOperation *opOne = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"taskOne start");
        sleep(3);
        NSLog(@"taskOne -%@",[NSThread currentThread]);
    }];
    [opOne addExecutionBlock:^{
        NSLog(@"taskOne Exe start");
        sleep(1);
        NSLog(@"taskOne Exe -%@",[NSThread currentThread]);
    }];
    [queue addOperation:opOne];
    
    NSBlockOperation *opTwo = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"taskTwo -%@",[NSThread currentThread]);
    }];
    
    NSInvocationOperation *opThree = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(taskOne) object:nil];
    [queue addOperation:opThree];
    
    //注意添加顺序：要先添加依赖，再添加到queue中。不要相互循环依赖。
    [opTwo addDependency:opOne];
    [queue addOperation:opTwo];
}

//不同操作队列依赖测试
-(void)useOperationDependencyNotSameQueue{
    NSOperationQueue *queueOne = [self createCustomOperationQueue];
    NSOperationQueue *queueTwo = [self createCustomOperationQueue];
    NSBlockOperation *opOne = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"start taskOne");
        sleep(2);
        NSLog(@"taskOne -%@",[NSThread currentThread]);
    }];
    NSBlockOperation *opTwo = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"start taskTwo");
        NSLog(@"taskTwo -%@",[NSThread currentThread]);
    }];
    [opTwo addDependency:opOne];
    [queueOne addOperation:opOne];
    [queueTwo addOperation:opTwo];
}


/*NSOperation 优先级 适用于同一操作队列中的操作，不适用于不同操作队列中的操作
 queuePriority（优先级）属性,默认NSOperationQueuePriorityNormal
 // 优先级的取值
 typedef NS_ENUM(NSInteger, NSOperationQueuePriority) {
 NSOperationQueuePriorityVeryLow = -8L,
 NSOperationQueuePriorityLow = -4L,
 NSOperationQueuePriorityNormal = 0,
 NSOperationQueuePriorityHigh = 4,
 NSOperationQueuePriorityVeryHigh = 8
 };
 */
//注意：如果，一个队列中既包含了准备就绪状态的操作，又包含了未准备就绪的操作，未准备就绪的操作优先级比准备就绪的操作优先级高。那么，虽然准备就绪的操作优先级低，也会优先执行。优先级不能取代依赖关系。如果要控制操作间的启动顺序，则必须使用依赖关系
-(void)usePriorityForOperation{
    NSOperationQueue *queue = [self createCustomOperationQueue];
    NSBlockOperation *opOne = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"taskOne");
    }];
    opOne.queuePriority = NSOperationQueuePriorityLow;
    [queue addOperation:opOne];
    NSBlockOperation *opTwo = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"taskTwo");
    }];
    opTwo.queuePriority = NSOperationQueuePriorityHigh;
    [queue addOperation:opTwo];
    NSBlockOperation *opThree = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"taskThree");
    }];
    opThree.queuePriority = NSOperationQueuePriorityNormal;
    [queue addOperation:opThree];
    NSBlockOperation *opFour = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"taskFour");
    }];
    opFour.queuePriority = NSOperationQueuePriorityVeryHigh;
    [queue addOperation:opFour];
    NSBlockOperation *opFive = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"taskFive");
    }];
    opFive.queuePriority = NSOperationQueuePriorityVeryLow;
    [queue addOperation:opFive];
}

#pragma mark - 线程安全
-(void)saleTicketInShangHai:(BOOL)isSafe{
    if(!self.saleTicketObject){
        self.saleTicketObject = [[SaleTicketObject alloc] initWithCount:50];
    }
    //便于测试
    if(self.saleTicketObject.ticketCount <= 0){
        self.saleTicketObject.ticketCount = 50;
    }
    [self.saleTicketObject startSaleTickect:isSafe];
}

-(void)saleTicketInBeiJing:(BOOL)isSafe{
    if(!self.saleTicketObject){
        self.saleTicketObject = [[SaleTicketObject alloc] initWithCount:50];
    }
    //便于测试
    if(self.saleTicketObject.ticketCount <= 0){
        self.saleTicketObject.ticketCount = 50;
    }
    [self.saleTicketObject startSaleTickect:isSafe];
}
@end
