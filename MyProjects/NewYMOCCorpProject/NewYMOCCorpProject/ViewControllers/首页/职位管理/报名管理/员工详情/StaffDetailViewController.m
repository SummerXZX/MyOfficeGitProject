//
//  ReportDetailViewController.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/26.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "StaffDetailViewController.h"
#import "ReportStuInfoCell.h"
#import "StaffDetailWorkDateCell.h"
#import "MyTableViewHeaderView.h"
#import "StaffDetailCollectionCell.h"
#import "NomalContentCell.h"
#import "EmptyViewFactory.h"

@interface StaffDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) YMStaffDetailInfo *detailInfo;

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation StaffDetailViewController

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
    //获取员工详情
    [self getStaffDetail];
}


#pragma mark 获取员工详情
-(void)getStaffDetail {
    [self.view showProgressHintWith:@"加载中"];
    [YMWebClient getStaffDetailWithParams:@{@"regiId":@(_reportInfo.id),@"stuId":@(_reportInfo.stuId)} Success:^(YMStaffDetailResponse *response) {
        [self.view dismissProgress];
        
        if (response.data) {
            _detailInfo = response.data;
            if (_detailInfo.stuResumeItem.intro.length==0) {
                _detailInfo.stuResumeItem.intro = @"该学生没有填写自述";
            }
        }
        else {
            _detailInfo = nil;
            StaffDetailViewController *__weak weakVC = self;
            [EmptyViewFactory errorNetwork:self.tableView btnBlock:^{
                [weakVC getStaffDetail];
            }];
        }
        [self.tableView reloadData];
    }];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_detailInfo) {
        return 5;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return 70.0;
    }
    else if (indexPath.section==1) {
        CGFloat addHeight = 0.0;
        if (_detailInfo) {
            addHeight = [ProjectUtil getAddHeightWithStrArr:@[[self getBaseInfoAttStr]] Font:FONT(14) LabelHeight:17.0 LabelWidth:SCREEN_WIDTH-20.0];
        }
        return addHeight+30.0;
    }
    else if (indexPath.section==2) {
        if (_detailInfo.isExpand) {
            return [StaffDetailWorkDateCell getStaffDetailWorkDateCellHeightWithDataCount:[_detailInfo.stuResumeItem.workdates componentsSeparatedByString:@"|"].count];
        }
        return 44.0;
    }
    else {
        
        NSInteger dataCount = 0;
        if (indexPath.section==3) {
            dataCount = _detailInfo.workExperience.count;
        }
        else if (indexPath.section==4) {
            dataCount = _detailInfo.evaluates.count;
        }
       return [StaffDetailCollectionCell getCellHeightWithDataCount:dataCount];
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section!=0) {
        return 35.0;
    }
    return 0.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *identifier = @"headerView";
    MyTableViewHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!headerView) {
        headerView = [[MyTableViewHeaderView alloc]initAddLineViewWithReuseIdentifier:identifier];
    }
    headerView.contentView.backgroundColor = [UIColor whiteColor];
    headerView.titleLabel.attributedText = [self getTitleWithSection:section];
    return headerView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==4) {
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
        if (_reportInfo.sex==1) {
            cell.sexImageView.backgroundColor = SEX_MAN_COLOR;
            cell.sexImageView.image = [UIImage imageNamed:@"zwgl_nan"];
        }
        else if (_reportInfo.sex==2) {
            cell.sexImageView.backgroundColor = SEX_WOMEN_COLOR;
            cell.sexImageView.image = [UIImage imageNamed:@"zwgl_nv"];
        }
        NSMutableAttributedString *infoAttStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@    ",_reportInfo.stuName] attributes:@{NSFontAttributeName:FONT(14),NSForegroundColorAttributeName:[UIColor blackColor]}];
        NSTextAttachment *attach = [[NSTextAttachment alloc]init];
        attach.image = [UIImage imageNamed:@"zwgl_p"];
        attach.bounds = CGRectMake(0, -1, 15, 15);
        [infoAttStr appendAttributedString:[NSAttributedString attributedStringWithAttachment:attach]];
        [infoAttStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld%@",(long)_reportInfo.praise,@"%"] attributes:@{NSFontAttributeName:FONT(14),NSForegroundColorAttributeName:DefaultGrayTextColor}]];
        cell.infoLabel.attributedText = infoAttStr;
        [cell.phoneBtn setTitle:_reportInfo.stuPhone forState:UIControlStateNormal];
        return cell;
    }
    else if (indexPath.section==1) {
        static NSString *identifier = @"NomalContentCell";
        
        NomalContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"NomalContentCell" owner:nil options:nil]lastObject];
        }
        cell.contentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH-20.0;
        cell.contentLabel.attributedText = [self getBaseInfoAttStr];
        return cell;
    }
    else if (indexPath.section==2) {
        static NSString *identifier = @"StaffDetailWorkDateCell";
        
        StaffDetailWorkDateCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"StaffDetailWorkDateCell" owner:nil options:nil]lastObject];
            [cell.moreBtn addTarget:self action:@selector(moreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        cell.workDates = [_detailInfo.stuResumeItem.workdates componentsSeparatedByString:@"|"];
        return cell;
    }
    else {
        static NSString *identifier= @"StaffDetailCollectionCell";
        StaffDetailCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[StaffDetailCollectionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        if (indexPath.section==3) {
            cell.isExperience = YES;

            cell.itemArr = _detailInfo.workExperience;
        }
        else if (indexPath.section==4) {
            cell.isExperience = NO;

            cell.itemArr = _detailInfo.evaluates;
        }
        return cell;
    }
}

#pragma mark 展开工作日期动作
-(void)moreBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _detailInfo.isExpand = sender.selected;
    [_tableView reloadData];
}
#pragma mark 根据section获取标题
-(NSAttributedString *)getTitleWithSection:(NSInteger)section {
    NSMutableAttributedString *attStr  =[[NSMutableAttributedString alloc]init];
    NSTextAttachment *attach = [[NSTextAttachment alloc]init];
    NSString *title = @"";
    switch (section) {
        case 1:
        {
            title = @"基本信息";
            attach.image = [UIImage imageNamed:@"ygxq_jbxx"];
        }
            break;
        case 2:
        {
            attach.image = [UIImage imageNamed:@"ygxq_gzrq"];
            title = @"工作日期";
        }
            break;
        case 3:
        {
            attach.image = [UIImage imageNamed:@"ygxq_jzjl"];
            title = @"兼职经历";
        }
            break;
        case 4:
        {
            attach.image = [UIImage imageNamed:@"ygxq_djrw"];
            title = @"大家认为他";
        }
            break;
        default:
            title = @"";
            break;
    }
    if (title.length!=0) {
        [attStr appendAttributedString:[NSAttributedString attributedStringWithAttachment:attach]];
        [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",title] attributes:@{NSFontAttributeName:FONT(15),NSForegroundColorAttributeName:[UIColor blackColor]}]];
    }
    if (section==2) {
        [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"（共%ld天）",(long)[_detailInfo.stuResumeItem.workdates componentsSeparatedByString:@"|"].count] attributes:@{NSFontAttributeName:FONT(12),NSForegroundColorAttributeName:DefaultPlaceholderColor}]];
    }
    else if (section==3) {
          [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"（共%ld次，",(long)_detailInfo.stuResumeItem.workCount] attributes:@{NSFontAttributeName:FONT(12),NSForegroundColorAttributeName:DefaultPlaceholderColor}]];
        [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"放鸽子%ld次）",(long)_detailInfo.stuResumeItem.unworkCount] attributes:@{NSFontAttributeName:FONT(12),NSForegroundColorAttributeName:DefaultBlueTextColor}]];
    }
    return attStr;
}

#pragma mark 获取基本信息富文本
-(NSAttributedString *)getBaseInfoAttStr{
    //设置段落的行间距10
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 10;
    //    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.headIndent = 42.0;
    //设置富文本的样式，字体大小14、字体颜色黑色、行距10
    NSMutableAttributedString *staffDetailInfoMuAttributed = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"年龄：%ld岁   身高：%ldcm\n院校：%@\n自述：%@",(long)_detailInfo.stuResumeItem.age,(long)_detailInfo.stuResumeItem.height,_detailInfo.stuResumeItem.school,_detailInfo.stuResumeItem.intro] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor blackColor],NSParagraphStyleAttributeName:paragraphStyle}];
    return staffDetailInfoMuAttributed;
}

-(void)dealloc {
    [ProjectUtil showLog:NSStringFromClass([self class])];
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
