//
//  XTDragInsertCellView.m
//  DemoAirCat
//
//  Created by teason on 2017/4/17.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "XTDragInsertCellView.h"
#import "Z1Header.h"
#import "Masonry.h"


@interface XTDragInsertCellView ()
@property (nonatomic)        BOOL           bAutoReset      ;
@property (nonatomic)        float          heightForBack   ;
@property (nonatomic)        BOOL           bPulledOut      ;
@property (nonatomic,strong) UITableView    *table          ;
@property (nonatomic,strong) Z1Header       *long_header    ;
@property (nonatomic,strong) DIYHeader      *normal_header  ;
@end

@implementation XTDragInsertCellView

- (instancetype)initWithHandler:(id)handler
                  heightForBack:(float)height
{
    return [self initWithHandler:handler
                       autoReset:true
                   heightForBack:height] ;
}

- (instancetype)initWithHandler:(id)handler
                      autoReset:(BOOL)autoReset
                  heightForBack:(float)height
{
    self = [super init] ;
    if (self)
    {
        self.bAutoReset     = autoReset ;
        self.delegate       = handler   ;
        self.heightForBack  = height    ;
        UIViewController *ctrller = handler ;
        
        self.table = ({
            UITableView *table = [UITableView new] ;
            [self addSubview:table] ;
            table.dataSource = handler ;
            table.delegate = handler ;
            table.mj_header = self.long_header ;
            [table mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0)) ;
            }] ;
            table ;
        }) ;
        
        [ctrller.view addSubview:self] ;
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0)) ;
        }] ;
    }
    return self ;
}

- (NSInteger)rowsInfirstSection
{
    return self.bPulledOut ? 1 : 0 ;
}

#pragma mark - prop

- (Z1Header *)long_header
{
    if (!_long_header) {
        _long_header = [Z1Header headerWithRefreshingTarget:self
                                           refreshingAction:@selector(loadNewDataSelector)] ;
    }
    return _long_header ;
}

- (DIYHeader *)normal_header
{
    if (!_normal_header) {
        _normal_header = [DIYHeader headerWithRefreshingTarget:self
                                              refreshingAction:@selector(loadNewDataSelector)] ;
    }
    return _normal_header ;
}

- (void)loadNewDataSelector
{
    NSLog(@"pull up") ;

    if (self.delegate && [self.delegate respondsToSelector:@selector(pullup:)]) {
        [self.delegate pullup:self.table.mj_header] ;
    }
}


#pragma mark - UIScrollViewDelegate
- (void)manageScrollViewWillEndDragging:(UIScrollView *)scrollView
                           withVelocity:(CGPoint)velocity
                    targetContentOffset:(inout CGPoint *)targetContentOffset
{
    float offsetY = scrollView.contentOffset.y ;
    UITableView *table = (UITableView *)scrollView ;
    
    // drag when 30% heightForBack //
    if (offsetY < - (self.heightForBack * 0.3) && self.bPulledOut == false)
    {
        // (@"do insert ") ;
        self.bPulledOut = true ;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [table insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop] ;
            [self.table.mj_header endRefreshing] ;
            self.table.mj_header = self.normal_header ;
        }] ;
    }
}

- (void)manageScrollViewDidScroll:(UIScrollView *)scrollView
{
    float offsetY = scrollView.contentOffset.y ;
//    NSLog(@"y : %f",offsetY) ;
    if (self.bPulledOut == true
        &&
        offsetY > self.heightForBack
        &&
        self.bAutoReset == true)
    {
        // reset
        self.bPulledOut = false ;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.table.mj_header = self.long_header ;
            [self.table reloadData] ;
        }] ;
    }
}





@end
