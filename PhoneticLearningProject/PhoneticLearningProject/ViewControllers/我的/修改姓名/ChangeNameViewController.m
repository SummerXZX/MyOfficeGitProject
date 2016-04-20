//
//  ChangeNameViewController.m
//  PhoneticLearningProject
//
//  Created by test on 15/11/16.
//  Copyright © 2015年 yimi. All rights reserved.
//

#import "ChangeNameViewController.h"

@interface ChangeNameViewController () <UITextFieldDelegate>
{
    ReturnObjectBlock _getSelectedName;
}
@property (weak, nonatomic) IBOutlet UITextField *nameField;

@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@end

@implementation ChangeNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
}

-(void)layoutSubViews {
    
    WebLoginData *loginData = [ProjectUtil getLoginData];
    
    _nameField.text = loginData.firstName;
    [self textfieldDidChanged];
    
    //监听文本变化
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(textfieldDidChanged)
     name:UITextFieldTextDidChangeNotification
     object:nil];
    
}

#pragma mark 获取修改的姓名
-(void)getSelectedName:(ReturnObjectBlock)selectedName {
    _getSelectedName = selectedName;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark 监听TextField变化
- (void)textfieldDidChanged
{
    if (_nameField.text.length!=0) {
        _doneBtn.backgroundColor = NavigationBarColor;
        _doneBtn.userInteractionEnabled = YES;
    }
    else {
        _doneBtn.backgroundColor = DefaultUnTouchButtonColor;
        _doneBtn.userInteractionEnabled = NO;
    }
}

#pragma mark 确定动作
- (IBAction)doneAction {
    [self.view endEditing:YES];
    if (_getSelectedName) {
        _getSelectedName (_nameField.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (_doneBtn.userInteractionEnabled) {
        [self doneAction];
    }
    return YES;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
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
