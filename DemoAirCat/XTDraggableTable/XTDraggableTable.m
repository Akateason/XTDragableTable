//
//  XTDraggableTable.m
//  DemoAirCat
//
//  Created by teason on 2017/4/6.
//  Copyright © 2017年 teason. All rights reserved.
//

#define APPFRAME                        [UIScreen mainScreen].bounds
#define APP_WIDTH                       CGRectGetWidth(APPFRAME)
#define APP_HEIGHT                      CGRectGetHeight(APPFRAME)
#define ABOVEFRAME                      CGRectMake(0, - APP_HEIGHT, APP_WIDTH, APP_HEIGHT)
#define BELOWFRAME                      CGRectMake(0, APP_HEIGHT, APP_WIDTH, APP_HEIGHT)

#define kMAIN_PULLUP_OVERFLOW           ( APP_HEIGHT / 4. + self.mainTable.mj_header.mj_h )
static float const kAbovePullDown       = 100. ;



#import "XTDraggableTable.h"
#import "MJRefresh.h"
#import "PhicommHeader.h"

@interface XTDraggableTable () <UIScrollViewDelegate>
@property (nonatomic,strong) UITableView *mainTable     ; // ? main scrollview from handler ctrller
@property (nonatomic,strong) UITableView *aboveTable    ; // ? above view
@end

@implementation XTDraggableTable

#pragma mark - public

- (void)setup:(id)handler
{
    UIViewController *ctrller = handler ;
    self.delegate = handler ;

    self.mainTable = ({
        UITableView *containner = [[UITableView alloc] initWithFrame:APPFRAME] ;
        containner.tag = kTagMainTable ;
        [ctrller.view addSubview:containner] ;
        containner.dataSource = handler ;
        containner.delegate = handler ;
        containner.mj_header = [self newHeader] ;
        containner.contentInset = UIEdgeInsetsMake(containner.mj_header.mj_h + 20., 0, 0, 0) ;
        containner ;
    }) ;
    
    self.aboveTable = ({
        UITableView *containner = [[UITableView alloc] initWithFrame:ABOVEFRAME] ;
        containner.tag = kTagAboveTable ;
        [ctrller.view addSubview:containner] ;
        containner.dataSource = handler ;
        containner.delegate = handler ;
        containner.mj_header = [self newHeader] ;
        containner.contentInset = UIEdgeInsetsMake(containner.mj_header.mj_h + 20., 0, 0, 0) ;
        containner ;
    }) ;

    // style for test //
    self.mainTable.mj_header.backgroundColor = [UIColor lightGrayColor] ;
    self.aboveTable.mj_header.backgroundColor = [UIColor lightGrayColor] ;
    // style for test //
}

- (void)manageScrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == kTagMainTable)
    {
        NSLog(@"main scrollViewDidScroll : %@",@(scrollView.contentOffset.y)) ;
    }
    else if (scrollView.tag == kTagAboveTable)
    {
        NSLog(@"above scrollViewDidScroll : %@",@(scrollView.contentOffset.y)) ;
    }
}

- (void)manageScrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView.tag == kTagMainTable)
    {
        // dragging main table . let above table display . pull up
        if (scrollView.contentOffset.y < - kMAIN_PULLUP_OVERFLOW)
        {
            [self.mainTable.mj_header endRefreshing];

            [UIView animateWithDuration:1.
                             animations:^{
                                 self.aboveTable.frame = APPFRAME ;
                                 self.mainTable.frame = BELOWFRAME ;
                             }
                             completion:^(BOOL finished) {
                                 if (self.delegate && [self.delegate respondsToSelector:@selector(aboveDisplayComplete)]) {
                                     [self.delegate aboveDisplayComplete] ;
                                 }
                                 
             }] ;
        }
    }
    else if (scrollView.tag == kTagAboveTable)
    {
        // dragging above table . let main table display . pull down
        if (scrollView.contentOffset.y > kAbovePullDown)
        {
            [UIView animateWithDuration:1.
                             animations:^{
                                 self.aboveTable.frame = ABOVEFRAME ;
                                 self.mainTable.frame = APPFRAME ;
                             }
                             completion:^(BOOL finished) {
                                 if (self.delegate && [self.delegate respondsToSelector:@selector(mainDisplayComplete)]) {
                                     [self.delegate mainDisplayComplete] ;
                                 }
             }] ;
        }
    }
}


#pragma mark - private

- (MJRefreshGifHeader *)newHeader
{
    PhicommHeader *header = [PhicommHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataSelector)] ;
    return header ;
}

- (void)loadNewDataSelector
{
    if ([self.mainTable.mj_header isRefreshing]) {
        [self.delegate main_pullup:self.mainTable.mj_header] ;
    }
    else if ([self.aboveTable.mj_header isRefreshing]) {
        [self.delegate above_pullup:self.aboveTable.mj_header] ;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
