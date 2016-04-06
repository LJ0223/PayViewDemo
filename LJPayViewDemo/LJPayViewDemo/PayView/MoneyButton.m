//
//  MoneyButton.m
//  EasyFlowerCustomer
//
//  Created by 赵宇 on 15/5/29.
//  Copyright (c) 2015年 chenglin.zhao. All rights reserved.
//

#import "MoneyButton.h"

@implementation MoneyButton
@synthesize param = _param;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setParam:(NSString *)param
{
    _param = param;
}

- (NSString *)param
{
    return _param;
}

@end
