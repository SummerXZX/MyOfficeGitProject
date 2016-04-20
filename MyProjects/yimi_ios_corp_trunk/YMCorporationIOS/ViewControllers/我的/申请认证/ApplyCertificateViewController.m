//
//  ApplyCertificateViewController.m
//  YMCorporationIOS
//
//  Created by test on 15/7/14.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "ApplyCertificateViewController.h"
#import "UIButton+WebCache.h"

typedef NS_ENUM(NSInteger, SelectedType)
{
    SelectedTypeIdentity,
    SelectedTypeBusiness
};

@interface ApplyCertificateViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    SelectedType _selectedType;
}
@property (weak, nonatomic) IBOutlet UILabel *identityLabel;
@property (weak, nonatomic) IBOutlet UIButton *identityImageView;
@property (weak, nonatomic) IBOutlet UIButton *businessImageView;
@property (weak, nonatomic) IBOutlet UILabel *businessLabel;

@end

@implementation ApplyCertificateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
}

-(void)layoutSubViews
{
    YMCorpSummary *corpInfo = [ProjectUtil getCorpInfo];
     [_identityImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",REQUST_IMAGE_URL,corpInfo.idnumberscale]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"update_logo"]];
    [_businessImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",REQUST_IMAGE_URL,corpInfo.businumberscale]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"update_logo"]];
    
}

#pragma mark 上传身份证照片
- (IBAction)identityAction
{
    _selectedType = SelectedTypeIdentity;
    [self showActionSheet];
}

#pragma mark 上传营业执照
- (IBAction)businessAction
{
    _selectedType = SelectedTypeBusiness;
     [self showActionSheet];
}

#pragma mark 弹出选择上传招聘actionsheet
-(void)showActionSheet
{
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    if (self.navigationController.tabBarController.tabBar != nil) {
        [choiceSheet showFromTabBar:self.navigationController.tabBarController.tabBar];
        
    } else {
        [choiceSheet showInView:self.view];
    }
}


#pragma mark 申请认证动作
- (IBAction)applyAction
{
    
}

#pragma mark tableViewdelegate，datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

#pragma mark UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=actionSheet.cancelButtonIndex)
    {
        UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc]init];
        imagePickerVC.delegate = self;
        imagePickerVC.allowsEditing = YES;
        
        if (buttonIndex==0&&[UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]==YES)
        {
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else
        {
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }
}

#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];

    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.view makeProgress:@"上传中..."];
    if (_selectedType==SelectedTypeIdentity)
    {
        [YMWebServiceClient uploadIdentityWithImage:editImage Success:^(YMNomalResponse *response) {
            [self.view hiddenProgress];
            if(response.code==ERROR_OK){
                [_identityImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",REQUST_IMAGE_URL,response.data]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"update_logo"]];
               
                //储存用户信息
                YMCorpSummary *corpInfo = [ProjectUtil getCorpInfo];
                corpInfo.idnumberscale = response.data;
                [ProjectUtil saveLoginCorpInfo:corpInfo];
                [self.view makeToast:@"上传成功，身份证已提交审核"];
            }else{
                [self handleErrorWithErrorResponse:response];
            }
        }];
        
    }
    else if (_selectedType==SelectedTypeBusiness)
    {
        [YMWebServiceClient uploadBusinessWithImage:editImage Success:^(YMNomalResponse *response) {
            [self.view hiddenProgress];
            if(response.code==ERROR_OK){
                [_businessImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",REQUST_IMAGE_URL,response.data]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"update_logo"]];
                //储存用户信息
                YMCorpSummary *corpInfo = [ProjectUtil getCorpInfo];
                corpInfo.businumberscale = response.data;
                [ProjectUtil saveLoginCorpInfo:corpInfo];
                [self.view makeToast:@"上传成功，营业执照已提交审核"];
            }else{
                [self handleErrorWithErrorResponse:response];

            }
        }];
    }
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
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
