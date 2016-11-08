//
//  HashTagHighlight.h
//  MarkDemo_JamesKuo
//
//  Created by waninuser on 2016/11/7.
//  Copyright © 2016年 waninuser. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface HashTagHighlight : NSTextStorage

- (void)setHighlightPattern:(NSArray *)input;
- (void)setString:(NSString*)change;

@end

