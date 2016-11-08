//
//  ViewController.h
//  MarkDemo_JamesKuo
//
//  Created by waninuser on 2016/11/4.
//  Copyright © 2016年 waninuser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HashTagModel.h"
#import "HashTagTableViewCell.h"
#import "HashTagHighlight.h"


@interface ViewController : UIViewController<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,HashTagModelDelegate>


@end

