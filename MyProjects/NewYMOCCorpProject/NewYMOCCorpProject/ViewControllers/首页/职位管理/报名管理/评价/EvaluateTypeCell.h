//
//  EvaluateTypeCell.h
//  NewYMOCCorpProject
//
//  Created by test on 16/1/27.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface EvaluateTypeCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIButton *goodEvaluateBtn;///<好评

@property (weak, nonatomic) IBOutlet UIButton *middleEvaluateBtn;///<中评

@property (weak, nonatomic) IBOutlet UIButton *badEvaluateBtn;///<差评

@property (nonatomic,assign) EvaluateType evaluateType;///<评论类型


@end
