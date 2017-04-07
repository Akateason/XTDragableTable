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


@protocol XTDraggableTableDelegate <NSObject>
@required
- (void)pullup:(MJRefreshHeader *)header ;
- (void)pullupComplete ;
- (void)pulldownComplete ;
@end


@interface XTDraggableTable : UIView

@property (nonatomic,weak) id <XTDraggableTableDelegate> delegate ;

- (void)setup:(id)handler ;

- (void)manageScrollViewDidScroll:(UIScrollView *)scrollView ;
- (void)manageScrollViewWillEndDragging:(UIScrollView *)scrollView
                           withVelocity:(CGPoint)velocity
                    targetContentOffset:(inout CGPoint *)targetContentOffset ;

@end
