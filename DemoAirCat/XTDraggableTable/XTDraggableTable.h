//
//  XTDraggableTable.h
//  DemoAirCat
//
//  Created by teason on 2017/4/6.
//  Copyright © 2017年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol XTDraggableTableDelegate <NSObject>
- (void)pullup:(UIRefreshControl *)control ;
@end

@interface XTDraggableTable : UIView
@property (nonatomic,weak) id <XTDraggableTableDelegate> delegate ;
- (void)setup:(id)handler
   scrollView:(UIScrollView *)scrollView ;
@end
