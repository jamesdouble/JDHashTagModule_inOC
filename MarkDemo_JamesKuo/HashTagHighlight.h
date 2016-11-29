//
//  HashTagHighlight.h
//  MarkDemo_JamesKuo
//
//  Created by JamesDouble on 2016/11/7.
//  Copyright © 2016年 JamesDouble. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface HashTagHighlight : NSTextStorage

- (void)setString:(NSString*)change;
-(void)setNameColor:(UIColor*)color;
-(void)setTagColor:(UIColor*)color;
-(NSMutableArray*)gethashtagrange;

@end

