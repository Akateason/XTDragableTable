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
static float const kAbovePullDown       = 150. ;



#import "XTDraggableTable.h"
#import "MJRefresh.h"


@interface XTDraggableTable () <UIScrollViewDelegate>
@property (nonatomic,strong) UITableView *mainTable     ; // ? main scrollview from handler ctrller
@property (nonatomic,strong) UITableView *aboveTable    ; // ? above view
@property (nonatomic,strong) NSArray     *gifs          ;
@end

@implementation XTDraggableTable

- (void)setup:(id)handler
{
    UIViewController *ctrller = handler ;
    self.delegate = handler ;

    self.mainTable = ({
        UITableView *containner = [[UITableView alloc] initWithFrame:APPFRAME] ;
        NSLog(@" rect %@ ",NSStringFromCGRect(APPFRAME)) ;
        containner.tag = kTagMainTable ;
        [ctrller.view addSubview:containner] ;
        containner.dataSource = handler ;
        containner.delegate = handler ;
        containner ;
    }) ;

    
    NSArray *idleImages = @[[self.gifs firstObject]] ;
    NSArray *pullingImages = self.gifs ;
    NSArray *refreshingImages = self.gifs ;
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataSelector)];
    [header setImages:idleImages forState:MJRefreshStateIdle];
    [header setImages:pullingImages forState:MJRefreshStatePulling];
    [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
    header.lastUpdatedTimeLabel.hidden = YES ;
//    header.stateLabel.hidden = YES ;
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle] ;
    [header setTitle:@"释放刷新" forState:MJRefreshStatePulling] ;
    [header setTitle:@"正在刷新" forState:MJRefreshStateRefreshing] ;
    [header setTitle:header.lastUpdatedTimeKey forState:MJRefreshStateWillRefresh] ;
    
    self.mainTable.mj_header = header;

    self.mainTable.contentInset = UIEdgeInsetsMake(self.mainTable.mj_header.mj_h + 20., 0, 0, 0) ;

    self.aboveTable = ({
        UITableView *containner = [[UITableView alloc] initWithFrame:ABOVEFRAME] ;
        containner.tag = kTagAboveTable ;
        [ctrller.view addSubview:containner] ;
        containner.dataSource = handler ;
        containner.delegate = handler ;
        containner ;
    }) ;
    
    

    // style for test .
    self.mainTable.mj_header.backgroundColor = [UIColor lightGrayColor] ;
}

- (void)loadNewDataSelector
{
    if ([self.mainTable.mj_header isRefreshing]) {
        [self.delegate pullup:self.mainTable.mj_header] ;
    }
}

- (void)headerEnding
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mainTable.mj_header endRefreshing];
    }) ;
}

- (NSArray *)gifs
{
    if (!_gifs) {
        NSMutableArray *tmplist = [@[] mutableCopy] ;
        for (int i = 0 ; i <= 40; i++) {
//            [tmplist addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Loading%@",@(i)]]] ;
            [tmplist addObject:[UIImage imageNamed:@"refresh"]] ;
        }
        _gifs = tmplist ;
    }
    return _gifs ;
}


#pragma mark - public
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
        // dragging main table . let above table display .
        if (scrollView.contentOffset.y < - kMAIN_PULLUP_OVERFLOW)
        {
            [self headerEnding] ;
            [UIView animateWithDuration:1.
                             animations:^{
                                 self.aboveTable.frame = APPFRAME ;
                                 self.mainTable.frame = BELOWFRAME ;
                             }
             
                             completion:^(BOOL finished) {
                                 [self.delegate pullupComplete] ;
             }] ;
        }
    }
    else if (scrollView.tag == kTagAboveTable)
    {
        // dragging above table .
        if (scrollView.contentOffset.y > kAbovePullDown)
        {
            [UIView animateWithDuration:1.
                             animations:^{
                                 self.aboveTable.frame = ABOVEFRAME ;
                                 self.mainTable.frame = APPFRAME ;
                             }
             
                             completion:^(BOOL finished) {
                                 [self.delegate pulldownComplete] ;
             }] ;
        }
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
