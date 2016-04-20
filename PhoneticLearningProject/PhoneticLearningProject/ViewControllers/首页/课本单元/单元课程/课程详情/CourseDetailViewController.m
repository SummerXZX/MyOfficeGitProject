//
//  CourseDetailViewController.m
//  PhoneticLearningProject
//
//  Created by test on 15/11/15.
//  Copyright © 2015年 yimi. All rights reserved.
//

#import "CourseDetailViewController.h"
#import "BookDataBaseManager.h"
#import <GDataXMLNode.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CourseAudioView.h"

@interface CourseDetailViewController ()
{
    NSString *_videoPath;
    NSArray *_audiosArr;
}
@property (nonatomic,strong) UIScrollView *scrollView;
@end

@implementation CourseDetailViewController

#pragma mark scrollView
-(UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64.0)];
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

-(void)dealloc {
    _scrollView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
    
}

-(void)layoutSubViews {
    
    [self.view addSubview:self.scrollView];
     NSString *fileDirectories = [NSString stringWithFormat:@"%@/%@/%@/%@",[BookDataBaseManager getBookFilesPath],_bookname,_unitname,_coursename];
    NSData *xmlData = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/index.xml",fileDirectories]];
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithData:xmlData error:nil];
    GDataXMLElement *rootXml = [xmlDoc rootElement];
    CGFloat contentHeight = 0.0;
    [rootXml elementsForName:@"name"];
    for (GDataXMLElement *resourcesXml in rootXml.children) {
        
        //图片文件
        if ([resourcesXml.name isEqualToString:@"images"]) {
            for (GDataXMLElement *imageXml in resourcesXml.children) {
                UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",fileDirectories,[[imageXml elementsForName:@"remote_url"][0]stringValue]]];
                if (image) {
                    //往scrollView添加view
                    CGFloat imageViewHeight = SCREEN_WIDTH*(image.size.height/image.size.width);
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, contentHeight, SCREEN_WIDTH, imageViewHeight)];
                    imageView.image = image;
                    [self.scrollView addSubview:imageView];
                    contentHeight += imageViewHeight+1;
                }
            }
        }
        else if ([resourcesXml.name isEqualToString:@"audios"]) {
            for (GDataXMLElement *audioXml in resourcesXml.children) {
                NSString *audioPath = [NSString stringWithFormat:@"%@/%@",fileDirectories,[[audioXml elementsForName:@"remote_url"][0]stringValue]];
                CourseAudioView *audioView;
                if ([audioXml elementsForName:@"lrc"]) {
                    NSString *lrc = [[audioXml elementsForName:@"lrc"][0]stringValue];
                    if (lrc.length!=0) {
                        NSString *lrcPath = [NSString stringWithFormat:@"%@/%@",fileDirectories,[[audioXml elementsForName:@"lrc"][0]stringValue]];
                        audioView = [[CourseAudioView alloc]initWithFrame:CGRectMake(0, contentHeight, SCREEN_WIDTH, 80.0) AudioURL:[NSURL fileURLWithPath:audioPath] LrcURL:[NSURL fileURLWithPath:lrcPath]];
                    }
                    else {
                        audioView = [[CourseAudioView alloc]initWithFrame:CGRectMake(0, contentHeight, SCREEN_WIDTH, 80.0) URL:[NSURL fileURLWithPath:audioPath]];
                    }
                }
                else {
                  audioView = [[CourseAudioView alloc]initWithFrame:CGRectMake(0, contentHeight, SCREEN_WIDTH, 80.0) URL:[NSURL fileURLWithPath:audioPath]];
                  
                }
                [self.scrollView addSubview:audioView];
                contentHeight += audioView.height+1;
               
            }
            
        }
        else if ([resourcesXml.name isEqualToString:@"videos"]) {
            
            for (GDataXMLElement *videoxml in resourcesXml.children) {
                 NSString *videoPath = [NSString stringWithFormat:@"%@/%@",fileDirectories,[[videoxml elementsForName:@"remote_url"][0]stringValue]];
                _videoPath = videoPath;

                //添加悬浮按钮
                UIButton *hoverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                hoverBtn.frame = CGRectMake((SCREEN_WIDTH-47.0)/2.0, contentHeight>= SCREEN_HEIGHT-64.0?SCREEN_HEIGHT-64.0-47.0-20.0:contentHeight-47.0-20.0, 47.0, 47.0);
                [hoverBtn setImage:[UIImage imageNamed:@"dbbf"] forState:UIControlStateNormal];
                [hoverBtn addTarget:self action:@selector(playMovieAction) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:hoverBtn];
                
            }
           
        }
    }
    self.scrollView.contentSize = CGSizeMake(_scrollView.width, contentHeight);
    
}

#pragma mark 播放视频
-(void)playMovieAction {
    //播放
    MPMoviePlayerViewController *moviePlayVC = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL fileURLWithPath:_videoPath]];
    [self presentMoviePlayerViewControllerAnimated:moviePlayVC];
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
