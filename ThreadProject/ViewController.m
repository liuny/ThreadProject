//
//  ViewController.m
//  ThreadProject
//
//  Created by liuny on 2018/4/17.
//  Copyright © 2018年 liuny. All rights reserved.
//

#import "ViewController.h"
#import "LN_GCD.h"
#import "OperationObject.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_gcdTableData;
    NSArray *_operationData;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) LN_GCD *gcdObject;
@property (nonatomic, strong) OperationObject *operationObject;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData{
    _gcdTableData = @[@"异步+并行",@"异步+串行",@"异步+主队列",@"同步+并行",@"同步+串行",@"同步+主队列(死锁)",@"死锁测试：同步+并行",@"死锁测试：同步+串行",@"异步栅栏",@"group queue + notify"];
    self.gcdObject = [[LN_GCD alloc] init];
    
    _operationData = @[@"NSInvocationOperation封装任务",@"NSBlockOperation封装任务",@"NSBlockOperation addExcecutionBlock",@"自定义NSOperation",@"NSOperationQueue",@"Operation依赖(同queue)",@"Operation依赖(不同queue)",@"优先级",@"线程非安全：开启上海、北京售票",@"线程安全：开启上海、北京售票"];
    self.operationObject = [[OperationObject alloc] init];
}

-(void)operationMethod:(NSInteger)index{
    switch (index) {
        case 0:
            [self.operationObject useInvocationOperation];
            break;
        case 1:
            [self.operationObject useBlockOperation];
            break;
        case 2:
            [self.operationObject useBlockAddExecution];
            break;
        case 3:
            [self.operationObject useCustomOperation];
            break;
        case 4:
            [self.operationObject useOperationQueue];
            break;
        case 5:
            [self.operationObject useOperationDependency];
            break;
        case 6:
            [self.operationObject useOperationDependencyNotSameQueue];
            break;
        case 7:
            [self.operationObject usePriorityForOperation];
            break;
        case 8:
            [self.operationObject saleTicketInShangHai:NO];
            [self.operationObject saleTicketInBeiJing:NO];
            break;
        case 9:
            [self.operationObject saleTicketInBeiJing:YES];
            [self.operationObject saleTicketInShangHai:YES];
            break;
        default:
            break;
    }
}

-(void)gcdMethod:(NSInteger)index{
    switch (index) {
        case 0:
            [self.gcdObject lnAsyncConcurrent];
            break;
        case 1:
            [self.gcdObject lnAsyncSerial];
            break;
        case 2:
            [self.gcdObject lnAsyncMain];
            break;
        case 3:
            [self.gcdObject lnSyncConcurrent];
            break;
        case 4:
            [self.gcdObject lnSyncSerial];
            break;
        case 5:
            [self.gcdObject lnSyncMain];
            break;
        case 6:
            [self.gcdObject testForLock];
            break;
        case 7:
            [self.gcdObject testForLockTwo];
            break;
        case 8:
            [self.gcdObject lnAsyncBarrier];
            break;
        case 9:
            [self.gcdObject lnGroupQueue];
            break;
        default:
            break;
    }
}

#pragma mark - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rtn = 0;
    switch (section) {
        case 0:
            rtn = _gcdTableData.count;
            break;
        case 1:
            rtn = _operationData.count;
            break;
        default:
            break;
    }
    return rtn;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = _gcdTableData[indexPath.row];
            break;
        case 1:
            cell.textLabel.text = _operationData[indexPath.row];
            break;
        default:
            break;
    }
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *rtn;
    switch (section) {
        case 0:
            rtn = @"GCD";
            break;
        case 1:
            rtn = @"Operation";
            break;
        default:
            break;
    }
    return rtn;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        //GCD
        [self gcdMethod:indexPath.row];
    }else if(indexPath.section == 1){
        //Operation
        [self operationMethod:indexPath.row];
    }
    
}

@end
