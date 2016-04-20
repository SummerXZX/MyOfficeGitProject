//
//  CourseLRCView.m
//  PhoneticLearningProject
//
//  Created by test on 15/11/17.
//  Copyright © 2015年 yimi. All rights reserved.
//

#import "CourseLRCView.h"
#import "CourseLRCCell.h"

@interface CourseLRCView ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_lrcArr;
    NSTimer *_timer;
    NSTimeInterval _lastTime;
}

@property (nonatomic,strong) UITableView *tableView;

@end


@implementation CourseLRCView

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

-(instancetype)initWithFrame:(CGRect)frame URL:(NSURL *)url {
    self = [super initWithFrame:frame];
    if (self) {
        NSString *lrcStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        _lrcArr = [self getLrcArrWithLrcStr:lrcStr];
        [self addSubview:self.tableView];
        _lastTime = 0.0;
    }
    return self;
}

-(NSMutableArray*)getLrcArrWithLrcStr:(NSString*)lrcStr{
    NSMutableArray *rootList = [[NSMutableArray alloc]init];
    NSArray *array = [lrcStr componentsSeparatedByString:@"\n"];
    for (int i = 0; i < array.count; i++) {
        NSString *tempStr = [array objectAtIndex:i];
        NSArray *lineArray = [tempStr componentsSeparatedByString:@"]"];
        for (int j = 0; j < [lineArray count]-1; j ++) {
                if ([lineArray[j] length] >= 5) {
                NSMutableDictionary *rootDic = [[NSMutableDictionary alloc]init];
                NSString *str1 = [tempStr substringWithRange:NSMakeRange(3, 1)];
                if ([str1 isEqualToString:@":"]) {
                    NSString *lrcStr = [lineArray lastObject];
                    NSString *timeStr = [[lineArray objectAtIndex:j] substringWithRange:NSMakeRange(1, 5)];//分割区间求歌词时间
                    //把时间 和 歌词 加入词典
                    [rootDic setObject:lrcStr forKey:@"lrc"];
                    
                    NSArray *startTimeArr = [timeStr componentsSeparatedByString:@":"];
                    NSString *startTimeStr =  [NSString stringWithFormat:@"%f",[startTimeArr[0] doubleValue]*60+[startTimeArr[1] doubleValue]];
                    [rootDic setObject:startTimeStr forKey:@"lrcStartTime"];
                    [rootList addObject:rootDic];
                }
            }
        }
    }
    return rootList;
}

-(void)scrollWithTime:(NSTimeInterval)time {
    //取出歌词字典，查出属于哪个时间段
    int count = 0;
    if (time==0) {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    else {
        for (NSDictionary *lrcDic in _lrcArr) {
            //
            NSTimeInterval startTime = [lrcDic[@"lrcStartTime"]doubleValue];
            //判断是否最后一个数据
            NSTimeInterval endTime = 0.0;
            if (count==_lrcArr.count-1) {
                endTime = _totalTime;
            }
            else {
                NSDictionary *nextDic = _lrcArr[count+1];
                endTime = [nextDic[@"lrcStartTime"]doubleValue];
            }
            //判断是否在时间区间内
            NSString *lrcStr = lrcDic[@"lrc"];
            CGFloat totalLrcLength = [lrcStr boundingRectWithSize:CGSizeMake(2000, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT(13)} context:nil].size.width;
            NSIndexPath *path = [NSIndexPath indexPathForRow:count inSection:0];
            CourseLRCCell *cell = (CourseLRCCell *)[self.tableView cellForRowAtIndexPath:path];
            if (time>=startTime&&time<endTime) {
                //计算进度
                NSTimeInterval timeInterval = endTime-startTime;
                cell.readLrcWidthConstraint.constant = (totalLrcLength*(time-startTime))/timeInterval;
                [ProjectUtil showLog:@"startTime:%f,time:%f,endTime:%f",startTime,time,endTime];
            }
            else if (time>=endTime) {
                //属于这个时间段,翻滚到对应的位置
                if (count!=_lrcArr.count-1) {
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count+1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                }
                cell.readLrcWidthConstraint.constant = totalLrcLength+3.0;
            }
            count ++;
        }
    }
}

#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _lrcArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CourseLRCCell";
    CourseLRCCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[CourseLRCCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSDictionary *lrcDic = _lrcArr[indexPath.row];
    cell.lrc = lrcDic[@"lrc"];
    return cell;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
