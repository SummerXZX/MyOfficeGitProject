//
//  ChangeGradeViewController.m
//  PhoneticLearningProject
//
//  Created by test on 15/11/16.
//  Copyright © 2015年 yimi. All rights reserved.
//

#import "ChangeGradeViewController.h"

@interface ChangeGradeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_dataArr;
    ReturnObjectBlock _getSelectedGradeInfo;
}

@end

@implementation ChangeGradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
}

-(void)layoutSubViews {
    _dataArr = @[@"三年级",@"四年级",@"五年级",@"六年级",@"七年级",@"八年级",@"九年级"];
    self.tableView.height = SCREEN_HEIGHT-64.0;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

#pragma mark 获取修改的年级
-(void)getSelectedGradeInfo:(ReturnObjectBlock)selectedGradeInfo {
    _getSelectedGradeInfo = selectedGradeInfo;
}

#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *idenitifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenitifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenitifier];
        cell.textLabel.font = FONT(15);
        cell.textLabel.textColor = DefaultGrayTextColor;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = _dataArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_getSelectedGradeInfo) {
        _getSelectedGradeInfo (_dataArr[indexPath.row]);
    }
    
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
