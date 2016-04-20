//
//  StudentResumeViewController.m
//  YMCorporationIOS
//
//  Created by test on 15/7/6.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "StudentResumeViewController.h"
#import "StuResumeTitleCell.h"
#import "StuBaseInfoCell.h"
#import "StuContactCell.h"
#import "StuDescribeCell.h"
#import "LocalDicDataBaseManager.h"
#import "UIImageView+WebCache.h"

@interface StudentResumeViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    YMStuResumeSummary *_info;
}

@end

@implementation StudentResumeViewController

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
    [self getStuResumeInfo];
}

#pragma mark 获取学生简历信息
-(void)getStuResumeInfo
{
    [YMWebServiceClient getStuResumeWithParams:@{@"id":[NSNumber numberWithInt:_stuId]} Success:^(YMStuResumeResponse *response) {
        if(response.code==ERROR_OK){
            _info = response.data;
            [self.tableView reloadData];
        }else{
            [self handleErrorWithErrorResponse:response];
        }
    }];
}

#pragma mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1&&indexPath.section==0)
    {
        return 140;
    }
    else if (indexPath.row==1&&indexPath.section==2)
    {
        CGFloat addHeight = 0.0;
        if (_info)
        {
            addHeight = [ProjectUtil getAddHeightWithStrArr:@[_info.intro] Font:Default_Font_13 LabelHeight:20 LabelWidth:SCREEN_WIDTH-20];
        }
        
        return 40.0+addHeight;
    }
    return 40.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0&&indexPath.row==1)
    {
        static NSString *identifier = @"StuBaseInfoCell";
        StuBaseInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"StuBaseInfoCell" owner:nil options:nil]lastObject];
        }
        
        if (_info)
        {
            cell.nameLabel.text = [NSString stringWithFormat:@"姓名：%@",_info.name];
            [cell.userAvatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",REQUST_IMAGE_URL,_info.photoscale]] placeholderImage:[UIImage imageNamed:@"stu_avatar"]];
            cell.stuSexLabel.text = [NSString stringWithFormat:@"性别：%@",_info.sex==1?@"男":@"女"];
            cell.stuHeightLabel.text = [NSString stringWithFormat:@"身高：%dcm",_info.height];
            cell.birthLabel.text = [NSString stringWithFormat:@"生日：%@",_info.birthday];
            cell.schoolLabel.text = [NSString stringWithFormat:@"院校：%@%@",_info.city,_info.school];
            cell.gradeLabel.text = [NSString stringWithFormat:@"学历：%@/%@",[LocalDicDataBaseManager getNameWithType:LocalDicTypeJobStudentGrade VersionId:_info.grade],_info.major];
        }
       
        return cell;
    }
    else if (indexPath.section==1&&indexPath.row==1)
    {
        static NSString *identifier = @"StuContactCell";
        StuContactCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"StuContactCell" owner:nil options:nil]lastObject];
        }
        if (_info)
        {
            cell.phoneLabel.text = [NSString stringWithFormat:@"电话：%@",_info.phone];
           
        }
        
        return cell;
    }
    else if (indexPath.section==2&&indexPath.row==1)
    {
        static NSString *identifier = @"StuDescribeCell";
        StuDescribeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"StuDescribeCell" owner:nil options:nil]lastObject];
        }
        cell.describeLabel.text = _info.intro;
        return cell;
    }
    else
    {
        static NSString *identifier = @"StuResumeTitleCell";
        StuResumeTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"StuResumeTitleCell" owner:nil options:nil]lastObject];
        }
        NSString *title = @"";
        if (indexPath.section==0)
        {
            title = @"基本信息";
        }
        else if (indexPath.section==1)
        {
            title = @"联系方式";
        }
        else if (indexPath.section==2)
        {
            title = @"自我描述";
        }
        cell.titleLabel.text = title;
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
