//
//  UserInfoViewController.m
//  MyCloud
//
//  Created by test on 15/7/26.
//  Copyright (c) 2015年 xinyue. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoTopCell.h"
#import <UIImageView+WebCache.h>
#import "UIView+Hint.h"
#import "CallRecordDBManager.h"

@interface UserInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    LoginUserInfo *_userInfo;
}

@property (nonatomic,strong)UITableView *tableView;

@end

@implementation UserInfoViewController

#pragma mark tableView
-(UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0.0, SCREEN_WIDTH, SCREEN_HEIGHT-64.0) style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.backgroundColor = DefaultBackGroundColor;
        _tableView.separatorColor = DefaultBackGroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])
        {
            _tableView.layoutMargins = UIEdgeInsetsZero;
        }
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            _tableView.separatorInset = UIEdgeInsetsZero;
        }
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewBasicProperty];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self layoutSubViews];
    
}

-(void)layoutSubViews
{
    [self.view addSubview:self.tableView];
    //获取用户详情数据
    [self getUserDetailData];

}

#pragma mark 获取用户详情数据
-(void)getUserDetailData
{
    [_tableView showLoadingImageWithStatus:LoadingStatusOnLoading StatusStr:@"正在加载信息..."];
    [WebClient getContactDetailWithParams:@{@"userCode":_userCode} Success:^(WebLoginResponse *response) {
        [_tableView hiddenLoadingView];
        if (response.code==ResponseCodeSuceess) {
            _userInfo = response.data;
            UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60.0)];
            UIButton *loginOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            loginOutBtn.backgroundColor = RGBCOLOR(242, 30, 30);
            [loginOutBtn setTitle:@"退出" forState:UIControlStateNormal];
            [loginOutBtn addTarget:self action:@selector(loginOutBtnAction) forControlEvents:UIControlEventTouchUpInside];
            loginOutBtn.frame = CGRectMake(15.0, 10.0, footView.width-30.0, 40.0);
            loginOutBtn.layer.masksToBounds = YES;
            loginOutBtn.layer.cornerRadius = 5.0;
            [footView addSubview:loginOutBtn];
            _tableView.tableFooterView = footView;
            [_tableView reloadData];
        }
        else {
            _tableView.tableFooterView = nil;
            [_tableView showLoadingImageWithStatus:LoadingStatusNetError StatusStr:response.codeInfo];
        }
    }];
}

#pragma mark 退出登录
- (void)loginOutBtnAction {
    [ProjectUtil removeLoginUserInfo];
    self.view.window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNaVC"];
}

#pragma mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!_userInfo) {
        return 0;
    }
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_userInfo.backupsUserPhone.length!=0&&section==1) {
        return 2;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return 120.0;
    }
    return 44.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section<=1)
    {
        return 5.0;
    }
    return 30.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    view.backgroundColor = DefaultBackGroundColor;
    
    if (section>1)
    {
        UILabel *titleLabel= [[UILabel alloc]initWithFrame:CGRectMake(15, 0, view.width-15, 30)];
        titleLabel.backgroundColor = DefaultBackGroundColor;
        titleLabel.text = [self getSectionTitle:section];
        titleLabel.font = [UIFont boldSystemFontOfSize:15];
        titleLabel.textColor = [UIColor blackColor];
        [view addSubview:titleLabel];

    }
 
    return view;
}

#pragma mark 获取标题
- (NSString *)getSectionTitle:(NSInteger)section {
    switch (section) {
        case 0:
            return @"";
            break;
        case 1:
            return @"";
            break;
        case 2:
            return @"办公电话";
            break;
        case 3:
            return @"办公短号";
            break;
        case 4:
            return @"政务通短号";
            break;

        default:
            return @"";
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (indexPath.section==0)
    {
        static NSString *identifier = @"UserInfoTopCell";
        UserInfoTopCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"UserInfoTopCell" owner:nil options:nil]lastObject];
        }
        cell.nameLabel.text =_userInfo.userName;
        cell.positionLabel.text = _userInfo.postName;
        
        [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",REQUEST_IMG_URL,_userInfo.userIcon]] placeholderImage:[UIImage imageNamed:@"touxiang"]];
        
        if (_isUserCenter)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    else
    {
        static NSString *identifier = @"OtherCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        if (indexPath.section==1) {
            cell.imageView.image = [UIImage imageNamed:@"phone"];
        }
        else {
            cell.imageView.image = [UIImage imageNamed:@"call"];
        }
        
        cell.textLabel.font = FONT(15);
        cell.textLabel.textColor = DefaultGrayTextColor;
        NSString *infoStr = [self getSectionInfoStr:indexPath];
        if (infoStr.length==0)
        {
            cell.textLabel.text = @"无";
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = infoStr;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        return cell;
    }
}

- (NSString *)getSectionInfoStr:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return @"";
            break;
        case 1:
        {
            if (indexPath.row==0) {
                return _userInfo.userPhone;
            }
            else {
                return _userInfo.backupsUserPhone;
            }
        
        }
            break;
        case 2:
            return _userInfo.officeCall;
            break;
        case 3:
            return _userInfo.workCall;
            break;
        case 4:
            return _userInfo.gaCall;
            break;
            
        default:
            return @"";
            break;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.section==0&&_isUserCenter==YES)
//    {
//        UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
//                                                                 delegate:self
//                                                        cancelButtonTitle:@"取消"
//                                                   destructiveButtonTitle:nil
//                                                        otherButtonTitles:@"拍照", @"从相册中选取", nil];
//        if (self.navigationController.tabBarController.tabBar != nil) {
//            [choiceSheet showFromTabBar:self.navigationController.tabBarController.tabBar];
//            
//        } else {
//            [choiceSheet showInView:self.view];
//        }
//    }
//    else
    
    if(indexPath.section>=1)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (!_isUserCenter)
        {
            //给通话记录表里面添加数据
            [CallRecordDBManager updateCallRecordWith:_userInfo];
        }
        [self callWithPhoneNum:cell.textLabel.text];
    }
}

\
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
//    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
//    WebClient *webClient = [WebClient shareClient];
//    [self.view makeProgress:@"上传中..."];
//    
//    NSData *data = UIImageJPEGRepresentation(editImage, 1.0f);
//    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//    
//    [webClient uploadUserAvatarWithParameters:@{@"UserId":_userId,@"FileType":@"png",@"buffer":encodedImageStr} Success:^(id data) {
//        [self.view hiddenProgress];
//        if ([data[@"code"]intValue]==0)
//        {
//            //获取登录信息
//            UserInfo *loginInfo = [ProjectUtil getCustomObjFromUserDefaultsWithKey:@"login"];
//            loginInfo.userface = data[@"result"];
//            _userInfo = loginInfo;
//            [ProjectUtil storeCustomObj:loginInfo ToUserDefaultsWithKey:@"login"];
//            [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
//            [self.view makeToast:@"上传成功"];
//        }
//    } Fail:^(NSError *error) {
//        [self.view hiddenProgress];
//        [self.view makeToast:HintWithNetError];
//    }];
    
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
