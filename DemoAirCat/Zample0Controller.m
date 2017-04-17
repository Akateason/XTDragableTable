//
//  Zample0Controller.m
//  DemoAirCat
//
//  Created by teason on 2017/4/17.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "Zample0Controller.h"
#import "MJRefresh.h"
#import "XTDraggableTable.h"
#import "Masonry.h"

@interface Zample0Controller ()

@property (nonatomic,strong) UIImageView        *backImageView  ;

@property (nonatomic,strong) XTDraggableTable   *draggableTable ;

@end

@implementation Zample0Controller

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.edgesForExtendedLayout = UIRectEdgeNone ;
    
    self.backImageView = ({
        UIImageView *view = [UIImageView new] ;
        view.image = [UIImage imageNamed:@"h_back"] ;
        view.contentMode = UIViewContentModeScaleAspectFill ;
        [self.view addSubview:view] ;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0)) ;
        }] ;
        view ;
    }) ;
    
    self.draggableTable = ({
        XTDraggableTable *view = [XTDraggableTable new] ;
        [view setup:self] ;
        view ;
    }) ;
    
}




#pragma mark - XTDraggableTableDelegate
- (void)main_pullup:(MJRefreshHeader *)header
{
    NSLog(@"请求 main") ;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2ull * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 模拟请求结束 .
        [header endRefreshing] ;
    });
}

- (void)mainDisplayComplete
{
    NSLog(@"mainDisplayComplete") ;
}

- (void)above_pullup:(MJRefreshHeader *)header
{
    NSLog(@"请求 above") ;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2ull * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 模拟请求结束 .
        [header endRefreshing] ;
    });
}

- (void)aboveDisplayComplete
{
    NSLog(@"aboveDisplayComplete") ;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.draggableTable manageScrollViewDidScroll:scrollView] ;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    [self.draggableTable manageScrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset] ;
}

/*
 // called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
 - (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
 {
 
 }
 
 - (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
 // called on finger up as we are moving
 {
 
 }
 
 - (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView      // called when scroll view grinds to a halt
 {
 
 }
 
 - (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView // called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
 {
 
 }
 */










#pragma mark -
#pragma mark -
#pragma mark - UITableViewDataSource<NSObject>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == kTagMainTable) {
        return 10 ;
    }
    else if (tableView.tag == kTagAboveTable) {
        return 15 ;
    }
    
    return 0 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == kTagMainTable) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"test333"] ;
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test333"] ;
        }
        cell.textLabel.text = @"aaaaaaaaaaaaaaaaaaaaaaaaaa" ;
        cell.backgroundColor = nil ;
        return cell ;
    }
    else if (tableView.tag == kTagAboveTable) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"test333"] ;
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test333"] ;
        }
        cell.textLabel.text = @"bbbbbbbbbbbbbbbbbbbbbbbbbb" ;
        cell.backgroundColor =  nil ;
        return cell ;
    }
    
    return nil ;
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
