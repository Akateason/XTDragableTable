//
//  PhicommHeader.m
//  DemoAirCat
//
//  Created by teason on 2017/4/10.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "PhicommHeader.h"

@interface PhicommHeader ()
@property (nonatomic,weak) UIImageView *aGifView ;
@end

@implementation PhicommHeader

- (void)prepare
{
    [super prepare];
    
    // readonly in super .
    self.aGifView = [self valueForKey:@"gifView"] ;
    // hide timelabel.
    self.lastUpdatedTimeLabel.hidden = YES ;
    // gifs
    [self configureGifs] ;
}

- (void)configureGifs
{
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=60; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
}


#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.aGifView.mj_w = self.mj_w * 0.5 - 30;
//    aGifView.backgroundColor = [UIColor blueColor] ;
//    self.stateLabel.backgroundColor = [UIColor yellowColor] ;
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
        {
//            self.aGifView.hidden = YES ;
            self.stateLabel.text = @"下拉刷新" ;
            self.stateLabel.text = [self.lastUpdatedTime description] ;
        }
            break;
        case MJRefreshStatePulling:
        {
//            self.aGifView.hidden = NO ;
            self.stateLabel.text = @"释放刷新" ;
        }
            break;
        case MJRefreshStateRefreshing:
        {
//            self.aGifView.hidden = NO ;
            self.stateLabel.text = @"正在刷新" ;
        }
            break;
        default:
            break;
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
