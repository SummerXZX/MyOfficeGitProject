//
//  CorpTextViewInputCell.h
//  NewYMOCCorpProject
//
//  Created by test on 16/1/22.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IQTextView.h>

@interface CorpTextViewInputCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;///<标题label

@property (weak, nonatomic) IBOutlet IQTextView *inputTextView;///<输入的textView

@end
