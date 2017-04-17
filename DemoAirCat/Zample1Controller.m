//
//  Zample1Controller.m
//  DemoAirCat
//
//  Created by teason on 2017/4/17.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "Zample1Controller.h"
#import "Masonry.h"
#import "Zam1Cell.h"
#import "MJRefresh.h"
#import "Z1Header.h"

@interface Zample1Controller () <UITableViewDataSource,UITableViewDelegate>
{
    BOOL bPulled ;
}
@property (nonatomic,strong) UITableView    *table ;
@property (nonatomic,strong) Z1Header       *long_header ;
@property (nonatomic,strong) DIYHeader      *normal_header ;
@end

@implementation Zample1Controller

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone ;

    // Do any additional setup after loading the view.
    self.table = ({
        UITableView *table = [UITableView new] ;
        [table registerNib:[UINib nibWithNibName:@"Zam1Cell" bundle:nil] forCellReuseIdentifier:@"Zam1Cell"] ;
        [self.view addSubview:table] ;
        table.dataSource = self ;
        table.delegate = self ;
        table.mj_header = self.long_header ;
        [table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0)) ;
        }] ;
        table ;
    }) ;
}


#pragma mark -
- (Z1Header *)long_header
{
    if (!_long_header) {
        _long_header = [Z1Header headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataSelector)] ;
    }
    return _long_header ;
}

- (DIYHeader *)normal_header
{
    if (!_normal_header) {
        _normal_header = [DIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataSelector)] ;
    }
    return _normal_header ;
}


- (void)loadNewDataSelector
{
    NSLog(@"pull up") ;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2ull * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        bPulled = false ;
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.table.mj_header = self.long_header ;
            [self.table reloadData] ;
        }) ;
        
    
        // 模拟请求结束 .
        [self.table.mj_header endRefreshing] ;
    });

}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return bPulled ? 1 : 0 ;
    }
    else if (section == 1) {
        return 20 ;
    }
    return 0 ;
}

static NSString *const kIDCell = @"z1testCell" ;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = (int)indexPath.section ;
    
    if (section == 0) {
        Zam1Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"Zam1Cell" forIndexPath:indexPath] ;
        return cell ;
    }
    else if (section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIDCell] ;
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kIDCell] ;
        }
        cell.textLabel.text = [NSString stringWithFormat:@"row %d",(int)indexPath.row] ;
        return cell ;
    }
    
    return nil ;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = (int)indexPath.section ;
    
    if (section == 0) {
        return 244 ;
    }
    else if (section == 1) {
        return 44. ;
    }
    return 0 ;
}


#pragma mark -
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSLog(@"y : %f",scrollView.contentOffset.y) ;
    UITableView *table = (UITableView *)scrollView ;
    if (scrollView.contentOffset.y < - 100 && bPulled == false)
    {
        NSLog(@"do insert ") ;
        [self.table.mj_header endRefreshing] ;
        bPulled = true ;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.table.mj_header = self.normal_header ;
            [table insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                         withRowAnimation:UITableViewRowAnimationTop] ;
        }) ;
    }
    
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
