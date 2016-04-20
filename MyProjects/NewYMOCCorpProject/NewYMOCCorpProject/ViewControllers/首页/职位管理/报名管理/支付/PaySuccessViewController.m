//
//  PayedViewController.m
//  YIMIDemo
//
//  Created by sks on 16/2/18.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "PaySuccessViewController.h"

@interface PaySuccessViewController ()



@end

@implementation PaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewBasicProperty];
    [self layoutSubViews];
}

-(void)layoutSubViews {
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 260)];
    backView.backgroundColor = [UIColor whiteColor];
    //对勾按钮
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 60)/2, 30, 60, 60)];
    image.image = [UIImage imageNamed:@"zwgl_gx"];
    //    image.contentMode = UIViewContentModeCenter;
    
    //支付完成
    UILabel *succesfulLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, image.bottom + 20, SCREEN_WIDTH, 30)];
    succesfulLabel.text = @"支付完成";
    succesfulLabel.textColor = [UIColor orangeColor];
    succesfulLabel.textAlignment = NSTextAlignmentCenter;
    succesfulLabel.font = FONT(20);
    
    //共支付XX人
    UILabel *totalPersonLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, succesfulLabel.bottom, SCREEN_WIDTH, 30)];
    totalPersonLabel.text = [NSString stringWithFormat:@"共支付%ld人",(long)_totalPerson];
    totalPersonLabel.textAlignment = NSTextAlignmentCenter;
    totalPersonLabel.textColor = RGBCOLOR(45, 45, 45);
    totalPersonLabel.font = FONT(16);
    
    //总金额
    UILabel *totalMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, totalPersonLabel.bottom +20, SCREEN_WIDTH, 30)];
    totalMoneyLabel.text = [NSString stringWithFormat:@"￥%.2lf",_totalMoney];
    totalMoneyLabel.textAlignment = NSTextAlignmentCenter;
    totalMoneyLabel.font = FONT(30);
    
    
    [backView addSubview:image];
    [backView addSubview:succesfulLabel];
    [backView addSubview:totalPersonLabel];
    [backView addSubview:totalMoneyLabel];
    
    [self.view addSubview:backView];
    
    //完成按钮
    UIButton *succesfulButton = [[UIButton alloc]initWithFrame:CGRectMake(15, backView.bottom +30.0, SCREEN_WIDTH - 15*2, 40)];
    [succesfulButton setTitle:@"完 成" forState:UIControlStateNormal];
    succesfulButton.titleLabel.font = FONT(17);
    succesfulButton.backgroundColor = [UIColor orangeColor];
    succesfulButton.layer.cornerRadius = 5;
    [succesfulButton addTarget:self action:@selector(succesfulButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:succesfulButton];
}

#pragma mark 完成按钮方法
-(void)succesfulButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
