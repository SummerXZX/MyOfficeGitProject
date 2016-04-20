//
//  PostOtherRequireViewController.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/23.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "PostOtherRequireViewController.h"
#import "LocalDicDataBaseManager.h"
#import "PostOtherRequireCell.h"
#import "PostOtherRequireChooseAgeView.h"
#import "PostJobOtherRequireChooseCell.h"

@interface PostOtherRequireViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    PostOtherReqireSaveAction _saveAction;
    NSMutableArray *_dataArr;
}

@property (strong,nonatomic) UITableView *tableView;



@end

@implementation PostOtherRequireViewController

#pragma mark tableView
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [ProjectUtil getDefaultTableViewWithType:TableViewTypeNomal];
        _tableView.height = SCREEN_HEIGHT-64.0;
        _tableView.delegate =self;
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
    NSMutableArray *gradeArr = [NSMutableArray arrayWithArray:[LocalDicDataBaseManager getJobStudentGrade]];
    [gradeArr insertObject:@{@"name":@"不限",@"id":@0} atIndex:0];
    
    _dataArr = [NSMutableArray arrayWithArray:@[@{},
                                                @{@"title":@"性别要求",@"items":@[@{@"name":@"不限",@"id":@0},
                                                                              @{@"name":@"男",@"id":@1},
                                                                              @{@"name":@"女",@"id":@2},
                                                                              ]},
                                                @{@"title":@"学历要求",@"items":[NSArray arrayWithArray:gradeArr]},
                                                @{@"title":@"身高要求",@"items":@[@{@"name":@"不限",@"id":@0},
                                                                              @{@"name":@"160cm+",@"id":@160},
                                                                              @{@"name":@"165cm+",@"id":@165},
                                                                              @{@"name":@"170cm+",@"id":@170},
                                                                              @{@"name":@"175cm+",@"id":@175},
                                                                              @{@"name":@"180cm+",@"id":@180},
                                                                              ]},
                                                ]];
    if (_jobStatus!=PostJobStatusDetail) {
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60.0)];
        footView.backgroundColor = DefaultBackGroundColor;
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saveBtn.frame = CGRectMake(10, 10, SCREEN_WIDTH-20.0, 40.0);
        saveBtn.layer.cornerRadius = 5.0;
        [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        saveBtn.backgroundColor = DefaultOrangeColor;
        [saveBtn addTarget:self action:@selector(saveBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:saveBtn];
        self.tableView.tableFooterView = footView;
    }
    else {
        self.view.userInteractionEnabled = NO;
    }
    
    
    
    
}

#pragma mark 保存动作
-(void)postOtherRequireSavaAction:(PostOtherReqireSaveAction)saveAction {
    _saveAction = saveAction;
}

#pragma mark 保存按钮动作
-(void)saveBtnAction {
    if (_saveAction) {
        _saveAction ();
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


#pragma mark UITableViewDelegate,UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return 44.0;
    }
    
    NSArray *itemArr = _dataArr[indexPath.section][@"items"];
    return [PostOtherRequireCell getCellHeightWithDataCount:itemArr.count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return 0.0;
    }
    return 10.0;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
        static NSString *identifier = @"PostJobOtherRequireChooseCell";
        PostJobOtherRequireChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"PostJobOtherRequireChooseCell" owner:nil options:nil]lastObject];
            [cell.chooseBtn addTarget:self action:@selector(chooseBtnAction) forControlEvents:UIControlEventTouchUpInside];
        }
        NSString * ageStr = @"";
        if (self.minAge==0&&self.maxAge==0) {
            ageStr = @"不限";
        }
        else {
            ageStr = [NSString stringWithFormat:@"%ld-%ld",(long)self.minAge,(long)self.maxAge];
        }
        [cell.chooseBtn setTitle:ageStr forState:UIControlStateNormal];
        return cell;
    }
    else {
        static NSString *identifier = @"PostOtherRequireCell";
        PostOtherRequireCell*cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil) {
            cell = [[PostOtherRequireCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            
            PostOtherRequireViewController *__weak weakVC = self;
            PostOtherRequireCell *__weak weakCell = cell;
            [cell requireChanged:^{
                switch (cell.tag) {
                    
                    case 1:
                    {
                        //性别
                        weakVC.sex = weakCell.selectedDicId;
                    }
                        break;
                    case 2:
                    {
                        //学历
                        weakVC.grade = weakCell.selectedDicId;
                    }
                        break;
                    case 3:
                    {
                        //年龄
                        weakVC.height = weakCell.selectedDicId;
                    }
                        break;
                        
                    default:
                        break;
                }
                
            }];
            
        }
        cell.tag = indexPath.section;
        cell.titleLabel.text = _dataArr[indexPath.section][@"title"];
        cell.itemArr = _dataArr[indexPath.section][@"items"];
        switch (indexPath.section) {
            case 1:
                cell.selectedDicId = _sex;
                break;
            case 2:
                cell.selectedDicId = _grade;
                break;
            case 3:
                cell.selectedDicId = _height;
                break;
            default:
                break;
        }
        return cell;

    }
}

#pragma mark 选择按钮动作
-(void)chooseBtnAction{
    //年龄
    PostOtherRequireChooseAgeView *ageView = [[PostOtherRequireChooseAgeView alloc]init];
    ageView.minAge = self.minAge;
    ageView.maxAge = self.maxAge;
    PostOtherRequireChooseAgeView *__weak weakView = ageView;
    PostOtherRequireViewController *__weak weakVC = self;
    [ageView confirmAction:^{
        weakVC.minAge = weakView.minAge;
        weakVC.maxAge = weakView.maxAge;
        [weakVC.tableView reloadData];
    }];
    [ageView show];
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
