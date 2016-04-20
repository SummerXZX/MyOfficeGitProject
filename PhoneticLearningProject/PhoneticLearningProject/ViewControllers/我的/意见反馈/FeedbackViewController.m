//
//  FeedbackViewController.m
//  PhoneticLearningProject
//
//  Created by test on 15/11/17.
//  Copyright © 2015年 yimi. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController () <UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel* feedBackPlaceLabel;

@property (weak, nonatomic) IBOutlet UITextView* feedBackTextView;

@property (weak, nonatomic) IBOutlet UITextField* contactField;


@property (weak, nonatomic) IBOutlet UIButton *postBtn;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
}

-(void)layoutSubViews {
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(textfieldDidChanged)
     name:UITextFieldTextDidChangeNotification
     object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UITextFieldTextDidChangeNotification
     object:nil];
}

#pragma mark 监听TextField变化
- (void)textfieldDidChanged
{
    if (_contactField.text.length == PHONELENGTH  && _feedBackTextView.text.length != 0) {
        _postBtn.backgroundColor = NavigationBarColor;
        _postBtn.userInteractionEnabled = YES;

       
    }
    else {
        _postBtn.backgroundColor = DefaultUnTouchButtonColor;
        _postBtn.userInteractionEnabled = NO;
    }
}

#pragma mark 提交
- (IBAction)postAction {
    [self.view endEditing:YES];
    [self.view makeProgress:@"提交中..."];
    WebLoginData *loginData = [ProjectUtil getLoginData];
    [WebServiceClient feedbackWithParams:@{@"uid":loginData.userId,@"content":_feedBackTextView.text} success:^(WebNomalResponse *response) {
        [self.view hiddenProgress];
        [self.view.window makeToast:@"反馈成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } Fail:^(NSError *error) {
        [self.view hiddenProgress];
        [self.view makeToast:error.domain];
    }];
}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView*)textView {
    if (textView.text.length != 0) {
        _feedBackPlaceLabel.hidden = YES;
        if (_contactField.text.length == PHONELENGTH) {
            _postBtn.backgroundColor = NavigationBarColor;
            _postBtn.userInteractionEnabled = YES;
                  }
        else {
            _postBtn.backgroundColor = DefaultUnTouchButtonColor;
            _postBtn.userInteractionEnabled = NO;
        }
    }
    else {
        _feedBackPlaceLabel.hidden = NO;
        _postBtn.backgroundColor = DefaultUnTouchButtonColor;
        _postBtn.userInteractionEnabled = NO;
    }

}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    if (_postBtn.userInteractionEnabled) {
        [self postAction];
    }
    return YES;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
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
