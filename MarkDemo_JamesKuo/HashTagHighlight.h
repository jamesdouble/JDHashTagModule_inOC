//
//  HashTagHighlight.h
//  MarkDemo_JamesKuo
//
//  Created by waninuser on 2016/11/7.
//  Copyright © 2016年 waninuser. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface HashTagHighlight : NSTextStorage

- (void)setString:(NSString*)change;
-(void)setNameColor:(UIColor*)color;
-(void)setTagColor:(UIColor*)color;

@end

