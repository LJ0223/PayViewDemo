//
//  PayView.m
//  LJPayViewDemo
//
//  Created by 罗金 on 16/4/1.
//  Copyright © 2016年 EasyFlower. All rights reserved.
//

#import "PayView.h"
#import "PaymentMethodView.h"
#import "MoneyButton.h"
#define payViewHeight 260

@interface PayView ()<PaymentMethodViewDelegate>

@property (nonatomic, strong) UIButton *nextBtn;      // 选择支付方式跳转按钮

@end

@implementation PayView

@synthesize isCreditStr = _isCreditStr;
@synthesize remainCredit = _remainCredit;
@synthesize wailPay = _wailPay;
@synthesize remainSum = _remainSum;
@synthesize isUseMoney = _isUseMoney;

-(UIView *)initWithFrame:(CGRect )frame andNSString:(NSString *)title;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        
        [self layOutUIWith:title];
    }
    return self;
}

#pragma mark- PaymentMethodViewDelegate 选中支付方式传值回来，改变支付方式显示
- (void)PaymentMethodViewCheckPayMentAction:(UIButton *)paymentBtn {
    if ([paymentBtn.titleLabel.text isEqualToString:@"微信支付"]) {
        NSLog(@"微信支付");
        _paymentLable.text = @"微信";
    } else {
        NSLog(@"支付宝支付");
        _paymentLable.text = @"支付宝";
    }
    
    // 刷新支付按钮显示
    [self CalculationPopViewPayButtonMoney];
}


#pragma mark- 勾选框选中事件
// 选中信用额度
- (void)creditBtnAction:(MoneyButton *)sender
{
    if ([sender.param isEqualToString:@"true"]) {
        //点击选中
        sender.param = @"fales";
        [sender setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    } else {
        [sender setImage:[UIImage imageNamed:@"dhao"] forState:UIControlStateNormal];
        sender.param= @"true";
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(PayViewIsCreditWith:)]) {
        [self.delegate PayViewIsCreditWith:sender.param];
    }
}


// 选中钱包
- (void)isUseWalltMoney:(MoneyButton *)sender
{
    if ([sender.param isEqualToString:@"fales"]) {
        //点击选中
        sender.param = @"true";
        [sender setImage:[UIImage imageNamed:@"dhao"] forState:UIControlStateNormal];
    } else {
        [sender setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        sender.param= @"fales";
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(PayViewIsUseMoneyWith:)]) {
        [self.delegate PayViewIsUseMoneyWith:sender.param];
    }
}

#pragma mark - 在线支付按钮点击事件
-(void)onlineBtnAction:(UIButton *)sender{
    [self upDownSelf];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(PayViewOnlinePay)]) {
        [self.delegate PayViewOnlinePay];
    }
}

#pragma mark - 关闭弹窗按钮点击事件
- (void)closeBtnClick:(UIButton *)sender {
    [self upDownSelf];
}

- (void)upDownSelf {
    self.backgroundColor = [UIColor clearColor];
    __weak PayView *weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.frame = CGRectMake(0, HEIGHT, WIDTH, HEIGHT);
    } completion:^(BOOL finished) {
        weakSelf.payMentView.frame = CGRectMake(WIDTH, 0, WIDTH, payViewHeight);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    // 判断当前是否是空白处的高度范围，或是支付方式的视图，是则下移弹窗，不是则不作任何处理
    if (touch.view != _payMentView && touch.view.frame.origin.y < payViewHeight) {
        [self upDownSelf];
    }
}

#pragma mark - getter && setter 方法
#pragma mark 待支付金额
- (void)setWailPay:(NSString *)wailPay
{
    _wailPay = wailPay;
    
    _priceLabel.text =[NSString stringWithFormat:@"¥ %@",_wailPay] ;
    _remainlab.text = [NSString stringWithFormat:@"%@",_wailPay];
}

- (NSString *)wailPay
{
    return _wailPay;
}

#pragma mark 钱包金额
- (void)setRemainSum:(NSString *)remainSum {
    _remainSum = remainSum;
    
    float num = [_remainSum intValue];
    /*
     * 如果钱包没有余额，隐藏“使用钱包选项”及待实付信息。
     */
    if (num == 0) {
        _isUseMoney = @"false";
        self.walltBtn.hidden = YES;
        self.remainlab.hidden = YES;
        self.walltBtn.param = @"false";
        [self.walltBtn setImage:[UIImage imageNamed:@"dhao"] forState:UIControlStateNormal];
        self.walltBtn.userInteractionEnabled = NO;
    }
    
    // 给钱包显示金额赋值
    NSString *str  = [NSString stringWithFormat:@"%.2f",num];
    self.remainlab.text = [NSString stringWithFormat:@"￥%@)",str];
}

- (NSString *)remainSum {
    return _remainSum;
}

#pragma mark 信用额度金额
- (void)setRemainCredit:(NSString *)remainCredit {
    _remainCredit = remainCredit;
    
    // 将信用额度转换为浮点数型
    float creDitNum = [_remainCredit intValue];
    if (creDitNum == 0) {
        _isCreditStr = @"false";
        self.creditBtn.hidden = YES;
        self.creditMoney.hidden = YES;
        self.creditBtn.param = @"false";
        [self.walltBtn setImage:[UIImage imageNamed:@"dhao"] forState:UIControlStateNormal];
    }
    
    // 给信用额度显示金额赋值
    self.creditMoney.text = [NSString stringWithFormat:@"￥%@)",_remainCredit];
}

- (NSString *)remainCredit {
    return _remainCredit;
}

#pragma mark 是否使用信用额度
- (void)setIsCreditStr:(NSString *)isCreditStr {
    _isCreditStr = isCreditStr;
    if ([_isCreditStr isEqualToString:@"true"]) {
        [self.creditBtn setImage:[UIImage imageNamed:@"dhao"] forState:UIControlStateNormal];
        self.creditBtn.param= @"true";
    } else {
        self.creditBtn.param = @"fales";
        [self.creditBtn setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    }
    [self CalculationPopViewPayButtonMoney];
}

- (NSString *)isCreditStr {
    return _isCreditStr;
}

#pragma mark 是否使用钱包
- (void)setIsUseMoney:(NSString *)isUseMoney {
    _isUseMoney = isUseMoney;
    
    if ([_isUseMoney isEqualToString:@"true"]) {
        [self.walltBtn setImage:[UIImage imageNamed:@"dhao"] forState:UIControlStateNormal];
        self.walltBtn.param= @"true";
    } else {
        self.walltBtn.param = @"fales";
        [self.walltBtn setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    }
    
    [self CalculationPopViewPayButtonMoney];
}

- (NSString *)isUseMoney {
    return _isUseMoney;
}

#pragma mark - 根据勾选状态判断在线支付按钮显示状态
- (void)CalculationPopViewPayButtonMoney
{
    // 待支付-钱包余额
    float wJianRsum = [_wailPay floatValue]-[_remainSum floatValue];
    // 待支付-信用额度
    float wJianRcre = [_wailPay floatValue]-[_remainCredit floatValue];
    // 待支付-钱包余额-信用额度
    float wJianRsumJianRcre = [_wailPay floatValue]-[_remainSum floatValue]-[_remainCredit floatValue];
    
    // 勾选信用额度
    if ([_isCreditStr isEqualToString:@"true"]) {
        
        // 勾选信用额度，且勾选钱包余额
        if ([_isUseMoney isEqualToString:@"true"]) {
            // 消费金额－信用额度－钱包余额小于零
            if (wJianRsumJianRcre<=0) {
                [self.online setTitle:@"确认" forState:UIControlStateNormal];
            } else {
                
                // 信用额度为0，判断钱包余额
                if ([_remainCredit isEqualToString:@"0"]) {
                    
                    // 信用额度为0，钱包余额为0
                    if ([_remainSum isEqualToString:@"0"]) {
                        // 微信 或 支付宝 全额支付
                        [self.online setTitle:[NSString stringWithFormat:@"%@  %@支付",_wailPay, _paymentLable.text] forState:UIControlStateNormal];
                    }
                    // 信用额度为0，钱包余额不为0
                    else {
                        [self.online setTitle:[NSString stringWithFormat:@"%.2f  %@支付",wJianRsum, _paymentLable.text] forState:UIControlStateNormal];
                    }
                    
                } else {
                    // 信用额度不为0，钱包余额为0
                    if ([_remainSum isEqualToString:@"0"]) {
                        [self.online setTitle:[NSString stringWithFormat:@"%.2f  %@支付",wJianRcre, _paymentLable.text] forState:UIControlStateNormal];
                    } else {
                        // 信用额度不为0，钱包余额不为0
                        [self.online setTitle:[NSString stringWithFormat:@"%.2f  %@支付",wJianRsumJianRcre, _paymentLable.text] forState:UIControlStateNormal];
                    }
                    
                }
            }
        } else {
            // 勾选信用额度和未勾选钱包
            if (wJianRcre <= 0) {
                [self.online setTitle:@"确认" forState:UIControlStateNormal];
            } else {
                // 微信 或 支付宝 全额支付
                [self.online setTitle:[NSString stringWithFormat:@"%.2f  %@支付",wJianRcre, _paymentLable.text] forState:UIControlStateNormal];
            }
        }
    } else {
        // 未勾选信用额度,只判断钱包余额
        if ([_isUseMoney isEqualToString:@"true"]) {
            if (wJianRsum<=0) {
                [self.online setTitle:@"确认" forState:UIControlStateNormal];
            } else {
                // 钱包余额为0
                if ([_remainCredit isEqualToString:@"0"]) {
                    // 微信 或 支付宝 全额支付
                    [self.online setTitle:[NSString stringWithFormat:@"%@  %@支付",_wailPay, _paymentLable.text] forState:UIControlStateNormal];
                } else {
                    [self.online setTitle:[NSString stringWithFormat:@"%.2f  %@支付",wJianRsum, _paymentLable.text] forState:UIControlStateNormal];
                }
            }
        } else {
            // 微信 或 支付宝 全额支付
            [self.online setTitle:[NSString stringWithFormat:@"%@  %@支付",_wailPay, _paymentLable.text] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - 进入选择支付方式页面
- (void)nextBtnClick:(UIButton *)sender
{
    
    __weak PayView *weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.payMentView.frame = CGRectMake(0, 0, WIDTH, payViewHeight);
    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark - LayoutUIs
- (void)layOutUIWith:(NSString *)title {
    self.backgroungView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-payViewHeight, WIDTH, payViewHeight)];//层
    _backgroungView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_backgroungView];
    
    self.headTitleLabel = [[UILabel alloc]init];
    
    _headTitleLabel.font = [UIFont systemFontOfSize:14.0f];
    _headTitleLabel.textColor = CLColor(51, 51, 51);
    _headTitleLabel.text = title;
    _headTitleLabel.textAlignment = NSTextAlignmentLeft;
    [_backgroungView addSubview:_headTitleLabel];
    
    /**
     分割线
     */
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = CLColor(234, 236, 235);
    [_backgroungView addSubview:line];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.textColor = CLColor(51, 51, 51);
    nameLabel.text = @"待支付金额：";
    nameLabel.textAlignment = NSTextAlignmentRight;
    nameLabel.font = [UIFont systemFontOfSize:16.0f];
    [_backgroungView addSubview:nameLabel];
    
    //待支付金额显示
    self.priceLabel = [[UILabel alloc]init];
    self.priceLabel.textColor = titleColor;
    _priceLabel.text = @"￥122.92";
    self.priceLabel.textAlignment = NSTextAlignmentLeft;
    self.priceLabel.font = [UIFont systemFontOfSize:18.0f];
    [_backgroungView addSubview:self.priceLabel];
    
    /**
     *  是否使用信用额度按钮
     */
    _creditBtn = [[MoneyButton alloc]init];
    [_creditBtn setTitle:@"使用信用额度 (可用" forState:UIControlStateNormal];
    [_creditBtn setTitleColor:CLColor(102, 102, 102) forState:UIControlStateNormal];
    _creditBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_creditBtn setImage:[UIImage imageNamed:@"dhao"] forState:UIControlStateNormal];
    [_creditBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    [_creditBtn addTarget:self action:@selector(creditBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _creditBtn.param = @"true";
    [_backgroungView addSubview:_creditBtn];
    
    _creditMoney = [[UILabel alloc]init];
    _creditMoney.text = @"2000元)";
    _creditMoney.textColor = CLColor(102, 102, 102);
    _creditMoney.font = [UIFont systemFontOfSize:14];
    [_backgroungView addSubview:_creditMoney];
    
    
    //是否使用钱包的按钮
    _walltBtn = [[MoneyButton alloc]init];
    [_walltBtn addTarget:self action:@selector(isUseWalltMoney:) forControlEvents:UIControlEventTouchUpInside];
    [_walltBtn setTitle:@"使用钱包 (余额：" forState:UIControlStateNormal];
    _walltBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _walltBtn.param = @"true";
    [_walltBtn setImage:[UIImage imageNamed:@"dhao"] forState:UIControlStateNormal];
    [_walltBtn setTitleColor:CLColor(102, 102, 102) forState:UIControlStateNormal];
    [_walltBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    [_backgroungView addSubview:_walltBtn];
    
    //钱包余额
    _remainlab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_walltBtn.frame), _walltBtn.frame.origin.y+1, 0, 0)];
    _remainlab.text = @"100元)";
    _remainlab.textAlignment = NSTextAlignmentLeft;
    _remainlab.textColor = CLColor(102, 102, 102);
    _remainlab.font = [UIFont systemFontOfSize:14];
    [_backgroungView addSubview:_remainlab];
    
    /*
     * 支付方式：
     */
    UILabel *paymentTitleLab = [[UILabel alloc] init];
    paymentTitleLab.textColor = CLColor(102, 102, 102);
    paymentTitleLab.text = @"支付方式：";
    paymentTitleLab.textAlignment = NSTextAlignmentLeft;
    paymentTitleLab.font = [UIFont systemFontOfSize:13.0f];
    [_backgroungView addSubview:paymentTitleLab];
    
    _paymentLable = [[UILabel alloc] init];
    _paymentLable.textColor = CLColor(102, 102, 102);
    _paymentLable.text = @"微信";
    _paymentLable.textAlignment = NSTextAlignmentCenter;
    _paymentLable.font = [UIFont systemFontOfSize:13.0f];
    [_backgroungView addSubview:_paymentLable];
    
    _nextBtn = [[UIButton alloc] init];
    _nextBtn.backgroundColor = [UIColor yellowColor];
    [_nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_nextBtn setImage:[UIImage imageNamed:@"yjt"] forState:UIControlStateNormal];
    [_backgroungView addSubview:_nextBtn];
    
    //在线支付按钮
    self.online = [UIButton buttonWithType:UIButtonTypeCustom];
    _online.backgroundColor = titleColor;
    self.online.layer.cornerRadius = 2.0f;
    self.online.clipsToBounds = YES;
    [_online setTitle:@"确认" forState:UIControlStateNormal];
    [_online addTarget:self action:@selector(onlineBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_backgroungView addSubview:_online];
    
    
    /*
     *  X 号按钮
     */
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setImage:[UIImage imageNamed:@"t_close"] forState:UIControlStateNormal];
    [_backgroungView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_backgroungView.mas_right).offset(-10);
        make.top.mas_equalTo(_backgroungView.mas_top).offset(10);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
    
    [_headTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_backgroungView.mas_top).offset (16*BOUNDS.size.height/667);
        make.centerX.mas_equalTo(_backgroungView.mas_centerX);
        make.height.mas_equalTo (16*BOUNDS.size.height/667);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_headTitleLabel.mas_bottom).offset (10);
        make.width.mas_equalTo (_backgroungView.mas_width);
        make.height.mas_equalTo (1);
        make.left.mas_equalTo (_backgroungView.mas_left);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (line.mas_bottom).offset (25*BOUNDS.size.height/667);
        make.left.mas_equalTo (_backgroungView.mas_left);
        make.width.mas_equalTo (_backgroungView.mas_width).dividedBy (2);
        make.height.mas_equalTo (20);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (line.mas_bottom).offset (25*BOUNDS.size.height/667);
        make.left.mas_equalTo (nameLabel.mas_right).offset (0);
        make.right.mas_equalTo (_backgroungView.mas_right).offset (0);
        make.height.mas_equalTo (20);
    }];
    
    //信用额度frame
    [_creditBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo (_backgroungView.mas_left).offset(10);
        make.width.mas_equalTo (140);
        make.bottom.mas_equalTo (_walltBtn.mas_top).offset(-10);
        make.height.mas_equalTo(15*BOUNDS.size.height/667);
    }];
    
    [_creditMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo (_creditBtn.mas_right);
        make.bottom.mas_equalTo (_creditBtn.mas_bottom);
        make.right.mas_equalTo (_backgroungView.mas_right).offset(-10);
        make.height.mas_equalTo (15*BOUNDS.size.height/667);
    }];
    
    [_walltBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo (_backgroungView.mas_left).offset(10);
        make.bottom.mas_equalTo (_nextBtn.mas_top).offset (-10);
        make.width.mas_equalTo (128);
        make.height.mas_equalTo(15*BOUNDS.size.height/667);
    }];
    
    [_remainlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo (_walltBtn.mas_right);
        make.bottom.mas_equalTo (_walltBtn.mas_bottom);
        make.right.mas_equalTo (_backgroungView.mas_right).offset(-10);
        make.height.mas_equalTo (15*BOUNDS.size.height/667);
    }];
    
    [paymentTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_walltBtn.mas_left).offset(10);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo (_online.mas_top).offset (-10);
    }];
    
    [_paymentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_backgroungView.mas_right).offset(-40);
        make.left.mas_equalTo(paymentTitleLab.mas_right);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo (paymentTitleLab.mas_bottom);
    }];
    
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_backgroungView.mas_right).offset(-10);
        make.left.mas_equalTo(_paymentLable.mas_right);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo (paymentTitleLab.mas_bottom);
    }];
    
    [_online mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo (_backgroungView.mas_left).offset (10);
        make.bottom.mas_equalTo (_backgroungView.mas_bottom).offset (-10);
        make.right.mas_equalTo (_backgroungView.mas_right).offset (-10);
        make.height.mas_equalTo (46*BOUNDS.size.height/667);
        
    }];
    
    // 初始化钱包和信用额度默认是选中状态
    _isUseMoney = self.walltBtn.param;
    _isCreditStr = self.creditBtn.param;
    
    [self loadPayMentView];
}

#pragma mark - 加载支付方式视图
- (void)loadPayMentView {
    self.payMentView = [[PaymentMethodView alloc] initWithFrame:CGRectMake(WIDTH, 0, WIDTH, payViewHeight)];
    _payMentView.delegate = self;
    [self.backgroungView addSubview:_payMentView];
}



@end
