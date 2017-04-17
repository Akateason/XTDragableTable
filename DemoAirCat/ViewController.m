//
//  ViewController.m
//  DemoAirCat
//
//  Created by teason on 2017/4/6.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import <objc/runtime.h>


@interface ViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"home" ;

    UITableView *table = [UITableView new] ;
    [self.view addSubview:table] ;
    table.dataSource = self ;
    table.delegate = self ;
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0)) ;
    }] ;
    
}

#pragma mark -
#pragma mark - UITableViewDataSource<NSObject>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2 ;
}

static NSString *const kIDCell = @"testCell" ;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIDCell] ;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kIDCell] ;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Zample%dController",(int)indexPath.row] ;
    return cell ;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *clsName = [NSString stringWithFormat:@"Zample%dController",(int)indexPath.row] ;
    Class ctrllerCls = objc_getRequiredClass([clsName UTF8String]) ;
    UIViewController *ctrller = [[ctrllerCls alloc] init] ;
    ctrller.title = clsName ;
    [self.navigationController pushViewController:ctrller animated:YES] ;
}







#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end



