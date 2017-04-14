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





#import "XTDraggableTable.h"
#import "MJRefresh.h"
#import "PhicommHeader.h"

@interface XTDraggableTable () <UIScrollViewDelegate>
@property (nonatomic,strong,readwrite) UITableView *mainTable     ;
@property (nonatomic,strong,readwrite) UITableView *aboveTable    ;
@end

@implementation XTDraggableTable

#pragma mark - public
- (float)mainDragHeight
{
    if (!_mainDragHeight) {
        _mainDragHeight = ( APP_HEIGHT / 4. ) ;
    }
    return _mainDragHeight ;
}

- (float)aboveDragHeight
{
    if (!_aboveDragHeight) {
        _aboveDragHeight = 70. ;
    }
    return _aboveDragHeight ;
}


- (void)setup:(id)handler
{
    [self setupWithController:handler
                  mainHandler:handler
                 aboveHandler:handler] ;
}

- (void)setupWithController:(UIViewController *)ctrller
                mainHandler:(id)mainHandler
               aboveHandler:(id)aboveHandler
{
    self.mainDelegate = mainHandler ;
    self.aboveDelegate = aboveHandler ;
    
    self.mainTable = ({
        UITableView *containner = [[UITableView alloc] initWithFrame:APPFRAME] ;
        containner.tag = kTagMainTable ;
        [ctrller.view addSubview:containner] ;
        containner.dataSource = mainHandler ;
        containner.delegate = mainHandler ;
        containner.showsVerticalScrollIndicator = NO ;
        containner.separatorStyle = UITableViewCellSeparatorStyleNone ;
        containner.mj_header = [self newHeader] ;
        
        // 1stime default refresh .
        [containner.mj_header beginRefreshing] ;
        containner ;
    }) ;
    
    self.aboveTable = ({
        UITableView *containner = [[UITableView alloc] initWithFrame:ABOVEFRAME] ;
        containner.tag = kTagAboveTable ;
        [ctrller.view addSubview:containner] ;
        containner.dataSource = aboveHandler ;
        containner.delegate = aboveHandler ;
        containner.showsVerticalScrollIndicator = NO ;
        containner.separatorStyle = UITableViewCellSeparatorStyleNone ;
        containner.mj_header = [self newHeader] ;
        
        containner ;
    }) ;
    
    
    self.backgroundColor = nil ;
    self.mainTable.backgroundColor = nil ;
    self.aboveTable.backgroundColor = nil ;
}

- (void)manageScrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == kTagMainTable)
    {
        NSLog(@"main scrollViewDidScroll : %@",@(scrollView.contentOffset.y)) ;
//        NSLog(@"self.mainTable.mj_offsetY : %@",@(self.mainTable.mj_offsetY)) ;

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
        if (scrollView.contentOffset.y < - self.mainDragHeight)
        {
            [self.mainTable.mj_header endRefreshing];
            
            [UIView animateWithDuration:1.
                             animations:^{
                                 self.aboveTable.frame = APPFRAME ;
                                 self.mainTable.frame = BELOWFRAME ;
                             }
                             completion:^(BOOL finished) {
                                 if (self.aboveDelegate && [self.aboveDelegate respondsToSelector:@selector(aboveDisplayComplete)]) {
                                     [self.aboveDelegate aboveDisplayComplete] ;
                                 }
                                 
                             }] ;
        }
    }
    else if (scrollView.tag == kTagAboveTable)
    {
        // dragging above table . let main table display . pull down
        if (scrollView.contentOffset.y > self.aboveDragHeight)
        {
            [UIView animateWithDuration:1.
                             animations:^{
                                 self.aboveTable.frame = ABOVEFRAME ;
                                 self.mainTable.frame = APPFRAME ;
                             }
                             completion:^(BOOL finished) {
                                 if (self.mainDelegate && [self.mainDelegate respondsToSelector:@selector(mainDisplayComplete)]) {
                                     [self.mainDelegate mainDisplayComplete] ;
                                 }
                             }] ;
        }
    }
}


- (void)reloadMain
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mainTable reloadData] ;
    }) ;
}

- (void)reloadAbove
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.aboveTable reloadData] ;
    }) ;
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
        [self.mainDelegate main_pullup:self.mainTable.mj_header] ;
    }
    else if ([self.aboveTable.mj_header isRefreshing]) {
        [self.aboveDelegate above_pullup:self.aboveTable.mj_header] ;
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
