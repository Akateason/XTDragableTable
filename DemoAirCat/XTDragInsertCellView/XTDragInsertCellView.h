//
//  XTDragInsertCellView.h
//  DemoAirCat
//
//  Created by teason on 2017/4/17.
//  Copyright © 2017年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJRefreshHeader ;

@protocol XTDragInsertCellViewDelegate <NSObject>
- (void)pullup:(MJRefreshHeader *)header ;
@end

@interface XTDragInsertCellView : UIView

@property (nonatomic,weak)  id <XTDragInsertCellViewDelegate>   delegate    ;
@property (nonatomic,strong,readonly) UITableView               *table      ;

- (instancetype)initWithHandler:(id)handler
                  heightForBack:(float)height ;
- (instancetype)initWithHandler:(id)handler
                      autoReset:(BOOL)autoReset
                  heightForBack:(float)height ;

- (NSInteger)rowsInfirstSection ; // rewrite tableview datasource cellForRow 1st section ;

- (void)manageScrollViewWillEndDragging:(UIScrollView *)scrollView
                           withVelocity:(CGPoint)velocity
                    targetContentOffset:(inout CGPoint *)targetContentOffset ;
- (void)manageScrollViewDidScroll:(UIScrollView *)scrollView ;

@end



