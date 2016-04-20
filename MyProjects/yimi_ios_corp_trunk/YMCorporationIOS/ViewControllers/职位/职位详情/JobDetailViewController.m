//
//  JobDetailViewController.m
//  YMCorporationIOS
//
//  Created by test on 15/7/3.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "JobDetailViewController.h"
#import "JobDetailInfoCell.h"
#import "JobDetailNomalCell.h"
#import "JobDetailTimeCell.h"
#import "LocalDicDataBaseManager.h"

#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"

#import "ReportCountViewController.h"
#import "PostJobViewController.h"
#import "SignCountListViewController.h"

@interface JobDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    YMJobDetailSummary *_jobDetailInfo;
    BOOL _timeLabelExist;
}
@property (nonatomic,strong) UIView *footView;
@property (nonatomic,strong) UIView *headerView;
@end

@implementation JobDetailViewController


#pragma mark footView
-(UIView *)footView
{
    if (!_footView)
    {
        
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64.0-49.0, SCREEN_WIDTH, 49.0)];
        _footView.backgroundColor = [UIColor whiteColor];

        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _footView.width, 1)];
        lineView.backgroundColor = DefaultBackGroundColor;
        
        [_footView addSubview:lineView];
        NSArray *btnTitleArr = nil;
        if (_jobDetailInfo.isCheck==1)
        {
            btnTitleArr = @[@"编辑",@"停招"];
        }
        else if (_jobDetailInfo.isCheck==2)
        {
            btnTitleArr = @[@"分享",@"刷新",@"停招"];
        }
        else if (_jobDetailInfo.isCheck==3)
        {
            btnTitleArr = @[@"编辑",@"重新发布"];
        }
        if (btnTitleArr)
        {
            self.tableView.height = SCREEN_HEIGHT-64.0-49.0;
            CGFloat btnWidth = _footView.width/btnTitleArr.count;
            CGFloat btnHeight = _footView.height;
            
            int count=0;
            for (NSString *title in btnTitleArr)
            {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(count*btnWidth, 0, btnWidth, btnHeight);
                [btn setTitle:title forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(footBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [_footView addSubview:btn];
                if (count<btnTitleArr.count-1)
                {
                    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(btn.right, 5, 1, _footView.height-10)];
                    lineView.backgroundColor = DefaultBackGroundColor;
                    [_footView addSubview:lineView];
                }
                count++;
            }
        }
        else
        {
            self.tableView.height = SCREEN_HEIGHT-64.0;
        }
    }
    
    return _footView;
}

#pragma mark headerView
-(UIView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _headerView.backgroundColor = [UIColor whiteColor];
        if (_jobDetailInfo.regiNum==0)
        {
            UILabel *reportCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 20)];
            reportCountLabel.font = Default_Font_15;
            reportCountLabel.textColor = NavigationBarColor;
            reportCountLabel.text = @"报名0人";
            [_headerView addSubview:reportCountLabel];
        }
        else if (_jobDetailInfo.regiNum>0)
        {
            UIButton *reportCountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString *btnTitle = [NSString stringWithFormat:@"报名%d人",_jobDetailInfo.regiNum];
            CGFloat btnWidth = [btnTitle getSizeWithFont:Default_Font_15].width;
            reportCountBtn.frame = CGRectMake(10, 5, btnWidth, 30);
            NSAttributedString *btnAttTitle = [[NSAttributedString alloc]initWithString:btnTitle attributes:@{NSFontAttributeName:Default_Font_15,NSForegroundColorAttributeName:NavigationBarColor,NSUnderlineStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleSingle]}];
            [reportCountBtn setAttributedTitle:btnAttTitle forState:UIControlStateNormal];
            [reportCountBtn addTarget:self action:@selector(reportBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [_headerView addSubview:reportCountBtn];
            
            UIButton *signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString *signBtnTitle = [NSString stringWithFormat:@"签约%d人",_jobDetailInfo.confirmNum];
            CGFloat signBtnWidth = [signBtnTitle getSizeWithFont:Default_Font_15].width;
            signBtn.frame = CGRectMake(reportCountBtn.right+15, 5, signBtnWidth, 30);
            NSAttributedString *signBtnAttTitle = [[NSAttributedString alloc]initWithString:signBtnTitle attributes:@{NSFontAttributeName:Default_Font_15,NSForegroundColorAttributeName:NavigationBarColor,NSUnderlineStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleSingle]}];
            [signBtn setAttributedTitle:signBtnAttTitle forState:UIControlStateNormal];
            [signBtn addTarget:self action:@selector(signBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [_headerView addSubview:signBtn];
        }
    }
    return _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
}

-(void)layoutSubViews
{
    self.tableView.height = SCREEN_HEIGHT-64.0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    //获取详情数据
    [self getJobDetail];
}

#pragma mark 报名人数按钮动作
-(void)reportBtnAction
{
    ReportCountViewController *reportCountVC = [[ReportCountViewController alloc]init];
    reportCountVC.jobId = _jobId;
    reportCountVC.title = _jobDetailInfo.name;
    [self.navigationController pushViewController:reportCountVC animated:YES];
}

#pragma mark 签约人数按钮
-(void)signBtnAction
{
    SignCountListViewController *signVC = [[SignCountListViewController alloc]init];
    signVC.jobId = _jobId;
    signVC.title = _jobDetailInfo.name;
    [self.navigationController pushViewController:signVC animated:YES];
}

#pragma mark 底部按钮动作
-(void)footBtnAction:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"刷新"])
    {
        [self.view makeProgress:@"刷新中..."];
        [YMWebServiceClient refreshJobWithParams:@{@"id":[NSString stringWithFormat:@"%d",_jobDetailInfo.id]} Success:^(YMNomalResponse *response) {
            [self.view hiddenProgress];
            if(response.code==ERROR_OK){
                [[NSNotificationCenter defaultCenter]postNotificationName:JumpJobListNotification object:nil];
                [self.navigationController popViewControllerAnimated:YES];
                [self.view.window makeToast:@"刷新成功"];
            }else{
                [self handleErrorWithErrorResponse:response];
            }
        }];
    }
    else if ([sender.titleLabel.text isEqualToString:@"停招"])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确认将停招该职位吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alertView.tag = 1000;
        [alertView show];
        
    }
    else if ([sender.titleLabel.text isEqualToString:@"重新发布"])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确认重新发布该职位吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alertView.tag = 1001;
        [alertView show];
    }
    else if ([sender.titleLabel.text isEqualToString:@"分享"])
    {
        
        UIImage *image = [UIImage imageNamed:@"appLogo"];
        
        NSString* url =
        [NSString stringWithFormat:@"%@/wechat/#/detail/share/%d",
         [LocalDicDataBaseManager getNameWithType:LocalDicTypeShareTitle
                                        VersionId:1],
         _jobDetailInfo.id];
        NSString* shareTitle = _jobDetailInfo.name;
        NSString* shareText =
        [NSString stringWithFormat:@"%d%@", _jobDetailInfo.pay,
         [LocalDicDataBaseManager
          getNameWithType:LocalDicTypeJobPayUnit
          VersionId:_jobDetailInfo.payUnit]];
        [UMSocialData defaultData].extConfig.qqData.url = url;
        [UMSocialData defaultData].extConfig.qqData.title = shareTitle;
        [UMSocialData defaultData].extConfig.qzoneData.url = url;
        [UMSocialData defaultData].extConfig.qzoneData.title = shareTitle;
        
        [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
        [UMSocialData defaultData].extConfig.wechatSessionData.title = shareTitle;
        
        [UMSocialData defaultData].extConfig.wechatFavoriteData.url = url;
        [UMSocialData defaultData].extConfig.wechatFavoriteData.title = shareTitle;
        
        
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = [NSString stringWithFormat:@"%@\n%@",shareTitle,shareText];
        
        
        [UMSocialData defaultData].extConfig.sinaData.shareText = [NSString stringWithFormat:@"%@ \n%@(%d%@) %@", [LocalDicDataBaseManager getNameWithType:LocalDicTypeShareTitle VersionId:2], _jobDetailInfo.name, _jobDetailInfo.pay,
                                                                   [LocalDicDataBaseManager
                                                                    getNameWithType:LocalDicTypeJobPayUnit
                                                                    VersionId:_jobDetailInfo.payUnit],
                                                                   url];
        NSString* imageUrl = [NSString stringWithFormat:@"http://cdn.1mjz.com%@", [LocalDicDataBaseManager getNameWithType:LocalDicTypeShareTitle VersionId:3]];
        
        UMSocialUrlResource* urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:imageUrl];
        [UMSocialData defaultData].extConfig.sinaData.urlResource = urlResource;
        
        
        
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:UMENG_APPKEY
                                          shareText:shareText
                                         shareImage:image
                                    shareToSnsNames:@[
                                                      UMShareToSina,
                                                      UMShareToQQ,
                                                      UMShareToQzone,
                                                      UMShareToWechatSession,
                                                      UMShareToWechatTimeline
                                                      ] delegate:nil];

        
    }
    else if ([sender.titleLabel.text isEqualToString:@"编辑"])
    {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PostJobViewController *postJobVC = [storyBoard instantiateViewControllerWithIdentifier:@"PostJobVC"];
        postJobVC.title = @"编辑职位";
      NSDictionary *jobInfoDic =  @{@"id":[NSNumber numberWithInt:_jobId],@"name":_jobDetailInfo.name,@"workContent":_jobDetailInfo.workContent,@"requireInfo":[NSMutableDictionary dictionaryWithDictionary:@{@"minAge":[NSNumber numberWithInt:_jobDetailInfo.minAge],@"maxAge":[NSNumber numberWithInt:_jobDetailInfo.maxAge],@"sex":[NSNumber numberWithInt:_jobDetailInfo.sex],@"height":[NSNumber numberWithInt:_jobDetailInfo.height],@"grade":[NSNumber numberWithInt:_jobDetailInfo.grade]}],@"baseInfo":[NSMutableDictionary dictionaryWithDictionary:@{@"jobtypeId":[NSNumber numberWithInt:_jobDetailInfo.jobtypeId],@"startTime":[NSNumber numberWithInt:_jobDetailInfo.startTime],@"endTime":[NSNumber numberWithInt:_jobDetailInfo.endTime],@"jobTime":_jobDetailInfo.jobTime,@"pay":[NSNumber numberWithInt:_jobDetailInfo.pay],@"payUnit":[NSNumber numberWithInt:_jobDetailInfo.payUnit],@"jobsettletypeId":[NSNumber numberWithInt:_jobDetailInfo.jobsettletypeId],@"count":[NSNumber numberWithInt:_jobDetailInfo.count],@"tel":_jobDetailInfo.tel,@"contact":_jobDetailInfo.contact,@"cityId":[NSNumber numberWithInt:_jobDetailInfo.cityId],@"areaId":[NSNumber numberWithInt:_jobDetailInfo.areaId],@"street":_jobDetailInfo.street}]};
        postJobVC.jobInfoDic = [NSMutableDictionary dictionaryWithDictionary:jobInfoDic];
        [self.navigationController pushViewController:postJobVC animated:YES];
    }
}

#pragma mark 获取详情数据
-(void)getJobDetail
{
    
    [self.view makeProgress:@"加载中..."];
    [YMWebServiceClient getJobDetailWithParams:@{@"id":[NSNumber numberWithInt:_jobId]} Success:^(YMJobDetailResponse *response) {
        [self.view hiddenProgress];
        if(response.code==ERROR_OK){
            _jobDetailInfo = response.data;
            if (_jobDetailInfo.isCheck==1|_jobDetailInfo.isCheck==2|_jobDetailInfo.isCheck==3) {
                [self.view addSubview:self.footView];
                if (_jobDetailInfo.isCheck==2)
                {
                    self.tableView.tableHeaderView = self.headerView;
                }
            }
            [self.tableView reloadData];
        }else{
            [self handleErrorWithErrorResponse:response];
        }
    }];
}

#pragma mark tableViewDelegate DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat addHeight = 0.0;
    if (indexPath.section==0)
    {
        if (_jobDetailInfo)
        {
            addHeight = [ProjectUtil getAddHeightWithStrArr:@[_jobDetailInfo.address] Font:Default_Font_12 LabelHeight:20 LabelWidth:SCREEN_WIDTH-80];
        }
        
        return 150.0+addHeight;
    }
    else if (indexPath.section==1)
    {
        return 190.0;
    }
    else if (indexPath.section==2)
    {
        
        if (_jobDetailInfo)
        {
            addHeight = [ProjectUtil getAddHeightWithStrArr:@[_jobDetailInfo.workContent] Font:Default_Font_12 LabelHeight:20 LabelWidth:SCREEN_WIDTH-20];
        }
        return 80+addHeight;
    }
    return 44.0;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    headerView.contentView.backgroundColor = DefaultBackGroundColor;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        static NSString *identifier = @"JobDetailInfoCell";
        JobDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"JobDetailInfoCell" owner:nil options:nil]lastObject];
        }
        if (_jobDetailInfo)
        {
            cell.jobNameLabel.text = _jobDetailInfo.name;
            cell.statusLabel.text = [ProjectUtil getJobStatusStrWithIsCheck:_jobDetailInfo.isCheck];
            if (_jobDetailInfo.isCheck==1)
            {
                cell.statusLabel.textColor = DefaultOrangeTextColor;
            }
            else if (_jobDetailInfo.isCheck==2)
            {
                cell.statusLabel.textColor = DefaultGreenTextColor;
            }
            else if (_jobDetailInfo.isCheck==3)
            {
                cell.statusLabel.textColor = DefaultRedTextColor;
            }
            else
            {
                cell.statusLabel.textColor = DefaultGrayTextColor;
            }

            NSString *recruitCountStr = [NSString stringWithFormat:@"%d",_jobDetailInfo.count];
            NSMutableAttributedString *recruitCountAttStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@人",recruitCountStr] attributes:@{NSFontAttributeName:Default_Font_12,NSForegroundColorAttributeName:DefaultGrayTextColor}];
            [recruitCountAttStr addAttribute:NSForegroundColorAttributeName value:DefaultOrangeTextColor range:NSMakeRange(0, recruitCountStr.length)];
            cell.recruitCountLabel.attributedText = recruitCountAttStr;
            NSString *salaryCountStr = [NSString stringWithFormat:@"%d",_jobDetailInfo.pay];
            
            NSString *salaryStr = [NSString stringWithFormat:@"%@%@【%@】",salaryCountStr,[LocalDicDataBaseManager getNameWithType:LocalDicTypeJobPayUnit VersionId:_jobDetailInfo.payUnit],[LocalDicDataBaseManager getNameWithType:LocalDicTypeJobSettleType VersionId:_jobDetailInfo.jobsettletypeId]];
            NSMutableAttributedString *salaryAttStr = [[NSMutableAttributedString alloc]initWithString:salaryStr attributes:@{NSFontAttributeName:Default_Font_12,NSForegroundColorAttributeName:DefaultGrayTextColor}];
            [salaryAttStr addAttribute:NSForegroundColorAttributeName value:DefaultOrangeTextColor range:NSMakeRange(0, salaryCountStr.length)];
            cell.salaryLabel.attributedText = salaryAttStr;
            cell.validTimeLabel.text = [NSString stringWithFormat:@"%@ 至 %@",[ProjectUtil changeToDefaultDateStrWithSp:_jobDetailInfo.startTime],[ProjectUtil changeToDefaultDateStrWithSp:_jobDetailInfo.endTime]];
            cell.addressLabel.text = _jobDetailInfo.address;
            cell.conditionLabel.text = [self getConditionStr];
            if ([cell respondsToSelector:@selector(setLayoutMargins:)])
            {
                cell.layoutMargins = UIEdgeInsetsZero;
            }
        }
        return cell;
    }
    else if (indexPath.section==1)
    {
        static NSString *identifier = @"JobDetailTimeCell";
        JobDetailTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"JobDetailTimeCell" owner:nil options:nil]lastObject];
        }
        if (_timeLabelExist==NO&&_jobDetailInfo!=nil)
        {
            [self addTimeExcelWithSubView:cell.contentView];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        {
            cell.layoutMargins = UIEdgeInsetsZero;
        }
        return cell;
    }
    else if (indexPath.section==2)
    {
        static NSString *identifier = @"JobDetailNomalCell";
        JobDetailNomalCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"JobDetailNomalCell" owner:nil options:nil]lastObject];
        }
        if (indexPath.section==2)
        {
            cell.jobTitleLabel.text = @"兼职描述";
            cell.jobDetailLabel.text = _jobDetailInfo.workContent==nil?@"":_jobDetailInfo.workContent;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        {
            cell.layoutMargins = UIEdgeInsetsZero;
        }
        return cell;
    }
    else
    {
        static NSString *identifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        return cell;
    }
}

#pragma mark 给cell加上时间表格
-(void)addTimeExcelWithSubView:(UIView *)subView
{
    NSArray *strArr = [_jobDetailInfo.jobTime componentsSeparatedByString:@"|"];
    NSMutableArray *tempArr = [NSMutableArray arrayWithObject:@[@"",@"上午",@"下午",@"晚上"]];
    NSArray *weekArr = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    int itemCount = 0;
    for (NSString *tempStr in strArr)
    {
        NSArray *tempStrArr = [tempStr componentsSeparatedByString:@","];
        NSMutableArray *arr = [NSMutableArray arrayWithObject:weekArr[itemCount]];
        [arr addObjectsFromArray:tempStrArr];
        [tempArr addObject:arr];
        itemCount++;
    }
    CGFloat labelTop = 55.0;
    CGFloat labelLeft = 13;
    CGFloat labelWidth = (SCREEN_WIDTH-10*2)/8.0;
    CGFloat labelHeight = 30.0;
    //生成表格label
    for (int i=0; i<tempArr.count; i++)
    {
        for (int j=0; j<4; j++)
        {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(labelLeft+(labelWidth-1)*i, labelTop+(labelHeight-1)*j, labelWidth, labelHeight)];
            label.font = Default_Font_12;
            label.layer.borderColor = RGBCOLOR(109, 109, 109).CGColor;
            label.layer.borderWidth = 1.0;
            label.textColor = RGBCOLOR(55, 55, 55);
            NSArray *labelArr = tempArr[i];
            NSString *labelText = labelArr[j];
            
            label.textAlignment = NSTextAlignmentCenter;
            
            if (i==0|j==0)
            {
                label.backgroundColor = RGBCOLOR(209, 209, 209);
                label.text = labelText;
            }
            else
            {
                if ([labelText intValue]==0)
                {
                    label.text = @"";
                }
                else
                {
                    label.text = @"√";
                }
            }
            [subView addSubview:label];
        }
    }
    _timeLabelExist = YES;
}


#pragma mark 获取招聘条件字符串
-(NSString *)getConditionStr
{
    //招聘条件
    NSString *sexStr;
    if (_jobDetailInfo.sex == 0) {
        sexStr = @"不限";
    } else {
        sexStr = _jobDetailInfo.sex == 2 ?@"女":@"男";
    }
    
    NSString *gradeStr = [LocalDicDataBaseManager getNameWithType:LocalDicTypeJobStudentGrade VersionId:_jobDetailInfo.grade];
    if (gradeStr.length==0)
    {
        gradeStr = @"不限";
    }
    NSString *tallStr;
    if (_jobDetailInfo.height == 0) {
        tallStr = @"不限";
    } else {
        tallStr = [NSString stringWithFormat:@"%dCM",_jobDetailInfo.height];
    }
    NSString *ageStr = @"";
    if (_jobDetailInfo.minAge==0&&_jobDetailInfo.maxAge==0)
    {
        ageStr = @"不限";
    }
    else if (_jobDetailInfo.minAge==0&&_jobDetailInfo.maxAge!=0)
    {
        ageStr = [NSString stringWithFormat:@"%d以下",_jobDetailInfo.maxAge];
    }
    else if (_jobDetailInfo.minAge!=0&&_jobDetailInfo.maxAge==0)
    {
        ageStr = [NSString stringWithFormat:@"%d以上",_jobDetailInfo.minAge];
    }
    else
    {
        ageStr = [NSString stringWithFormat:@"%d - %d",_jobDetailInfo.minAge,_jobDetailInfo.maxAge];
    }
    
    return [NSString stringWithFormat:@"性别%@/学历%@/年龄%@/身高%@",sexStr,gradeStr,ageStr,tallStr];
}

#pragma mark AlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=alertView.cancelButtonIndex)
    {
        if (alertView.tag==1000)
        {
            [self.view makeProgress:@"停招中..."];
            [YMWebServiceClient stopJobWithParams:@{@"id":[NSString stringWithFormat:@"%d",_jobDetailInfo.id]} Success:^(YMNomalResponse *response) {
                [self.view hiddenProgress];
                if(response.code==ERROR_OK){
                    [[NSNotificationCenter defaultCenter]postNotificationName:JumpJobListNotification object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                    [self.view.window makeToast:@"停招成功"];
                }else{
                    [self handleErrorWithErrorResponse:response];
                }
            }];
        }
        else if (alertView.tag==1001)
        {
            [self.view makeProgress:@"发布中..."];
            [YMWebServiceClient repostJobWithParams:@{@"id":[NSString stringWithFormat:@"%d",_jobDetailInfo.id]} Success:^(YMNomalResponse *response) {
                [self.view hiddenProgress];

                if(response.code==ERROR_OK){
                    [[NSNotificationCenter defaultCenter]postNotificationName:JumpJobListNotification object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                    [self.view.window makeToast:@"发布成功"];
                }else{
                    [self handleErrorWithErrorResponse:response];
                }
                
            }];

        }
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
