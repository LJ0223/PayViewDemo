//
//  ViewController.m
//  LJPayViewDemo
//
//  Created by 罗金 on 16/4/1.
//  Copyright © 2016年 EasyFlower. All rights reserved.
//

#import "ViewController.h"
#import "PayView.h"
#import "AppDelegate.h"
#import "MoneyButton.h"

#define payViewHeight 260

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, PayViewDelegate>

{
    /**
     *  是否使用钱包
     */
    NSString *_isUseMoney;
    /**
     *  是否使用信用额度
     */
    NSString *_isCreditStr;
    
    // 信用额度金额
    NSString *_remainCredit;
    
    UIButton *btn; // 调出支付弹窗的按钮

}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) PayView *payView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadDataSource];
    [self tableView];
    [self addChangedBtn];
}

#pragma mark - 加载支付弹窗
- (void)loadPayView:(UIButton *)sender {
    [self payView];
    btn.userInteractionEnabled = NO;
    [self showPayView];
}

#pragma mark - 显示支付弹窗
- (void)showPayView{
    __weak ViewController *weakSelf = self;
    self.payView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [UIView animateWithDuration:0.5 animations:^{
        [weakSelf.payView setFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    } completion:^(BOOL finished) {
        weakSelf.payView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        btn.userInteractionEnabled = YES;
    }];
}

#pragma mark - PayViewDeleate 
- (void)PayViewIsCreditWith:(NSString *)param {
    _isCreditStr = param;
    _payView.isCreditStr = _isCreditStr;
    NSLog(@"是否使用信用额度 _isCreditStr===%@", _isCreditStr);
}

- (void)PayViewIsUseMoneyWith:(NSString *)param {
    _isUseMoney = param;
    _payView.isUseMoney = _isUseMoney;
    NSLog(@"是否使用钱包 _isUseMoney===%@", _isUseMoney);
}

- (void)PayViewOnlinePay {
    NSLog(@"支付按钮");
   
    NSLog(@"当前选中支付方式为：%@",  _payView.paymentLable.text);
}

#pragma mark ---- 添加 调出PayView的按钮
- (void)addChangedBtn
{
    //1.创建btn
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(200, 100, 80, 80);
    btn.center = CGPointMake(WIDTH/2, 100);
    // 2.设置按钮的图片
    [btn setBackgroundImage:[UIImage  imageNamed:@"sub_add"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"sub_add_h"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(loadPayView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (PayView *)payView {
    if (!_payView) {
        self.payView = [[PayView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, payViewHeight) andNSString:@"在线支付"];
        _payView.delegate = self;
    }
    /*
     * 如果全局的_isUseMoney没有值，则将弹窗的选中状态赋值给_isUseMoney
     * 如果全局的_isUseMoney有值，则将弹窗的选中状态与_isUseMoney的值同步
     */
    if (_isUseMoney == nil) {
        _isUseMoney = _payView.walltBtn.param;
    } else {
        _payView.walltBtn.param = _isUseMoney;
    }
    
    if (_isCreditStr == nil) {
        _isCreditStr = _payView.isCreditStr;
    } else {
        _payView.isCreditStr = _isCreditStr;
    }
    
    AppDelegate *delegate  = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:_payView];
    
    // 给带信用额度的支付弹窗赋值
    _payView.remainCredit = _remainCredit;
    _payView.wailPay = _wailPay;
    _payView.remainSum = _remainSum;
    
    return _payView;
}



#pragma mark - tableView Delegate && DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentify"];
    
    NSDictionary *dic = [_dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld. %@", indexPath.row+1, [dic objectForKey:@"title"]];
    cell.selectionStyle = NO;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [_dataSource objectAtIndex:indexPath.row];
    
    Class typeVC = NSClassFromString([dic objectForKey:@"controller"]);
    UIViewController *typeController = [[typeVC alloc] init];
    typeController.title = [dic objectForKey:@"title"];
    
    [self.navigationController pushViewController:typeController animated:YES];
}

#pragma mark - LAyoutUI

- (UITableView *)tableView
{
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellIdentify"];
        _tableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)loadDataSource {
    _remainCredit = @"2000";
    _wailPay = @"122.92";
    _remainSum = @"100";
    
    self.dataSource = [[NSMutableArray alloc] init];
    
    for (int i = 0 ; i < 32; i++) {
        NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"测试数据", @"title", @"FirstViewController", @"controller", nil];
        [_dataSource addObject:dic1];
    }
    
}


//- (void)setInfoViewFrame:(BOOL)isDown {
//    
//    __weak ViewController *weakSelf = self;
//    if(isDown == NO) {
//        [UIView animateWithDuration:0.5 animations:^{
//            [weakSelf.payView setFrame:CGRectMake(0, HEIGHT, WIDTH, payViewHeight)];
//        } completion:^(BOOL finished) {
//            
//        }];
//    } else {
//        [UIView animateWithDuration:0.5 animations:^{
//            [weakSelf.payView setFrame:CGRectMake(0, HEIGHT-payViewHeight, WIDTH, payViewHeight)];
//        } completion:^(BOOL finished) {
//            
//        }];
//    }
//    _isDown = !_isDown;
//}
//
//#pragma mark - 弹簧过渡动画
//- (void)setInfoViewFrameSelector2:(BOOL)isDown {
//    
//    __weak ViewController *weakSelf = self;
//    if(isDown == NO) {
//        [UIView animateWithDuration:1.0 // 动画时长
//                              delay:0.0 // 动画延迟
//             usingSpringWithDamping:0.2 // 类似弹簧振动效果 0~1
//              initialSpringVelocity:5.0 // 初始速度
//                            options:UIViewAnimationOptionCurveEaseInOut // 动画过渡效果
//                         animations:^{
//                             // code...
//                             [weakSelf.payView setFrame:CGRectMake(0, HEIGHT+60, WIDTH, payViewHeight)];
//                         } completion:^(BOOL finished) {
//                             [weakSelf.payView setFrame:CGRectMake(0, HEIGHT, WIDTH, payViewHeight)];
//                         }];
//    } else {
//        [UIView animateWithDuration:1.0 // 动画时长
//                              delay:0.0 // 动画延迟
//             usingSpringWithDamping:0.2 // 类似弹簧振动效果 0~1
//              initialSpringVelocity:5.0 // 初始速度
//                            options:UIViewAnimationOptionCurveEaseInOut // 动画过渡效果
//                         animations:^{
//                             [weakSelf.payView setFrame:CGRectMake(0, HEIGHT-payViewHeight+16, WIDTH, payViewHeight)];
//                         } completion:^(BOOL finished) {
//                             [weakSelf.payView setFrame:CGRectMake(0, HEIGHT-payViewHeight, WIDTH, payViewHeight)];
//                         }];
//    }
//}
//
//- (void)setInfoViewFrame2:(BOOL)isDown{
//    __weak ViewController *weakSelf = self;
//    
//    if(isDown == NO) {
//        [UIView animateKeyframesWithDuration:0.1 delay:0.0 options:0 animations:^{
//            [weakSelf.payView setFrame:CGRectMake(0, HEIGHT-payViewHeight/2, WIDTH, payViewHeight)];
//        } completion:^(BOOL finished) {
//            [UIView animateKeyframesWithDuration:0.1 delay:0.0 options:UIViewAnimationCurveEaseIn animations:^{
//                [weakSelf.payView setFrame:CGRectMake(0, HEIGHT, WIDTH, payViewHeight)];
//            } completion:nil];
//        }];
//        
//    } else {
//        [UIView animateKeyframesWithDuration:0.1 delay:0.0 options:0 animations:^{
//            [weakSelf.payView setFrame:CGRectMake(0, HEIGHT-payViewHeight/2, WIDTH, payViewHeight)];
//        } completion:^(BOOL finished) {
//            [UIView animateKeyframesWithDuration:0.1 delay:0.0 options:UIViewAnimationCurveEaseIn animations:^{
//                [weakSelf.payView setFrame:CGRectMake(0, HEIGHT-payViewHeight, WIDTH, payViewHeight)];
//            } completion:nil];
//        }];
//    }
//    _isDown = !_isDown;
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
