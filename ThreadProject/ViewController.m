//
//  ViewController.m
//  ThreadProject
//
//  Created by liuny on 2018/4/17.
//  Copyright © 2018年 liuny. All rights reserved.
//

#import "ViewController.h"
#import "LN_GCD.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_gcdTableData;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) LN_GCD *gcdObject;

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
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rtn = 0;
    switch (section) {
        case 0:
            rtn = _gcdTableData.count;
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
            
        default:
            break;
    }
    return rtn;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        //GCD
        [self gcdMethod:indexPath.row];
    }
    
}

@end
