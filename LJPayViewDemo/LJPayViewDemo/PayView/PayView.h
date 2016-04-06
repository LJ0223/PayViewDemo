//
//  PayView.h
//  LJPayViewDemo
//
//  Created by 罗金 on 16/4/1.
//  Copyright © 2016年 EasyFlower. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MoneyButton;
@class PaymentMethodView;

@protocol PayViewDelegate <NSObject>

- (void)PayViewIsUseMoneyWith:(NSString *)param;
- (void)PayViewIsCreditWith:(NSString *)param;
- (void)PayViewOnlinePay;

@end

@interface PayView : UIView


@property (nonatomic, weak) id<PayViewDelegate> delegate;

@property (nonatomic, strong) UIView *backgroungView;
/*
 * 支付弹窗展示控件
 */
@property (nonatomic, strong) UILabel * headTitleLabel;  // 标题
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) MoneyButton *walltBtn;
@property (nonatomic, strong) UILabel *money;
@property (nonatomic, strong) UILabel *remainlab;
@property (nonatomic, strong) UILabel *line;

@property (nonatomic, strong) UIButton *online;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) MoneyButton *creditBtn; // 信用额度按钮
@property (nonatomic, strong) UILabel *creditMoney;

@property (nonatomic, strong) UILabel *paymentLable;  // 支付方式

/*
 * 选择支付方式页面
 */
@property (nonatomic, strong) PaymentMethodView *payMentView;

// 代支付金额
@property (nonatomic, copy) NSString *wailPay;
// 钱包余额
@property (nonatomic, copy) NSString *remainSum;
// 是否使用钱包
@property (nonatomic, copy) NSString *isUseMoney;
// 是否使用信用额度
@property (nonatomic, copy) NSString *isCreditStr;
// 信用额度金额
@property (nonatomic, copy) NSString *remainCredit;


-(UIView *)initWithFrame:(CGRect )frame andNSString:(NSString *)title;

@end
