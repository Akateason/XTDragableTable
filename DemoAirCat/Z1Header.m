//
//  Z1Header.m
//  DemoAirCat
//
//  Created by teason on 2017/4/17.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "Z1Header.h"

@implementation Z1Header

- (void)prepare
{
    UIView *cell = [[[NSBundle mainBundle] loadNibNamed:@"Zam1Cell" owner:self options:nil] lastObject] ;
    cell.frame = CGRectMake(0, - (244 - MJRefreshHeaderHeight), [UIScreen mainScreen].bounds.size.width, 244) ;
    [self addSubview:cell] ;
    
    
    [super prepare] ;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews] ;    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
