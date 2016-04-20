//
//  FeedbackViewController.m
//  YMCorporationIOS
//
//  Created by test on 15/7/17.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *feedbackTextView;
@property (weak, nonatomic) IBOutlet UILabel *feedbackPlaceHolder;
@property (weak, nonatomic) IBOutlet UILabel *feedbackTipLabel;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark 提交反馈
- (IBAction)postFeedbackAction
{
    [self.view endEditing:YES];
    if (_feedbackTextView.text.length==0)
    {
        [self.view makeToast:@"请填写反馈内容"];
    }
    else
    {
        [self.view makeProgress:@"提交中..."];
        [YMWebServiceClient feedbackWithParams:@{@"txt":_feedbackTextView.text} Success:^(YMNomalResponse *response) {
            [self.view hiddenProgress];
            if(response.code==ERROR_OK){
                [self.navigationController popViewControllerAnimated:YES];
                [self.view.window makeToast:@"提交成功"];
            }else{
                [self handleErrorWithErrorResponse:response];
            }
        }];
    }
}

#pragma mark UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length!=0)
    {
        _feedbackPlaceHolder.hidden = YES;
    }
    else
    {
        _feedbackPlaceHolder.hidden = NO;
    }
    if (textView.text.length>500)
    {
        _feedbackTipLabel.text  = @"已达最大字数限制";
    }
    else
    {
        _feedbackTipLabel.text = [NSString stringWithFormat:@"%ld/500",(long)textView.text.length];
    }
}

#pragma mark tableviewdelegate,datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
