//
//  UnitCourseViewController.m
//  PhoneticLearningProject
//
//  Created by test on 15/11/15.
//  Copyright © 2015年 yimi. All rights reserved.
//

#import "UnitCourseViewController.h"
#import "BookDataBaseManager.h"
#import "CourseDetailViewController.h"
#import "VocabularyViewController.h"

@interface UnitCourseViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_dataArr;
}


@end

@implementation UnitCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
}

-(void)layoutSubViews {
    _dataArr = [BookDataBaseManager getAllBookUnitCourseWithUnitName:_unitname];
    self.tableView.height = SCREEN_HEIGHT-64.0;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.font = FONT(15);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    UnitCourseInfo *info = _dataArr[indexPath.row];
    cell.textLabel.text = info.name;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UnitCourseInfo *info = _dataArr[indexPath.row];
    if ([info.name isEqualToString:@"Vocabulary"]) {
        VocabularyViewController *nextVC = [[VocabularyViewController alloc] init];
        nextVC.title = @"词汇";
        nextVC.bookname = _bookname;
        nextVC.unitname = _unitname;
        nextVC.coursename = info.name;
        [self.navigationController pushViewController:nextVC animated:YES];
    }
    else {
        CourseDetailViewController *nextVC = [[CourseDetailViewController alloc]init];
        nextVC.title = @"课程详情";
        nextVC.bookname = _bookname;
        nextVC.unitname = _unitname;
        nextVC.coursename = info.name;
        [self.navigationController pushViewController:nextVC animated:YES];
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
