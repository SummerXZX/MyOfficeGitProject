//
//  ApplyForAuthenticateViewController.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/6.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "ApplyForAuthenticateViewController.h"
#import "ApplyForAuthenHeaderView.h"
#import "UIScrollView+EmptyDataSet.h"


@interface ApplyForAuthenticateViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSInteger _checkStatus;
}

@property (weak, nonatomic) IBOutlet UIButton *businBtn;///<营业执照imageView
@property (weak, nonatomic) IBOutlet UIButton *idCardBtn;///<身份证imageView

@end

@implementation ApplyForAuthenticateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewBasicProperty];
 
    [self layoutSubViews];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)layoutSubViews {
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    YMLoginInfo *loginInfo = [ProjectUtil getLoginInfo];
    _checkStatus = loginInfo.checkStatus;
    [self reloadSubViewData];
}

-(void)reloadSubViewData {
    if (_checkStatus==1) {
        UIButton *postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        postBtn.frame = CGRectMake(0, 0, 60, 30);
        postBtn.titleLabel.font = FONT(15);
        postBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [postBtn setTitle:@"提交" forState:UIControlStateNormal];
        [postBtn setTitleColor:DefaultOrangeColor forState:UIControlStateNormal];
        [postBtn addTarget:self action:@selector(postBtnAction) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:postBtn];
    }
    else {
        self.navigationItem.rightBarButtonItem = nil;
    }
    [self.tableView reloadData];
}

#pragma mark 提交认证申请
-(void)postBtnAction {
    if (!_businBtn.selected) {
        [self.view showFailHintWith:@"请上传营业执照"];
    }
    else if (!_idCardBtn.selected) {
        [self.view showFailHintWith:@"请上传身份证"];
    }
    else {
        NSDictionary *params = @{@"photos":@[@{@"image":[_businBtn imageForState:UIControlStateSelected],
                                               @"name":@"businum",
                                               @"fileName":@"businum.jpeg",
                                               @"mimeType":@"image/jpeg"
                                               },
                                             @{@"image":[_idCardBtn imageForState:UIControlStateSelected],
                                               @"name":@"idcard",
                                               @"fileName":@"idcard.jpeg",
                                               @"mimeType":@"image/jpeg"
                                               },
                                             ]};
        [self.view showProgressHintWith:@"上传中"];
        [YMWebClient postCheckWithParams:params Success:^(YMNomalResponse *response) {
            [self.view dismissProgress];
            if (response.code==ERROR_OK) {
                [self.view showSuccessHintWith:@"上传信息成功"];
                _checkStatus = 4;
                 YMLoginInfo *loginInfo = [ProjectUtil getLoginInfo];
                loginInfo.checkStatus = _checkStatus;
                [ProjectUtil saveLoginInfo:loginInfo];
                [self reloadSubViewData];
            }
            else {
                [self handleErrorWithErrorResponse:response ShowHint:YES];
            }
        }];
    }
    
}

#pragma mark 上传营业执照
-(IBAction)uploadAction:(UIButton *)sender {
    
    UIActionSheet* choiceSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照", @"从相册中选取", nil];
    choiceSheet.tag = sender.tag;
    [choiceSheet showInView:self.view];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_checkStatus==1) {
        return 3;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *identifier = @"HeaderView";
    ApplyForAuthenHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (headerView==nil) {
        headerView = [[ApplyForAuthenHeaderView alloc]initWithReuseIdentifier:identifier];
    }
    NSMutableAttributedString *attStr =[[NSMutableAttributedString alloc]initWithString:@"  "];
    NSTextAttachment *attach = [[NSTextAttachment alloc]init];
    [attStr appendAttributedString:[NSAttributedString attributedStringWithAttachment:attach]];
    switch (section) {
        case 0:
        {
            attach.image = [UIImage imageNamed:@"sqrz_rztq"];
            attach.bounds = CGRectMake(0, -4, 15, 20);
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@" 认证特权" attributes:@{NSFontAttributeName:FONT(15),NSForegroundColorAttributeName:[UIColor blackColor]}]];
        }
            break;
        case 1:
        {
            attach.image = [UIImage imageNamed:@"sqrz_sctp"];
            attach.bounds = CGRectMake(0, 0, 12, 12);
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@" 上传图片" attributes:@{NSFontAttributeName:FONT(15),NSForegroundColorAttributeName:[UIColor blackColor]}]];
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"（营业执照或负责人身份证照片）" attributes:@{NSFontAttributeName:FONT(12),NSForegroundColorAttributeName:DefaultLightGrayTextColor}]];
        }
            break;
        case 2:
        {
            attach.image = [UIImage imageNamed:@"sqrz_syck"];
            attach.bounds = CGRectMake(0, 0, 12, 12);
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@" 示意参考" attributes:@{NSFontAttributeName:FONT(15),NSForegroundColorAttributeName:[UIColor blackColor]}]];
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"（营业执照或负责人身份证照片）" attributes:@{NSFontAttributeName:FONT(12),NSForegroundColorAttributeName:DefaultLightGrayTextColor}]];
        }
            break;
        default:
            break;
    }
    headerView.titleLabel.attributedText = attStr;
    return headerView;
    
}

#pragma mark DZNEmptyDataSetSource,DZNEmptyDataSetDelegate

-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if (_checkStatus==3) {
        return [UIImage imageNamed:@"sqrz_sb"];
    }
    else if (_checkStatus==4) {
        return [UIImage imageNamed:@"sqrz_rzz"];
    }
    return nil;
}

-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text;
    if (_checkStatus==3) {
        text = @"认证失败";
    }
    else if (_checkStatus==4) {
        text = @"审核中";
    }
    if (text.length!=0) {
        return [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:FONT(17),NSForegroundColorAttributeName:[UIColor blackColor]}];
    }
    return nil;
}

-(NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text;
    if (_checkStatus==3) {
        text = @"由于您的身份证信息和营业执照信息不合被驳回";
    }
    else if (_checkStatus==4) {
        text = @"请耐心等待";
    }
    if (text.length!=0) {
        return [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:FONT(15),NSForegroundColorAttributeName:DefaultFailTitleTextColor}];
    }
    return nil;
}

-(CGSize)buttonSizeForEmptyDataSet:(UIScrollView *)scrollView {
    return CGSizeMake(SCREEN_WIDTH-20.0, 40.0);
}

-(CGFloat)buttonCornerRadiusForEmptyDataSet:(UIScrollView *)scrollView {
    return 5.0;
}

-(NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSString *text;
    if (_checkStatus==3) {
        text = @"重新认证";
    }
    else if (_checkStatus==4) {
        text = @"确定";
    }
    if (text.length!=0) {
        return [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:FONT(17),NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }
    return nil;
}

-(void)emptyDataSetDidTapButton:(UIScrollView *)scrollView {
    if (_checkStatus==3) {
        _checkStatus = 1;
        [self reloadSubViewData];
    }
    else if (_checkStatus==4) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(UIColor *)buttonBackgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return DefaultOrangeColor;
}


#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet*)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        UIImagePickerController* imagePickerVC =
        [[UIImagePickerController alloc] init];
        imagePickerVC.delegate = self;
        imagePickerVC.allowsEditing = YES;
        imagePickerVC.view.tag = actionSheet.tag;
        if (buttonIndex == 0 &&
            [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES) {
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else {
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController*)picker
didFinishPickingMediaWithInfo:(NSDictionary*)info {
     [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *scaleImage = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0.4)];
    if (picker.view.tag==101) {
        _businBtn.selected = YES;
        [_businBtn setImage:scaleImage forState:UIControlStateSelected];
    }
    else if (picker.view.tag==102) {
        _idCardBtn.selected = YES;
        [_idCardBtn setImage:scaleImage forState:UIControlStateSelected];
    }
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
