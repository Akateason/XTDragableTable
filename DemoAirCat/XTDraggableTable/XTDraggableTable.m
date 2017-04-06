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

#define kHEAD_OVERFLOWRANGE             APP_HEIGHT / 4.



#import "XTDraggableTable.h"

@interface XTDraggableTable () <UIScrollViewDelegate>
@property (nonatomic,strong) UIView *containner ; // ? above view
@property (nonatomic,strong) UIRefreshControl *control ; // ? header
@property (nonatomic,strong) UIScrollView *scrollView ; // scrollview from handler ctrller
@end

@implementation XTDraggableTable

- (void)setup:(id)handler
   scrollView:(UIScrollView *)scrollView
{
    UIViewController *ctrller = handler ;
    self.delegate = handler ;
    self.scrollView = scrollView ;
    scrollView.delegate = self ;
    
    self.control = ({
        UIRefreshControl *control = [[UIRefreshControl alloc] init] ;
        control.attributedTitle = [[NSAttributedString alloc] initWithString:@"test refreshing"] ;
        [control addTarget:self action:@selector(refreshStateChange:) forControlEvents:UIControlEventValueChanged];
        [scrollView addSubview:control];
        control ;
    }) ;
    
    self.containner = ({
        UIView *containner = [[UIView alloc] initWithFrame:ABOVEFRAME] ;
        [ctrller.view addSubview:containner] ;
        containner ;
    }) ;
    
    

    // style for test .
    self.control.tintColor = [UIColor grayColor] ;
    self.control.backgroundColor = [UIColor lightGrayColor] ;
    self.containner.backgroundColor = [UIColor blueColor] ;
}

- (void)refreshStateChange:(UIRefreshControl *)control
{
    NSLog(@"pull up") ;
    [self.delegate pullup:control] ;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidScroll : %@",@(scrollView.contentOffset.y)) ;
}

// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

// called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView.contentOffset.y < - kHEAD_OVERFLOWRANGE)
    {
        [self.control endRefreshing] ;
        [UIView animateWithDuration:1.
                         animations:^{
                             self.containner.frame = APPFRAME ;
                             self.scrollView.frame = BELOWFRAME ;
                         }] ;
    }
}
// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
// called on finger up as we are moving
{
   
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView      // called when scroll view grinds to a halt
{
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView // called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
{
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
