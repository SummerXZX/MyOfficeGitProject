//
//  ChooseCountyViewController.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/13.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "ChooseCountyViewController.h"
#import "CityDataBaseManager.h"

@interface ChooseCountyViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) UITableView *tableView;


@end

@implementation ChooseCountyViewController

#pragma mark tableView
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [ProjectUtil getDefaultTableViewWithType:TableViewTypeNomal];
        _tableView.sectionIndexColor = DefaultGrayTextColor;
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
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
    
    self.tableView.height = SCREEN_HEIGHT-64.0;
    [self.view addSubview:self.tableView];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _countyArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"cell";
    UITableViewCell* cell =
    [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
        cell.textLabel.font = FONT(14);
        cell.textLabel.textColor = DefaultGrayTextColor;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = _countyArr[indexPath.row][@"name"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *vcsArr = self.navigationController.viewControllers;
    [self.navigationController popToViewController:vcsArr[vcsArr.count-3] animated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:GetSelectedCityNotification object:@{@"cityId":@(_cityId),@"areaId":_countyArr[indexPath.row][@"id"]}];
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
