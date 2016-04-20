//
//  UserInfoTableViewController.m
//  YMCorporationIOS
//
//  Created by test on 15/7/3.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "UserInfoTableViewController.h"
#import "ChangePassViewController.h"
#import "ChangeLoginNameViewController.h"
#import "UIImageView+WebCache.h"


@interface UserInfoTableViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *loginNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *corpLogoImageView;

@end

@implementation UserInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
}

-(void)viewWillAppear:(BOOL)animated
{
    YMCorpSummary *corpInfo = [ProjectUtil getCorpInfo];
    _loginNameLabel.text = corpInfo.loginName;
    [_corpLogoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",REQUST_IMAGE_URL,corpInfo.logoscale]] placeholderImage:[UIImage imageNamed:@"my_mrtx"]];
}

-(void)layoutSubViews
{
   
}

#pragma mark tableViewDelegate
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    headerView.contentView.backgroundColor = DefaultBackGroundColor;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0)
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
    [YMWebServiceClient updateCorpLogoWithImage:editImage Success:^(YMNomalResponse *response) {
        [self.view hiddenProgress];
        if(response.code==ERROR_OK){
            [_corpLogoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",REQUST_IMAGE_URL,response.data]] placeholderImage:[UIImage imageNamed:@"my_mrtx"]];
            //储存用户信息
            YMCorpSummary *corpInfo = [ProjectUtil getCorpInfo];
            corpInfo.logoscale = response.data;
            [ProjectUtil saveLoginCorpInfo:corpInfo];
            [self.view makeToast:@"上传成功"];
        }else{
            [self handleErrorWithErrorResponse:response];
        }
    }];
    
    
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
