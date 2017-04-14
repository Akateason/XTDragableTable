//
//  XTDraggableTable.h
//  DemoAirCat
//
//  Created by teason on 2017/4/6.
//  Copyright © 2017年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJRefreshHeader ;


static const int kTagMainTable          = 12120 ;
static const int kTagAboveTable         = 12121 ;


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
