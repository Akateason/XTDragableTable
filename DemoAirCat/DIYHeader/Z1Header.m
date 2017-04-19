//
//  Z1Header.m
//  DemoAirCat
//
//  Created by teason on 2017/4/17.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "Z1Header.h"
#import "Zam1Cell.h"

@interface Z1Header ()
@property (nonatomic,strong) UIView *cell ;
@end

@implementation Z1Header

- (void)setBHideBack:(BOOL)bHideBack
{
    _bHideBack = bHideBack ;
    
    self.cell.hidden = bHideBack ;
}

- (void)prepare
{
    self.cell = ({
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"Zam1Cell" owner:self options:nil] lastObject] ;
        view.frame = CGRectMake(0, - ([Zam1Cell cellHeight]  - MJRefreshHeaderHeight), [UIScreen mainScreen].bounds.size.width, [Zam1Cell cellHeight] ) ;
        [self addSubview:view] ;
        view ;
    });
    
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
