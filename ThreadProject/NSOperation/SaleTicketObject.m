//
//  SaleTicketObject.m
//  ThreadProject
//
//  Created by liuny on 2018/4/18.
//  Copyright © 2018年 liuny. All rights reserved.
//



#import "SaleTicketObject.h"

@interface SaleTicketObject()
@property(nonatomic, strong) NSLock *lock;
@end

@implementation SaleTicketObject
-(instancetype)initWithCount:(int)count{
    self = [super init];
    if(self){
        _ticketCount = count;
        self.lock = [[NSLock alloc] init];
    }
    return self;
}

-(void)startSaleTickect:(BOOL)isSafe{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 1;
    __weak typeof(self)weakSelf = self;
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        if(isSafe == YES){
            //线程安全的
            [weakSelf saleTicketSafe];
        }else{
            //非线程安全
            //在不考虑线程安全，不使用 NSLock 情况下，得到票数是错乱的
            [weakSelf saleTicket];
        }
    }];
    [queue addOperation:op];
}



-(void)saleTicket{
    while (1) {
        if(self.ticketCount > 0){
            //如果还有票，继续售卖
            _ticketCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数:%d 售票窗口:%@", self.ticketCount, [NSThread currentThread]]);
            //模拟耗时操作
            sleep(2);
        }else{
            NSLog(@"所有火车票均已售完");
            break;
        }
    }
}

-(void)saleTicketSafe{
    while (1) {
        if(self.ticketCount > 0){
            [self.lock lock];
            //如果还有票，继续售卖
            _ticketCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数:%d 售票窗口:%@", self.ticketCount, [NSThread currentThread]]);
            //模拟耗时操作
            sleep(2);
            [self.lock unlock];
        }else{
            NSLog(@"所有火车票均已售完");
            break;
        }
    }
}
@end
