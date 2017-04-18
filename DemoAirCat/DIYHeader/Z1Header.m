//
//  Z1Header.m
//  DemoAirCat
//
//  Created by teason on 2017/4/17.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "Z1Header.h"
#import "Zam1Cell.h"

@implementation Z1Header

- (void)prepare
{
    UIView *cell = [[[NSBundle mainBundle] loadNibNamed:@"Zam1Cell" owner:self options:nil] lastObject] ;
    cell.frame = CGRectMake(0, - ([Zam1Cell cellHeight]  - MJRefreshHeaderHeight), [UIScreen mainScreen].bounds.size.width, [Zam1Cell cellHeight] ) ;
    [self addSubview:cell] ;
    
    // call super prepare
    [super prepare] ;
}

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
