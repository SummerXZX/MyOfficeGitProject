//
//  VocabularyViewController.m
//  PhoneticLearningProject
//
//  Created by test on 15/12/23.
//  Copyright © 2015年 yimi. All rights reserved.
//

#import "VocabularyViewController.h"
#import <GDataXMLNode.h>
#import <MediaPlayer/MediaPlayer.h>
#import "BookDataBaseManager.h"
#import "CourseAudioView.h"

@interface VocabularyViewController ()<UIScrollViewDelegate>
{
    int _totalCount;
    int _currentPage;
}
@property (nonatomic,strong) UIButton *firstPageBtn;//首页按钮
@property (nonatomic,strong) UIButton *backBtn;//上一页
@property (nonatomic,strong) UIButton *nextBtn;//下一页
@property (nonatomic,strong) UIButton *lastPageBtn;//末页
@property (nonatomic,strong) UILabel *pageLabel;//页数label
@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation VocabularyViewController

#pragma mark scrollView
-(UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64.0-49.0)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.delegate = self;
    }
    return _scrollView;
}

#pragma mark pageLabel
-(UILabel *)pageLabel {
    if (!_pageLabel) {
        _pageLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-80)/2.0, SCREEN_HEIGHT-64.0-49.0, 80, 49.0)];
        _pageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _pageLabel;
}

#pragma mark backBtn
-(UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [self creatBottomBtnWithTitle:@"上一页"];
        _backBtn.left = _pageLabel.left-_backBtn.width;
        _backBtn.hidden = YES;
        _backBtn.tag = 101;
    }
    return _backBtn;
}

#pragma mark nextBtn
-(UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [self creatBottomBtnWithTitle:@"下一页"];
        _nextBtn.left = _pageLabel.right;
        _nextBtn.tag = 102;
    }
    return _nextBtn;
}

#pragma mark firstPageBtn
-(UIButton *)firstPageBtn {
    if (!_firstPageBtn) {
        _firstPageBtn = [self creatBottomBtnWithTitle:@"首页"];
        _firstPageBtn.hidden = YES;
        _firstPageBtn.tag = 100;
    }
    return _firstPageBtn;
}

#pragma mark lastPageBtn
-(UIButton *)lastPageBtn {
    if (!_lastPageBtn) {
        _lastPageBtn = [self creatBottomBtnWithTitle:@"末页"];
        _lastPageBtn.left = _nextBtn.right;
        _lastPageBtn.tag = 103;
    }
    return _lastPageBtn;
}



-(UIButton *)creatBottomBtnWithTitle:(NSString *)title {
    
    CGFloat btnWidth = (SCREEN_WIDTH-_pageLabel.width)/4.0;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, _pageLabel.top, btnWidth, _pageLabel.height);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:DefaultGrayTextColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(bottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = FONT(14);
    return btn;
}

#pragma mark 底部按钮动作
-(void)bottomBtnAction:(UIButton *)sender {
    switch (sender.tag) {
        case 100:
        {
            //首页
            _currentPage = 1;
            [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            [self showBottomBtn];
            
        }
            break;
            
        case 101:
        {
            //上一页
            _currentPage --;
            [_scrollView setContentOffset:CGPointMake((_currentPage-1)*SCREEN_WIDTH, 0) animated:YES];
            [self showBottomBtn];
            
        }
            break;
        case 102:
        {
            //下一页
            _currentPage ++;
            [_scrollView setContentOffset:CGPointMake((_currentPage-1)*SCREEN_WIDTH,0) animated:YES];
            [self showBottomBtn];
            
        }
            break;
        case 103:
        {
            //末页
            _currentPage = _totalCount;
            [_scrollView setContentOffset:CGPointMake((_currentPage-1)*SCREEN_WIDTH, 0) animated:YES];
            [self showBottomBtn];
            
        }
            break;
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
}

-(void)layoutSubViews {
    _totalCount = 0;
    [self.view addSubview:self.scrollView];
    NSString *fileDirectories = [NSString stringWithFormat:@"%@/%@/%@/%@",[BookDataBaseManager getBookFilesPath],_bookname,_unitname,_coursename];
    NSData *xmlData = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/index.xml",fileDirectories]];
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithData:xmlData error:nil];
    GDataXMLElement *rootXml = [xmlDoc rootElement];
    for (GDataXMLElement *resourcesXml in rootXml.children) {
          if ([resourcesXml.name isEqualToString:@"audios"]) {
              for (GDataXMLElement *audioXml in resourcesXml.children) {
                  //显示文本
                  NSString *showText = @"";
                  NSString *name = [[audioXml elementsForName:@"name"][0]stringValue];
                  if (name.length!=0) {
                      showText  = [showText stringByAppendingFormat:@"%@\n",name];
                  }
                  NSString *chs = [[audioXml elementsForName:@"chs"][0]stringValue];
                  if (chs.length!=0) {
                      showText = [showText stringByAppendingFormat:@"%@\n",chs];
                  }
                  NSString *eng_spelling = [[audioXml elementsForName:@"eng_spelling"][0]stringValue];
                  if (eng_spelling.length!=0) {
                      showText = [showText stringByAppendingFormat:@"%@\n",eng_spelling];
                  }
                  NSString *chs_spelling = [[audioXml elementsForName:@"chs_spelling"][0]stringValue];
                  if (chs_spelling.length!=0) {
                      showText = [showText stringByAppendingFormat:@"%@\n",chs_spelling];
                  }
                  
                  
                  CGFloat textHeight = [showText getSizeWithFont:FONT(14) Width:SCREEN_WIDTH].height;
                  
                   NSString *audioPath = [NSString stringWithFormat:@"%@/%@",fileDirectories,[[audioXml elementsForName:@"remote_url"][0]stringValue]];
                  CourseAudioView *audioView =  [[CourseAudioView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*_totalCount, (_scrollView.height-textHeight+10.0-80.0)/2.0, SCREEN_WIDTH, 80.0) URL:[NSURL fileURLWithPath:audioPath]];
                  [self.scrollView addSubview:audioView];
                  
                  UILabel *showLabel = [[UILabel alloc]initWithFrame:CGRectMake(_totalCount*SCREEN_WIDTH, audioView.bottom+10.0, SCREEN_WIDTH-20.0, textHeight)];
                  showLabel.font = FONT(14);
                  showLabel.text = showText;
                  showLabel.numberOfLines = 0;
                  showLabel.textAlignment = NSTextAlignmentCenter;
                  [self.scrollView addSubview:showLabel];

                  _totalCount ++;
              }
          }
    }
    self.scrollView.contentSize = CGSizeMake(_totalCount*SCREEN_WIDTH, _scrollView.height);
    
    //创建底部按钮
    [self.view addSubview:self.pageLabel];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.nextBtn];
    [self.view addSubview:self.firstPageBtn];
    [self.view addSubview:self.lastPageBtn];
    _currentPage = 1;
    _pageLabel.attributedText = [self getPageAttStr];
}

#pragma mark 获取页数att字符串
-(NSAttributedString *)getPageAttStr {
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%d",_currentPage] attributes:@{NSFontAttributeName:FONT(13),NSForegroundColorAttributeName:NavigationBarColor}];
    [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"/%d",_totalCount] attributes:@{NSFontAttributeName:FONT(13),NSForegroundColorAttributeName:DefaultGrayTextColor}]];
    return attStr;
}

#pragma mark UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int jumpPage = (int)scrollView.contentOffset.x/SCREEN_WIDTH+1;
    if (jumpPage!=_currentPage) {
        _currentPage = jumpPage;
        [self showBottomBtn];
    }
   
}

#pragma mark 展示底部按钮
-(void)showBottomBtn {
    if (_currentPage==1) {
        _firstPageBtn.hidden = YES;
        _backBtn.hidden = YES;
        _nextBtn.hidden = NO;
        _lastPageBtn.hidden = NO;
    }
    else if (_currentPage==_totalCount) {
        _nextBtn.hidden = YES;
        _lastPageBtn.hidden = YES;
        _firstPageBtn.hidden = NO;
        _backBtn.hidden = NO;
    }
    else {
        _firstPageBtn.hidden = NO;
        _backBtn.hidden = NO;
        _nextBtn.hidden = NO;
        _lastPageBtn.hidden = NO;
    }
    _pageLabel.attributedText = [self getPageAttStr];
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
