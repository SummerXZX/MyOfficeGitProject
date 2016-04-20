//
//  UserInfoViewController.m
//  MyCloud
//
//  Created by test on 15/7/26.
//  Copyright (c) 2015年 xinyue. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoTopCell.h"
#import "UserInfo.h"
#import <UIImageView+WebCache.h>
#import "UIView+Hint.h"
#import "CallRecordDBManager.h"

@interface UserInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSArray *_sectionTitleArr;
    NSArray *_userInfoArr;
    UserInfo *_userInfo;
    
}

@property (nonatomic,strong)UITableView *tableView;

@end

@implementation UserInfoViewController

#pragma mark tableView
-(UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64.0) style:UITableViewStylePlain];
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
    [self layoutSubViews];
    
}

-(void)layoutSubViews
{
    _sectionTitleArr = @[@"手机短号",@"办公电话",@"办公短号"];
    [self.view addSubview:self.tableView];
    //获取用户详情数据
    [self getUserDetailData];

}

#pragma mark 获取用户详情数据
-(void)getUserDetailData
{
    WebClient *webClient = [WebClient shareClient];
    [_tableView showLoadingImageWithStatus:LoadingStatusOnLoading StatusStr:@"正在加载信息..."];
    [webClient getUserDetailWithParameters:@{@"UserId":_userId} Success:^(id data) {
        [_tableView hiddenLoadingView];
        if ([data[@"code"]intValue]==0)
        {
            NSDictionary *dataDic = data[@"result"][0];
            UserInfo *loginInfo = [[UserInfo alloc]initWithDic:dataDic];
            if (_isUserCenter)
            {
                //储存用户信息
                [ProjectUtil storeCustomObj:loginInfo ToUserDefaultsWithKey:@"login"];
            }
            _userInfo = loginInfo;
            NSMutableArray *tempArr = [NSMutableArray arrayWithObjects:@[@""],@[@{@"name":loginInfo.phone,@"logo":@"phone"}],@[@{@"name":loginInfo.zwtnum,@"logo":@"call"}],@[@{@"name":loginInfo.officeTel,@"logo":@"call"}],@[@{@"name":loginInfo.officeMob,@"logo":@"call"}], nil];
            if (loginInfo.mobile.length!=0)
            {
                NSMutableArray *mobileArr = [NSMutableArray arrayWithArray:tempArr[1]];
                [mobileArr addObject:@{@"name":loginInfo.mobile,@"logo":@"phone"}];
                [tempArr replaceObjectAtIndex:1 withObject:[NSArray arrayWithArray:mobileArr]];
            }
            if (loginInfo.zwtnum2.length!=0)
            {
                NSMutableArray *zwtArr = [NSMutableArray arrayWithArray:tempArr[2]];
                [zwtArr addObject:@{@"name":loginInfo.zwtnum,@"logo":@"call"}];
                [tempArr replaceObjectAtIndex:2 withObject:[NSArray arrayWithArray:zwtArr]];
            }
            _userInfoArr = [NSArray arrayWithArray:tempArr];
            [_tableView reloadData];
        }
        else
        {
             [self.view makeToast:data[@"message"]];
        }
        
    } Fail:^(NSError *error)
     {
         [self.view showLoadingImageWithStatus:LoadingStatusNetError StatusStr:HintWithNetError];
     }];
}


#pragma mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _userInfoArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *itemArr = _userInfoArr[section];
    return itemArr.count;
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
        titleLabel.text = _sectionTitleArr[section-2];
        titleLabel.font = [UIFont boldSystemFontOfSize:15];
        titleLabel.textColor = [UIColor blackColor];
        [view addSubview:titleLabel];

    }
 
    return view;
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
        cell.nameLabel.text =_userInfo.truename;
        cell.positionLabel.text = _userInfo.uLevID.length==0?@"没担任职位":_userInfo.uLevID;
        
        [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:_userInfo.userface] placeholderImage:[UIImage imageNamed:@"touxiang"]];
        
        
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
         NSDictionary *dataDic = _userInfoArr[indexPath.section][indexPath.row];
        static NSString *identifier = @"OtherCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.imageView.image = [UIImage imageNamed:dataDic[@"logo"]];
        NSString *nameStr = dataDic[@"name"];
        
        cell.textLabel.font = Default_Font_15;
        cell.textLabel.textColor = DefaultGrayTextColor;
        if (nameStr.length==0)
        {
            cell.textLabel.text = @"无";
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = nameStr;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0&&_isUserCenter==YES)
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
    else if(indexPath.section>=1)
    {
        
        NSDictionary *dataDic = _userInfoArr[indexPath.section][indexPath.row];
        NSString *nameStr = dataDic[@"name"];
        if (nameStr.length!=0)
        {
            if (!_isUserCenter)
            {
                //给通话记录表里面添加数据
                [CallRecordDBManager updateCallRecordWith:@{@"calluserid":[NSNumber numberWithInt:[_userInfo.uid intValue]],@"callnum":[self getUserPhone],@"callname":_userInfo.truename,@"callavatar":_userInfo.userface,@"calltime":[ProjectUtil getTimeSpWithDate:[NSDate date]]}];
            }
            [self callWithPhoneNum:nameStr];
            
            
        }
       
    }
}

#pragma mark 获取用户电话信息
-(NSString *)getUserPhone
{
    NSString *phoneStr = @"";
    if (_userInfo.phone.length!=0)
    {
        phoneStr = [phoneStr stringByAppendingString:_userInfo.phone];
    }
    if (_userInfo.mobile.length!=0)
    {
        phoneStr = [phoneStr stringByAppendingFormat:@" %@",_userInfo.mobile];
    }
    if (_userInfo.zwtnum.length!=0)
    {
        phoneStr = [phoneStr stringByAppendingFormat:@" %@",_userInfo.zwtnum];
    }
    if (_userInfo.zwtnum2.length!=0)
    {
        phoneStr = [phoneStr stringByAppendingFormat:@" %@",_userInfo.zwtnum2];
    }
    if (_userInfo.officeTel.length!=0)
    {
        phoneStr = [phoneStr stringByAppendingFormat:@" %@",_userInfo.officeTel];
    }
    if (_userInfo.officeMob.length!=0)
    {
        phoneStr = [phoneStr stringByAppendingFormat:@" %@",_userInfo.officeMob];
    }
    return phoneStr;
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
    WebClient *webClient = [WebClient shareClient];
    [self.view makeProgress:@"上传中..."];
    
    NSData *data = UIImageJPEGRepresentation(editImage, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    [webClient uploadUserAvatarWithParameters:@{@"UserId":_userId,@"FileType":@"png",@"buffer":encodedImageStr} Success:^(id data) {
        [self.view hiddenProgress];
        if ([data[@"code"]intValue]==0)
        {
            //获取登录信息
            UserInfo *loginInfo = [ProjectUtil getCustomObjFromUserDefaultsWithKey:@"login"];
            loginInfo.userface = data[@"result"];
            _userInfo = loginInfo;
            [ProjectUtil storeCustomObj:loginInfo ToUserDefaultsWithKey:@"login"];
            [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.view makeToast:@"上传成功"];
        }
    } Fail:^(NSError *error) {
        [self.view hiddenProgress];
        [self.view makeToast:HintWithNetError];
    }];
    
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
