//
//  PaymentMethodView.m
//  LJPayViewDemo
//
//  Created by 罗金 on 16/4/1.
//  Copyright © 2016年 EasyFlower. All rights reserved.
//

#import "PaymentMethodView.h"

@interface PaymentMethodView ()

@property (nonatomic, strong) UIButton *leftBtn;

@property (nonatomic, strong) UIButton *weichatPayBtn; // 微信支付
@property (nonatomic, strong) UIButton *aliPayBtn;     // 支付宝支付

@end

@implementation PaymentMethodView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self LayoutUIs];
    }
    return self;
}

#pragma mark - 支付方式选中方法
- (void)payMethodCheckClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(PaymentMethodViewCheckPayMentAction:)]) {
        [self.delegate PaymentMethodViewCheckPayMentAction:sender];
        [self returnToPayView];
    }
}

- (void)LayoutUIs
{
    //1.创建btn
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height-80);
    // 2.设置按钮的图片
      [_leftBtn setImage:[UIImage imageNamed:@"tabbar_compose_background_icon_return"] forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:@selector(returnToPayView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_leftBtn];
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(25);
    }];
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.font = [UIFont systemFontOfSize:14.0f];
    titleLab.textColor = CLColor(51, 51, 51);
    titleLab.text = @"选择支付方式";
    titleLab.textAlignment = NSTextAlignmentLeft;
    [self addSubview:titleLab];

    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = CLColor(234, 236, 235);
    [self addSubview:line];
    
    self.weichatPayBtn = [self setPayMentBtnWithTitle:@"微信支付" andBackGroundColor:[UIColor greenColor]];
    
    self.aliPayBtn = [self setPayMentBtnWithTitle:@"支付宝支付" andBackGroundColor:[UIColor blueColor]];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (self.mas_top).offset (16*BOUNDS.size.height/667);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.height.mas_equalTo (16*BOUNDS.size.height/667);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (titleLab.mas_bottom).offset (10);
        make.width.mas_equalTo (self.mas_width);
        make.height.mas_equalTo (1);
        make.left.mas_equalTo (self.mas_left);
    }];

    [_weichatPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (line.mas_bottom).offset (15);
        make.width.mas_equalTo (WIDTH-40);
        make.height.mas_equalTo (20);
        make.left.mas_equalTo (self.mas_left).offset(20);
    }];
    
    [_aliPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_weichatPayBtn.mas_bottom).offset (15);
        make.width.mas_equalTo (WIDTH-40);
        make.height.mas_equalTo (20);
        make.left.mas_equalTo (self.mas_left).offset(20);
    }];
}

#pragma mark- 支付方式按钮布局约束
- (UIButton *)setPayMentBtnWithTitle:(NSString *)title andBackGroundColor:(UIColor *)baColor {
   UIButton *payBtn = [[UIButton alloc] init];
    payBtn.backgroundColor = baColor;
    [payBtn setTitle:title forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payBtn addTarget:self action:@selector(payMethodCheckClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:payBtn];
    
    return payBtn;
}

#pragma mark - 返回上一页支付页面
- (void)returnToPayView {
    __weak PaymentMethodView *weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.frame = CGRectMake(WIDTH, 0, WIDTH, weakSelf.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];

}

@end
