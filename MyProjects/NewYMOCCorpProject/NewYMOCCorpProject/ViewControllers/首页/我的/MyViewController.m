//
//  MyViewController.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/4.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "MyViewController.h"
#import <UIImageView+WebCache.h>
#import "MyWalletViewController.h"
#import "AboutViewController.h"
#import "ApplyForAuthenticateViewController.h"
#import "CorpInfoViewController.h"
#import "MyTopInfoCell.h"
#import "FeedbackViewController.h"

@interface MyViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSArray *_dataArr;
    NSString *_balance;
}

@property (strong,nonatomic) UITableView *tableView;

@end

@implementation MyViewController

#pragma mark tableView
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [ProjectUtil getDefaultTableViewWithType:TableViewTypeNomal];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewBasicProperty];
    [self layoutSubViews];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    //查询余额
    [self checkBalance];
}

-(void)layoutSubViews {
    _dataArr = @[@[@{}],
                 @[@{@"image":@"wd_sjxx",@"title":@"商家信息"},
                   @{@"image":@"wd_qb",@"title":@"我的钱包"},
                   @{@"image":@"wd_xgmm",@"title":@"修改密码"}],
                 @[@{@"image":@"wd_yjfk",@"title":@"意见反馈"},
                   @{@"image":@"wd_kfdh",@"title":@"客服电话"}
                   ],
                 @[@{@"image":@"wd_gy",@"title":@"关于"}]
                 ];
    self.tableView.height = SCREEN_HEIGHT-64.0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
}

#pragma mark 查询余额
-(void)checkBalance
{
    [YMWebClient checkBalanceWithSuccess:^(YMNomalResponse *response) {
        if (response.code==ERROR_OK) {
           _balance = [NSString stringWithFormat:@"%.2f元",[response.data doubleValue]];
        }
        else {
            _balance = @"";
            [self handleErrorWithErrorResponse:response ShowHint:NO];
        }
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *rowArr = _dataArr[section];
    return rowArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return 90.0;
    }
    return 44.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
        static NSString *identifier = @"MyTopInfoCell";
        MyTopInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MyTopInfoCell" owner:nil options:nil]lastObject];
            cell.corpLogoImageView.userInteractionEnabled = YES;
            [cell.corpLogoImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateCorpLogo)]];
        }
        YMLoginInfo *loginInfo = [ProjectUtil getLoginInfo];
        cell.corpNameLabel.text = loginInfo.name.length==0?@"您还没有填写商家名称":loginInfo.name;
        [cell.corpLogoImageView sd_setImageWithURL:[NSURL URLWithString:[ProjectUtil getWholeImageUrlWithResponseUrl:loginInfo.logo]] placeholderImage:[UIImage imageNamed:@"wd_sjtb"]];
        return cell;
    }
    
    NSString *identifier = @"NomalCell";
    
    if (indexPath.section==1&&indexPath.row==1) {
        identifier = @"DetailCell";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        if (indexPath.section==1&&indexPath.row==1) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        else {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = FONT(15);
        cell.detailTextLabel.font = FONT(14);
    }
    if (indexPath.section==1&&indexPath.row==1) {
            if (_balance.length!=0) {
                cell.detailTextLabel.text = _balance;
            }
            else {
                cell.detailTextLabel.text = @"";
            }
            cell.detailTextLabel.textColor = DefaultOrangeColor;
    }
    NSDictionary *dataDic = _dataArr[indexPath.section][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:dataDic[@"image"]];
    cell.textLabel.text = dataDic[@"title"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *nextVC = nil;
    switch (indexPath.section) {
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CorpInfoViewController"];
                    nextVC.title = @"商家信息";
                    
                }
                    break;
                case 1:
                {
                    nextVC = [[MyWalletViewController alloc]init];
                }
                    break;
                case 2:
                {
                    nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePassViewController"];
                    nextVC.title = @"修改密码";
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedbackViewController"];
                    nextVC.title = @"意见反馈";
                }
                    break;
                case 1:
                {
                    [self callWithPhoneNum:CustomerServicePhone];
                    return;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 3:
        {
            nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutViewController"];
            nextVC.title = @"关于";
        }
            break;
            
        default:
            break;
    }
    if (nextVC) {
        [self.navigationController pushViewController:nextVC animated:YES];
    }
    
}

#pragma mark 上传用户头像
-(void)updateCorpLogo {
    UIActionSheet* choiceSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
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
    //上传头像
    [self.view showProgressHintWith:@"上传中"];
    [YMWebClient updateCorpLogoWithParams:@{@"photos":@[@{@"image":scaleImage,@"name":@"corplogo",@"fileName":@"logo.jpeg",@"mimeType":@"image/jpeg"}]} Success:^(YMNomalResponse *response) {
        [self.view dismissProgress];
        if (response.code==ERROR_OK) {
            [self.view showSuccessHintWith:@"上传成功"];
            YMLoginInfo *loginInfo = [ProjectUtil getLoginInfo];
            loginInfo.logo = response.data;
            [ProjectUtil saveLoginInfo:loginInfo];
            [self.tableView reloadData];
        }
        else {
            [self handleErrorWithErrorResponse:response ShowHint:YES];
        }
        
    }];
    
}

-(void)dealloc {
    [ProjectUtil showLog:NSStringFromClass([self class])];
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
