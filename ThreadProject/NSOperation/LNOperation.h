//
//  LNOperation.h
//  ThreadProject
//
//  Created by liuny on 2018/4/18.
//  Copyright © 2018年 liuny. All rights reserved.
//


/*自定义继承自 NSOperation 的子类
 通过重写 main 或者 start 方法 来定义自己的 NSOperation 对象
 重写main方法比较简单，我们不需要管理操作的状态属性
 重写start方法，自行控制任务状态
 */


#import <Foundation/Foundation.h>

@interface LNOperation : NSOperation

@end
