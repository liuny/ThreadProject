//
//  LNOperation.m
//  ThreadProject
//
//  Created by liuny on 2018/4/18.
//  Copyright © 2018年 liuny. All rights reserved.
//


#import "LNOperation.h"

@implementation LNOperation

-(void)main{
    if(!self.isCancelled){
        NSLog(@"custom operation-%@ ",[NSThread currentThread]);
    }
}

@end
