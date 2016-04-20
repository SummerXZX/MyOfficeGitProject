//
//  ContentCell.h
//  YMCorporationIOS
//
//  Created by test on 15/7/7.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentCell : UITableViewCell

/**Cell标题*/
@property (nonatomic,strong) NSString *title;

/**内容数组*/
@property (nonatomic,strong) NSArray *contentArr;

/**
 *获取cell高度
 */
+(CGFloat)getCellHeightIsHasTitile:(BOOL)hasTitle ContentRows:(NSInteger)contentRows;

@end
