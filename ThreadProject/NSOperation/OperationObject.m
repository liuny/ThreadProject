//
//  OperationObject.m
//  ThreadProject
//
//  Created by liuny on 2018/4/17.
//  Copyright © 2018年 liuny. All rights reserved.
//

#import "OperationObject.h"

@implementation OperationObject
/*
 NSOperation 是个抽象类，不能用来封装操作。我们只有使用它的子类来封装操作。我们有三种方式来封装操作。
 
 使用子类 NSInvocationOperation
 使用子类 NSBlockOperation
 自定义继承自 NSOperation 的子类，通过实现内部相应的方法来封装操作。
*/

/************************在不使用 NSOperationQueue，单独使用 NSOperation 的情况下系统同步执行操作****************************/


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
        NSLog(@"taskOne");
    }];
    [op start];
}

#pragma mark - custom
@end
