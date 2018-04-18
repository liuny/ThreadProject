//
//  OperationObject.h
//  ThreadProject
//
//  Created by liuny on 2018/4/17.
//  Copyright © 2018年 liuny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OperationObject : NSObject
//使用NSInvocationOperation封装任务
-(void)useInvocationOperation;


//使用NSBlockOperation封装任务
-(void)useBlockOperation;
-(void)useBlockAddExecution;

//自定义Operation
-(void)useCustomOperation;

//NSOperationQueue
-(void)useOperationQueue;
//operation依赖
-(void)useOperationDependency;
//不同操作队列依赖测试
-(void)useOperationDependencyNotSameQueue;
//优先级
-(void)usePriorityForOperation;

//线程安全
-(void)saleTicketInShangHai:(BOOL)isSafe;
-(void)saleTicketInBeiJing:(BOOL)isSafe;
@end
