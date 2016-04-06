//
//  PaymentMethodView.h
//  LJPayViewDemo
//
//  Created by 罗金 on 16/4/1.
//  Copyright © 2016年 EasyFlower. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PaymentMethodViewDelegate <NSObject>

/*
 * 选中支付方式
 */
- (void)PaymentMethodViewCheckPayMentAction:(UIButton *)paymentBtn;

@end

@interface PaymentMethodView : UIView

@property (nonatomic, weak) id<PaymentMethodViewDelegate> delegate;

@end
