# XTDragableTable

双tableview, 大范围滑动切换, 带下拉刷新.

```
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
    self.draggableTable = ({
        XTDraggableTable *draggableTable = [XTDraggableTable new] ;
        [draggableTable setup:self] ;
        draggableTable ;
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
- (void)mainDisplayComplete
{
    NSLog(@"mainDisplayComplete") ;
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
```
