//
//  JobRequireViewController.m
//  YMCorporationIOS
//
//  Created by test on 15/6/26.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "JobRequireViewController.h"
#import "MyPickView.h"
#import "LocalDicDataBaseManager.h"

@interface JobRequireViewController ()
{
    JobRequireBlock _requireBlock;
}
@property (weak, nonatomic) IBOutlet UIButton *minAgeBtn;
@property (weak, nonatomic) IBOutlet UIButton *maxAgeBtn;
@property (weak, nonatomic) IBOutlet UIButton *sexBtn;
@property (weak, nonatomic) IBOutlet UIButton *gradeBtn;
@property (weak, nonatomic) IBOutlet UIButton *tallBtn;

@property (nonatomic,strong) NSArray *ageArr;
@property (nonatomic,strong) NSArray *sexArr;
@property (nonatomic,strong) NSArray *tallArr;
@property (nonatomic,strong) NSArray *gradeArr;
@end

@implementation JobRequireViewController

#pragma mark ageArr
-(NSArray *)ageArr
{
    if (!_ageArr)
    {
        _ageArr = @[@{@"name":@"不限",@"id":[NSNumber numberWithInt:0]},@{@"name":@"18",@"id":[NSNumber numberWithInt:18]},@{@"name":@"19",@"id":[NSNumber numberWithInt:19]},@{@"name":@"20",@"id":[NSNumber numberWithInt:20]},@{@"name":@"21",@"id":[NSNumber numberWithInt:21]},@{@"name":@"22",@"id":[NSNumber numberWithInt:22]},@{@"name":@"23",@"id":[NSNumber numberWithInt:23]},@{@"name":@"24",@"id":[NSNumber numberWithInt:24]},@{@"name":@"25",@"id":[NSNumber numberWithInt:25]}];
    }
    return _ageArr;
}

#pragma mark sexArr
-(NSArray *)sexArr
{
    if (!_sexArr)
    {
        _sexArr = @[@{@"name":@"不限",@"id":[NSNumber numberWithInt:0]},@{@"name":@"男",@"id":[NSNumber numberWithInt:1]},@{@"name":@"女",@"id":[NSNumber numberWithInt:2]}];
    }
    return _sexArr;
}

#pragma mark  tallArr
-(NSArray *)tallArr
{
    if (!_tallArr)
    {
        _tallArr = @[@{@"name":@"不限",@"id":[NSNumber numberWithInt:0]},@{@"name":@"150CM以上",@"id":[NSNumber numberWithInt:150]},@{@"name":@"155CM以上",@"id":[NSNumber numberWithInt:155]},@{@"name":@"160CM以上",@"id":[NSNumber numberWithInt:160]},@{@"name":@"165CM以上",@"id":[NSNumber numberWithInt:165]},@{@"name":@"170CM以上",@"id":[NSNumber numberWithInt:170]},@{@"name":@"175CM以上",@"id":[NSNumber numberWithInt:175]},@{@"name":@"180CM以上",@"id":[NSNumber numberWithInt:180]}];
    }
    return _tallArr;
}

#pragma mark gradeArr
-(NSArray *)gradeArr
{
    if (!_gradeArr)
    {
        NSMutableArray *tempArr = [NSMutableArray arrayWithObject:@{@"id":[NSNumber numberWithInt:0],@"name":@"不限"}];
        [tempArr addObjectsFromArray:[LocalDicDataBaseManager getJobStudentGrade]];
        _gradeArr = [NSArray arrayWithArray:tempArr];
    }
    return _gradeArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
}

-(void)layoutSubViews
{
    if (!_jobRequireDic)
    {
        _jobRequireDic = [NSMutableDictionary dictionary];
    }
    else
    {
    
        [_minAgeBtn setTitle:[self getAgeStrWithAgeCount:[_jobRequireDic[@"minAge"]intValue]] forState:UIControlStateNormal];
        [_minAgeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _minAgeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [_maxAgeBtn setTitle:[self getAgeStrWithAgeCount:[_jobRequireDic[@"maxAge"]intValue]] forState:UIControlStateNormal];
        [_maxAgeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _maxAgeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
       
        [_sexBtn setTitle:[self getSexStrWithSexCount:[_jobRequireDic[@"sex"]intValue]] forState:UIControlStateNormal];
        [_sexBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        
        [_gradeBtn setTitle:[self getGradeStrWithGradeCount:[_jobRequireDic[@"grade"]intValue]] forState:UIControlStateNormal];
        [_gradeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [_tallBtn setTitle:[self getTallStrWithTallCount:[_jobRequireDic[@"height"]intValue]] forState:UIControlStateNormal];
        [_tallBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];        
    }
}

#pragma mark 获取AgeStr
-(NSString *)getAgeStrWithAgeCount:(int)age
{
    if (age == 0)
    {
        return @"不限";
    }
    else
    {
        return [NSString stringWithFormat:@"%d",age];
    }
}

#pragma mark 获取Age索引
-(NSInteger)getAgeIndexWithAge:(int)age
{
    int count=0;
    for (NSDictionary *dic in self.ageArr)
    {
        if ([dic[@"id"] intValue]==age)
        {
            return count;
        }
        count++;
    }
    return count;
}

#pragma mark 获取SexStr
-(NSString *)getSexStrWithSexCount:(int)sex
{
    if (sex==1)
    {
        return @"男";
    }
    else if (sex==2)
    {
        return @"女";
    }
    else
    {
        return @"不限";
    }
}


#pragma mark 获取gradeStr
-(NSString *)getGradeStrWithGradeCount:(int)grade
{
    if (grade == 0)
    {
        return @"不限";
    }
    else
    {
        return [LocalDicDataBaseManager getNameWithType:LocalDicTypeJobStudentGrade VersionId:grade];
    }
}

#pragma mark 获取tallStr
-(NSString *)getTallStrWithTallCount:(int)tall
{
    if (tall==0)
    {
        return @"不限";
    }
    else
    {
        return [NSString stringWithFormat:@"%dCM以上",tall];
    }
}

#pragma mark 获取tall索引
-(NSInteger)getTallIndexWithTall:(int)tall
{
    int count=0;
    for (NSDictionary *tallDic in self.tallArr)
    {
        if ([tallDic[@"id"] intValue]==tall)
        {
            return count;
        }
        count++;
    }
    return count;
}


-(void)handleRequireInfo:(JobRequireBlock)requireInfoBlock
{
    _requireBlock = requireInfoBlock;
}

#pragma mark 选择最小年龄要求
- (IBAction)chooseMinAge
{
    MyPickView *pickView = [[MyPickView alloc]initWithTitle:@"请选择最小年龄" Items:@[self.ageArr]];
    if (_jobRequireDic[@"minAge"])
    {
        [pickView.pickView selectRow:[self getAgeIndexWithAge:[_jobRequireDic[@"minAge"]intValue]] inComponent:0 animated:YES];
    }
    [pickView handleConfirm:^(NSArray *selectedArr) {
        
        [_jobRequireDic setObject:selectedArr[0] forKey:@"minAge"];
        [_minAgeBtn setTitle:[self getAgeStrWithAgeCount:[_jobRequireDic[@"minAge"]intValue]] forState:UIControlStateNormal];
        [_minAgeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _minAgeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
    }];
    [pickView show];
}



#pragma mark 选择最大年龄要求
- (IBAction)chooseMaxAge
{
    MyPickView *pickView = [[MyPickView alloc]initWithTitle:@"请选择最大年龄" Items:@[self.ageArr]];
    if (_jobRequireDic[@"maxAge"])
    {
        [pickView.pickView selectRow:[self getAgeIndexWithAge:[_jobRequireDic[@"maxAge"]intValue]] inComponent:0 animated:YES];
    }
    [pickView handleConfirm:^(NSArray *selectedArr) {
        [_jobRequireDic setObject:selectedArr[0] forKey:@"maxAge"];
        [_maxAgeBtn setTitle:[self getAgeStrWithAgeCount:[_jobRequireDic[@"maxAge"]intValue]] forState:UIControlStateNormal];
        [_maxAgeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _maxAgeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

        
    }];
     [pickView show];
}

#pragma mark 选择性别
- (IBAction)chooseSex
{
    
    MyPickView *pickView = [[MyPickView alloc]initWithTitle:@"请选择性别要求" Items:@[self.sexArr]];
    if (_jobRequireDic[@"sex"])
    {
        [pickView.pickView selectRow:[_jobRequireDic[@"sex"]integerValue] inComponent:0 animated:YES];
    }
    [pickView handleConfirm:^(NSArray *selectedArr) {
         [_jobRequireDic setObject:selectedArr[0] forKey:@"sex"];
        [_sexBtn setTitle:[self getSexStrWithSexCount:[_jobRequireDic[@"sex"]intValue]] forState:UIControlStateNormal];
        [_sexBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
       
    }];
     [pickView show];
}

#pragma mark 选择学历
- (IBAction)chooseGrade
{
    
    
    MyPickView *pickView = [[MyPickView alloc]initWithTitle:@"请选择学历要求" Items:@[self.gradeArr]];
    if (_jobRequireDic[@"grade"])
    {
        
        [pickView.pickView selectRow:[_jobRequireDic[@"sex"]integerValue] inComponent:0 animated:YES];
    }
    [pickView handleConfirm:^(NSArray *selectedArr) {
         [_jobRequireDic setObject:selectedArr[0] forKey:@"grade"];
        [_gradeBtn setTitle:[self getGradeStrWithGradeCount:[_jobRequireDic[@"grade"]intValue]] forState:UIControlStateNormal];
        [_gradeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
       
    }];
     [pickView show];
}

#pragma mark 选择身高
- (IBAction)chooseTall
{
    MyPickView *pickView = [[MyPickView alloc]initWithTitle:@"请选择身高" Items:@[self.tallArr]];
    if (_jobRequireDic[@"height"])
    {
        
        [pickView.pickView selectRow:[self getTallIndexWithTall:[_jobRequireDic[@"height"]intValue]] inComponent:0 animated:YES];
    }
    [pickView handleConfirm:^(NSArray *selectedArr) {
        [_jobRequireDic setObject:selectedArr[0] forKey:@"height"];
        [_tallBtn setTitle:[self getTallStrWithTallCount:[_jobRequireDic[@"height"]intValue]] forState:UIControlStateNormal];
        [_tallBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      
    }];
     [pickView show];
}

#pragma mark 保存动作
- (IBAction)saveAction {
    if (!_jobRequireDic[@"minAge"])
    {
        [self.view makeToast:@"请选择最小年龄"];
    }
    else if (!_jobRequireDic[@"maxAge"])
    {
        [self.view makeToast:@"请选择最大年龄"];
    }
    else if (!_jobRequireDic[@"sex"])
    {
        [self.view makeToast:@"请选择性别要求"];
    }
    else if (!_jobRequireDic[@"grade"])
    {
        [self.view makeToast:@"请选择学历要求"];
    }
    else if (!_jobRequireDic[@"height"])
    {
        [self.view makeToast:@"请选择最大年龄"];
    }
    else
    {
        if (_requireBlock)
        {
            _requireBlock(_jobRequireDic);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


#pragma mark tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        cell.layoutMargins = UIEdgeInsetsZero;
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
