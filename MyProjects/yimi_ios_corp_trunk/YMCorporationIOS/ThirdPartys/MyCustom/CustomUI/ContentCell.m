//
//  ContentCell.m
//  YMCorporationIOS
//
//  Created by test on 15/7/7.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "ContentCell.h"

static CGFloat ContentHorizontalSpace = 10.0;
static CGFloat ContentVerticalSpace = 10.0;
static CGFloat ContentLabelHeight = 20.0;
static NSInteger ContentLabelTag = 1000;
static NSInteger TitleLabelTag = 2000;

@implementation ContentCell

- (void)awakeFromNib {
    // Initialization code
}



-(void)setTitle:(NSString *)title
{
    _title = title;
    UILabel *titleLabel = (UILabel *)[self.contentView viewWithTag:TitleLabelTag];
    if (titleLabel==nil)
    {
        CGFloat labelWidth = SCREEN_WIDTH-ContentHorizontalSpace*2;
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(ContentHorizontalSpace, ContentVerticalSpace, labelWidth, ContentLabelHeight)];
        titleLabel.font = Default_Font_14;
        titleLabel.tag = TitleLabelTag;
        titleLabel.textColor = DefaultGrayTextColor;
        [self.contentView addSubview:titleLabel];
    }
     titleLabel.text = title;
}

-(void)setContentArr:(NSArray *)contentArr
{
    if (_contentArr.count!=0)
    {
        for (int i=0; i<_contentArr.count; i++)
        {
            UILabel *contentLabel = (UILabel *)[self.contentView viewWithTag:ContentLabelTag+i];
            contentLabel.hidden = YES;
        }
    }
    _contentArr = contentArr;
    CGFloat labelWidth = SCREEN_WIDTH-ContentHorizontalSpace*2;
    CGFloat contentHeight = 0.0;
    if (_title)
    {
        contentHeight += 20.0;
    }
    for (int i=0; i<contentArr.count; i++)
    {
        UILabel *contentLabel = (UILabel *)[self.contentView viewWithTag:ContentLabelTag+i];
        if (contentLabel==nil)
        {
            contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(ContentHorizontalSpace, ContentVerticalSpace+contentHeight, labelWidth, ContentLabelHeight)];
            contentLabel.font = Default_Font_13;
            contentLabel.textColor = DefaultGrayTextColor;
            contentLabel.tag = ContentLabelTag+i;
            [self.contentView addSubview:contentLabel];
        }
        if ([contentArr[i] isKindOfClass:[NSString class]])
        {
            contentLabel.text = contentArr[i];
        }
        else if ([contentArr[i] isKindOfClass:[NSMutableAttributedString class]])
        {
            contentLabel.attributedText = contentArr[i];
        }
        contentLabel.hidden = NO;
        contentHeight += ContentLabelHeight;
    }
}

+(CGFloat)getCellHeightIsHasTitile:(BOOL)hasTitle ContentRows:(NSInteger)contentRows
{
    CGFloat cellHeight = 0.0;
    if (hasTitle)
    {
        cellHeight += ContentLabelHeight;
    }
    return cellHeight+contentRows*ContentLabelHeight+ContentVerticalSpace*2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
