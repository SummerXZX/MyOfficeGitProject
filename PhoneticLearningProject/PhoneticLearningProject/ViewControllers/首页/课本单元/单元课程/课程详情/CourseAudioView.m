//
//  CourseAudioView.m
//  PhoneticLearningProject
//
//  Created by test on 15/11/17.
//  Copyright © 2015年 yimi. All rights reserved.
//

#import "CourseAudioView.h"
#import <AVFoundation/AVFoundation.h>
#import "CourseLRCView.h"

@interface CourseAudioView ()<AVAudioPlayerDelegate>

@property (nonatomic,strong) AVAudioPlayer *player;

@property (nonatomic,strong) UIImageView *playImageView;

@property (nonatomic,strong) UIButton *playBtn;

@property (nonatomic,strong) CourseLRCView *lrcView;

@property (nonatomic,strong) NSTimer *lrcTimer;

@end

@implementation CourseAudioView

-(UIImageView *)playImageView {
    if (!_playImageView) {
        _playImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (self.height-22)/2.0, 160, 22)];
        _playImageView.image = [UIImage imageNamed:@"yinpin_1"];
        _playImageView.animationImages = @[[UIImage imageNamed:@"yinpin_1"],[UIImage imageNamed:@"yinpin_2"],[UIImage imageNamed:@"yinpin_3"]];
        _playImageView.animationDuration = 0.8;
        
    }
    return _playImageView;
}

-(UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playBtn.frame = CGRectMake(self.width-30.0-10.0, (self.height-30.0)/2.0, 30.0, 30.0);
        [_playBtn setImage:[UIImage imageNamed:@"bofang"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"zanting"] forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}



-(instancetype)initWithFrame:(CGRect)frame URL:(NSURL *)url{
    self = [super initWithFrame:frame];
    if (self) {
        self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        self.player.delegate = self;
        self.player.volume = 0.6;
        UIImageView *hornImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"laba"]];
        hornImageView.frame = CGRectMake(10, (self.height-30.0)/2.0, 30.0, 30.0);
        [self addSubview:hornImageView];
        [self addSubview:self.playImageView];
        [self addSubview:self.playBtn];
        UIButton *stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        stopBtn.frame = CGRectMake(_playBtn.left-40.0, (self.height-30.0)/2.0, 30.0, 30.0);
        [stopBtn setImage:[UIImage imageNamed:@"jieshu"] forState:UIControlStateNormal];
        [stopBtn addTarget:self action:@selector(stopAudio) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:stopBtn];        
        self.playImageView.left = hornImageView.right+10.0+(stopBtn.left-10-hornImageView.right-10-160.0)/2.0;
        
    }
    self.backgroundColor = [UIColor whiteColor];
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame AudioURL:(NSURL *)audioURL LrcURL:(NSURL *)lrcURL {
    self = [[CourseAudioView alloc] initWithFrame:frame URL:audioURL];
    if (self) {
        self.lrcView = [[CourseLRCView alloc] initWithFrame:CGRectMake(_playImageView.left, self.height-30.0, _playImageView.width, 25.0) URL:lrcURL];
        self.lrcView.totalTime = self.player.duration;
        [self addSubview:self.lrcView];
    }
    return self;
}

#pragma mark 停止音频
-(void)stopAudio {
    _playBtn.selected = NO;
    [self.playImageView stopAnimating];
    [self.player stop];
    self.player.currentTime = 0.0;
    //判断有无歌词播放,并停止计时器
    if (_lrcView) {
        [_lrcView scrollWithTime:0.0];
        [_lrcTimer invalidate];
        _lrcTimer = nil;
    }
}

#pragma mark 暂停和播放音频
-(void)playAudio:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [_playImageView startAnimating];
        //判断有无歌词播放,并开启计时器
        if (_lrcView) {
            if (!_lrcTimer) {
                _lrcTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(lrcTimerAction) userInfo:nil repeats:YES];
            }
            else {
                self.lrcTimer.fireDate = [NSDate distantPast];
            }
        }
        if ([_player prepareToPlay]) {
            [_player play];
        }
        
    }
    else {
        [_playImageView stopAnimating];
        [_player pause];
        //判断有无歌词播放,并关闭计时器
        if (_lrcView) {
            self.lrcTimer.fireDate = [NSDate distantFuture];
        }
    }
}

#pragma mark 歌词计时器方法 
-(void)lrcTimerAction {
    [ProjectUtil showLog:@"currentTime:%f",_player.currentTime];
    [self.lrcView scrollWithTime:_player.currentTime];
}

#pragma mark AVAudioPlayerDelegate
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    _playBtn.selected = NO;
    [_playImageView stopAnimating];
    //判断有无歌词播放,并停止计时器
    if (_lrcView) {
         [_lrcView scrollWithTime:0.0];
        [_lrcTimer invalidate];
        _lrcTimer = nil;
    }

}

-(void)dealloc {
    [self.player stop];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
