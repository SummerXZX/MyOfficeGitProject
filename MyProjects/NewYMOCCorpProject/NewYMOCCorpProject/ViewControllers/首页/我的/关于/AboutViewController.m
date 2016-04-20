//
//  SettingViewController.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/5.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "AboutViewController.h"
#import "ModelWebViewController.h"

@interface AboutViewController ()

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;


@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewBasicProperty];
    [self layoutSubViews];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)layoutSubViews {
    _versionLabel.text = [NSString stringWithFormat:@"iPhone %@版",[ProjectUtil getCurrentAppVersion]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1)
    {
        [self jumpToAboutYMWithUrl:[NSString stringWithFormat:@"%@/about/corp_about.html",REQUEST_SERVER_URL]];
    }
    
    else if (indexPath.section==2)
    {
        //退出
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"您确定要退出一米商家版？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
        [alertView show];
    }
}



#pragma mark 跳转关于一米网页
-(void)jumpToAboutYMWithUrl:(NSString *)url
{
    ModelWebViewController *webVC = [[ModelWebViewController alloc]initWithURL:[NSURL URLWithString:url]];
    webVC.title = @"关于一米商家";
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        //退出操作
        [ProjectUtil removeLoginInfo];
        self.view.window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNaVC"];
        
    }
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
