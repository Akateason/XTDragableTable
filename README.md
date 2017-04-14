# XTDragableTable


抄之前淘宝个人主页的一个交互,
一个双tableview控件, 大范围滑动切换table, 小范围滑动下拉刷新 .
![Paste_Image.png](http://upload-images.jianshu.io/upload_images/838591-693060f3dcac33fb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

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
