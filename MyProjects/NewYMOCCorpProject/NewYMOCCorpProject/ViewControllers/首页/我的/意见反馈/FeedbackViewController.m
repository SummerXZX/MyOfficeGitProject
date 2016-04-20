//
//  FeedbackViewController.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/15.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "FeedbackViewController.h"
#import <IQTextView.h>

@interface FeedbackViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet IQTextView *feedbackTextView;
@property (weak, nonatomic) IBOutlet UILabel *feedbackTipLabel;
@property (weak, nonatomic) IBOutlet UIButton *postBtn;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewBasicProperty];
    [self layoutSubViews];
}

-(void)layoutSubViews {
    
}

#pragma mark 提交反馈
- (IBAction)postFeedbackAction
{
    [self.view endEditing:YES];
    [self.view showProgressHintWith:@"提交中"];
    [YMWebClient feedbackWithParams:@{@"txt":_feedbackTextView.text} Success:^(YMNomalResponse *response) {
        [self.view dismissProgress];
        if(response.code==ERROR_OK){
            [self.navigationController popViewControllerAnimated:YES];
            [self.view.window showSuccessHintWith:@"提交成功"];
        }else
        {
            [self handleErrorWithErrorResponse:response ShowHint:YES];
        }
    }];
}

#pragma mark UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length!=0) {
        _postBtn.backgroundColor = DefaultOrangeColor;
        _postBtn.userInteractionEnabled = YES;
    }
    else {
        _postBtn.backgroundColor = DefaultUnTouchButtonColor;
        _postBtn.userInteractionEnabled = NO;
    }
    if (textView.text.length>140)
    {
        _postBtn.backgroundColor = DefaultUnTouchButtonColor;
        _postBtn.userInteractionEnabled = NO;
        _feedbackTipLabel.text  = @"已达最大字数限制";
    }
    else
    {
        _feedbackTipLabel.text = [NSString stringWithFormat:@"%ld/140",(long)textView.text.length];
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *totalStr = [textView.text stringByAppendingString:text];
    if (totalStr.length>140) {
        return NO;
    }
    return YES;
}

-(void)dealloc {
    [ProjectUtil showLog:NSStringFromClass([self class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
