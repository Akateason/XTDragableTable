# XTDragableTable


抄之前淘宝个人主页的一个交互,
页面主体是tableview,上面有个下拉刷新控件.小范围滑动时触发下拉刷新. 大范围滑动时"切换到一个新的界面".
如何去实现一个交互动作. 我用了两种方案.

#方案1  
一个双tableview控件, 大范围滑动切换table, 小范围滑动下拉刷新 .
![1.gif](http://upload-images.jianshu.io/upload_images/838591-e199258063e1cf73.gif?imageMogr2/auto-orient/strip)

特性介绍

1. 灵活的协议接口. 按需求使用
2. 轻便的封装.初始化一行
3. 无需再处理scrollViewDelegate
4. 可调整大范围拖拽的高度.



```

@protocol XTDraggableTableMainDelegate <NSObject>
@required
- (void)main_pullup:(MJRefreshHeader *)header ; // [header endrefresh] when request complete or fail .
@optional
- (void)mainDisplayComplete ;
@end

@protocol XTDraggableTableAboveDelegate <NSObject>
@required
- (void)above_pullup:(MJRefreshHeader *)header ; // [header endrefresh] when request complete or fail .
@optional
- (void)aboveDisplayComplete ;
@end


@interface XTDraggableTable : UIView
@property (nonatomic,weak) id <XTDraggableTableMainDelegate>    mainDelegate    ;
@property (nonatomic,weak) id <XTDraggableTableAboveDelegate>   aboveDelegate   ;
@property (nonatomic,strong,readonly) UITableView *mainTable     ;
@property (nonatomic,strong,readonly) UITableView *aboveTable    ;
@property (nonatomic,assign) float mainDragHeight   ;
@property (nonatomic,assign) float aboveDragHeight  ;
// setup
- (void)setup:(id)handler ; // ctrller,mainHandler,aboveHandler
- (void)setupWithController:(UIViewController *)ctrller
mainHandler:(id)mainHandler
aboveHandler:(id)aboveHandler ;
// scrollViewDelegate
- (void)manageScrollViewDidScroll:(UIScrollView *)scrollView                    ;
- (void)manageScrollViewWillEndDragging:(UIScrollView *)scrollView
withVelocity:(CGPoint)velocity
targetContentOffset:(inout CGPoint *)targetContentOffset    ;
// reload table
- (void)reloadMain  ;
- (void)reloadAbove ;
@end

```



#方案2  
######原理介绍
利用原生`tableView`的`insertCell`动作插入一个cell.将新的页面绘制在这个cell上.并且自定义绘制一个`MJRefreshHeader`. 
插入之前可将新的cell的部分绘制到header里. 造成一种视差的效果.插入之后重新绘制这个diy的header. 在此我用的`MJRefresh`是个高度封装又有灵活性的第三方的下拉刷新控件.相信大家已经熟知.

![2.gif](http://upload-images.jianshu.io/upload_images/838591-4dc7ab72d5c6bdf4.gif?imageMogr2/auto-orient/strip)


.h
```

@class MJRefreshHeader ;

@protocol XTDragInsertCellViewDelegate <NSObject>
- (void)pullup:(MJRefreshHeader *)header ;
@end

@interface XTDragInsertCellView : UIView
@property (nonatomic)       float                               heightReset ;
@property (nonatomic,weak)  id <XTDragInsertCellViewDelegate>   delegate    ;
@property (nonatomic,strong,readonly) UITableView               *table      ;

- (instancetype)initWithHandler:(id)handler
heightReset:(float)height ;

- (NSInteger)rowsInfirstSection ;

- (void)manageScrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset ;
- (void)manageScrollViewDidScroll:(UIScrollView *)scrollView ;
@end

```
调用方便, 
```

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




```



