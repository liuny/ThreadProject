//
//  SaleTicketObject.h
//  ThreadProject
//
//  Created by liuny on 2018/4/18.
//  Copyright © 2018年 liuny. All rights reserved.
//

/*
 模拟火车票售卖的方式，实现 NSOperation 线程安全和解决线程同步问题。
 场景：总共有50张火车票，有两个售卖火车票的窗口，一个是北京火车票售卖窗口，另一个是上海火车票售卖窗口。两个窗口同时售卖火车票，卖完为止。
 */

#import <Foundation/Foundation.h>

@interface SaleTicketObject : NSObject
@property(readwrite,assign) int ticketCount;

//使用票数初始化
-(instancetype)initWithCount:(int)count;

//开启一个售票窗口
-(void)startSaleTickect:(BOOL)isSafe;
@end
