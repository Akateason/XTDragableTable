//
//  ViewController.m
//  DemoAirCat
//
//  Created by teason on 2017/4/6.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "ViewController.h"

#import "XTDraggableTable.h"

@interface ViewController () <XTDraggableTableDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic,strong) XTDraggableTable *draggableTable ;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.draggableTable = ({
        _draggableTable = [[XTDraggableTable alloc] init] ;
        [_draggableTable setup:self scrollView:self.table] ;
        _draggableTable ;
    }) ;
    
    
}

#pragma mark - XTDraggableTableDelegate
- (void)pullup:(UIRefreshControl *)control
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2ull * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 模拟请求结束 .
        [control endRefreshing] ;
        
    });
}












- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
