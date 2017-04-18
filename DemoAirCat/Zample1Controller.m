//
//  Zample1Controller.m
//  DemoAirCat
//
//  Created by teason on 2017/4/17.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "Zample1Controller.h"
#import "XTDragInsertCellView.h"
#import "Zam1Cell.h"
#import "MJRefresh.h"

static NSString *const kIDCell      = @"z1testCell" ;
static NSString *const kIDZam1Cell  = @"Zam1Cell" ;

@interface Zample1Controller () <UITableViewDataSource,UITableViewDelegate,XTDragInsertCellViewDelegate>
@property (nonatomic,strong) XTDragInsertCellView *insertView ;
@end

@implementation Zample1Controller

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone ;

    self.insertView = ({
        XTDragInsertCellView *view = [[XTDragInsertCellView alloc] initWithHandler:self heightReset:[Zam1Cell cellHeight]] ;
        [view.table registerNib:[UINib nibWithNibName:kIDZam1Cell bundle:nil] forCellReuseIdentifier:kIDZam1Cell] ;
        view ;
    }) ;
    
}


#pragma mark - XTDragInsertCellViewDelegate <NSObject>
- (void)pullup:(MJRefreshHeader *)header
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2ull * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 模拟请求结束 .
        [header endRefreshing] ;
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
        return [self.insertView rowsInfirstSection] ;
    }
    else if (section == 1) {
        return 20 ;
    }
    return 0 ;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = (int)indexPath.section ;
    
    if (section == 0) {
        Zam1Cell *cell = [tableView dequeueReusableCellWithIdentifier:kIDZam1Cell forIndexPath:indexPath] ;
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
        return [Zam1Cell cellHeight] ;
    }
    else if (section == 1) {
        return 44. ;
    }
    return 0 ;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    [self.insertView manageScrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset] ;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.insertView manageScrollViewDidScroll:scrollView] ;
}





#pragma mark -
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
