//
//  BookDetailViewController.m
//  PhoneticLearningProject
//
//  Created by test on 15/11/13.
//  Copyright © 2015年 yimi. All rights reserved.
//

#import "BookUnitViewController.h"
#import "BookDataBaseManager.h"
#import "UnitCourseViewController.h"

@interface BookUnitViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_dataArr;
}
@end

@implementation BookUnitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
}

-(void)layoutSubViews {
    _dataArr = [BookDataBaseManager getAllBookUnitWithBookName:_bookname];
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
        cell.imageView.image = [UIImage imageNamed:@"unit_star"];
        cell.textLabel.textColor = NavigationBarColor;
        cell.textLabel.font = FONT(15);
    }
    BookUnitInfo *info = _dataArr[indexPath.row];
    cell.textLabel.text = info.name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BookUnitInfo *info = _dataArr[indexPath.row];
    UnitCourseViewController *nextVC = [[UnitCourseViewController alloc]init];
    nextVC.title = @"课程目录";
    nextVC.unitname = info.name;
    nextVC.bookname = _bookname;
    [self.navigationController pushViewController:nextVC animated:YES];
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
