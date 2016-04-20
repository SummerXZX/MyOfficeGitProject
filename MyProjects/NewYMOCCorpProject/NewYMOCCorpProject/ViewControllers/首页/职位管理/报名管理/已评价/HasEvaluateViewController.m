//
//  HasEvaluateViewController.m
//  NewYMOCCorpProject
//
//  Created by test on 16/2/19.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "HasEvaluateViewController.h"
#import "ReportStuInfoCell.h"
#import "MyTableViewHeaderView.h"
#import "EvaluateTypeCell.h"
#import "EmptyViewFactory.h"
#import "HasEvaluateInfoCell.h"


@interface HasEvaluateViewController () <UITableViewDelegate,UITableViewDataSource>
{
    YMMyEvaluateInfoData  *_myEvaluateInfoData;
}
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation HasEvaluateViewController

#pragma mark tableView
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [ProjectUtil getDefaultTableViewWithType:TableViewTypeNomal];
        _tableView.height = SCREEN_HEIGHT-64.0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewBasicProperty];
    [self layoutSubViews];
}



-(void)layoutSubViews {
    [self.view addSubview:self.tableView];
    //获取评价信息
    [self getMyEvaluateInfo];
}

#pragma mark
-(void)getMyEvaluateInfo {
    [YMWebClient getMyEvaluateInfoWithParams:@{@"jobId":@(_jobId),@"stuId":@(_stuId),@"regiId":@(_regiId)} Success:^(YMMyEvaluateInfoResponse *response) {
        if (response.data) {
            _myEvaluateInfoData = response.data;
        }
        else {
            _myEvaluateInfoData = nil;
           
            HasEvaluateViewController *__weak weakVC = self;
            [EmptyViewFactory errorNetwork:self.tableView btnBlock:^{
                [weakVC getMyEvaluateInfo];
            }];
        }
         [self.tableView reloadData];
    }];
}

#pragma mark 获取显示标题
-(NSString *)getTitleWithSection:(NSInteger)section {
    switch (section) {
        case 1:
            return @"您给他的评价";
            break;
        case 2:
            return @"学生对您的评价";
        default:
            return @"";
            break;
    }
}

#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_myEvaluateInfoData) {
        if (_myEvaluateInfoData.stuEvaluate) {
            return 3;
        }
        return 2;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==2|section==1) {
        return 2;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==1|section==2) {
        return 35.0;
    }
    return 0.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *identifier = @"headerView";
    MyTableViewHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!headerView) {
        headerView = [[MyTableViewHeaderView alloc]initAddLineViewWithReuseIdentifier:identifier];
        headerView.titleLabel.numberOfLines = 0;
    }
    headerView.contentView.backgroundColor = [UIColor whiteColor];
    headerView.titleLabel.text = [self getTitleWithSection:section];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return 70.0;
    }
    else if (indexPath.row==1) {
        NSArray *evaluateArr = @[];
        if (indexPath.section==2) {
            evaluateArr = [_myEvaluateInfoData.stuEvaluate.describe componentsSeparatedByString:@","];
        }
        else if (indexPath.section==1) {
            evaluateArr = [_myEvaluateInfoData.corpEvaluate.describe componentsSeparatedByString:@","];
        }

        return [HasEvaluateInfoCell getCellHeightWithEvaluateArr:evaluateArr];
    }
    else {
        return 50.0;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==2) {
        return 0.0;
    }
    return 10.0;
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        static NSString *identifier = @"ReportStuInfoCell";
        ReportStuInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ReportStuInfoCell" owner:nil options:nil]lastObject];
        }
        if (_myEvaluateInfoData.sex==1) {
            cell.sexImageView.backgroundColor = SEX_MAN_COLOR;
            cell.sexImageView.image = [UIImage imageNamed:@"zwgl_nan"];
        }
        else if (_myEvaluateInfoData.sex==2) {
            cell.sexImageView.backgroundColor = SEX_WOMEN_COLOR;
            cell.sexImageView.image = [UIImage imageNamed:@"zwgl_nv"];
        }
        NSMutableAttributedString *infoAttStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@    ",_myEvaluateInfoData.stuName] attributes:@{NSFontAttributeName:FONT(14),NSForegroundColorAttributeName:[UIColor blackColor]}];
        NSTextAttachment *attach = [[NSTextAttachment alloc]init];
        attach.image = [UIImage imageNamed:@"zwgl_p"];
        attach.bounds = CGRectMake(0, -1, 15, 15);
        [infoAttStr appendAttributedString:[NSAttributedString attributedStringWithAttachment:attach]];
        [infoAttStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld%@",(long)_myEvaluateInfoData.praise,@"%"] attributes:@{NSFontAttributeName:FONT(14),NSForegroundColorAttributeName:DefaultGrayTextColor}]];
        cell.infoLabel.attributedText = infoAttStr;
        [cell.phoneBtn setTitle:_myEvaluateInfoData.stuPhone forState:UIControlStateNormal];
        return cell;
    }
    else if (indexPath.row==1) {
        static NSString *identifier = @"HasEvaluateInfoCell";
        BOOL isMyEvaluate = YES;
        if (indexPath.section==2) {
            isMyEvaluate = NO;
        }
        HasEvaluateInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[HasEvaluateInfoCell alloc]initWithReuseIdentifier:identifier IsMyEvaluate:isMyEvaluate];
        }
        NSArray *evaluateArr = @[];
        if (indexPath.section==2) {
            evaluateArr = [_myEvaluateInfoData.stuEvaluate.describe componentsSeparatedByString:@","];
        }
        else if (indexPath.section==1) {
            evaluateArr = [_myEvaluateInfoData.corpEvaluate.describe componentsSeparatedByString:@","];
        }
        cell.evaluateArr = evaluateArr;
        return cell;
    }
    else {
        static NSString *identifier = @"EvaluateTypeCell";
        EvaluateTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"EvaluateTypeCell" owner:nil options:nil]lastObject];
        }
        NSInteger level = _myEvaluateInfoData.corpEvaluate.level;
        if (indexPath.section==2) {
            level = _myEvaluateInfoData.stuEvaluate.level;
        }
        cell.evaluateType = level;
        return cell;

    }
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
