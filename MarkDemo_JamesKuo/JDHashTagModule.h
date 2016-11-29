//
//  JDHashTagModule.h
//  MarkDemo_JamesKuo
//
//  Created by waninuser on 2016/11/15.
//  Copyright © 2016年 waninuser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HashTagModel.h"
#import "HashTagTableViewCell.h"
#import "HashTagHighlight.h"

@protocol JDHashTagModuleDelegate <NSObject>

@optional -(void)hastapHashTag:(NSString*)tag;

@end

@interface JDHashTagModule:NSObject<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,HashTagModelDelegate,UIGestureRecognizerDelegate>

@property id<JDHashTagModuleDelegate> delegate;
-(instancetype)initWithTable_Text:(UITableView *)table txt:(UITextView *)textview;
-(void)setHashTagColor:(UIColor *)color;
-(void)setNameTagColor:(UIColor *)color;

@end
