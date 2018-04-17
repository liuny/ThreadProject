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
@end
