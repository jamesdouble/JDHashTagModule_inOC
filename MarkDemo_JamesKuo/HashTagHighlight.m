//
//  HashTagHighlight.m
//  MarkDemo_JamesKuo
//
//  Created by waninuser on 2016/11/7.
//  Copyright © 2016年 waninuser. All rights reserved.
//

#import "HashTagHighlight.h"

@implementation HashTagHighlight
{
    NSMutableAttributedString *_backingStore;
    NSArray *_highlightpattern_arr;
    NSLayoutManager *_layoutmanager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _backingStore = [NSMutableAttributedString new];
        _highlightpattern_arr =  [NSMutableArray arrayWithObjects:@"#", nil];
    }
    return self;
}
//1
- (NSString *)string {
    return [_backingStore string];
}

//1-1
- (void)setString:(NSString*)change{
    NSRange r = NSMakeRange(0, self.string.length);
    [self replaceCharactersInRange:r withString:change];
}


//2
- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range
{
    return [_backingStore attributesAtIndex:location
                             effectiveRange:range];
}
//3
- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
    [self beginEditing];
    [_backingStore replaceCharactersInRange:range withString:str];
    [self edited:NSTextStorageEditedCharacters | NSTextStorageEditedAttributes range:range changeInLength:str.length - range.length];
    [self endEditing];
}
//4
- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range {
    [self beginEditing];
    [_backingStore setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
    [self endEditing];
}




//指定highlight pattern
- (void)setHighlightPattern:(NSArray *)input{
    _highlightpattern_arr = input;
    [self refreshHasgTagColor];
}

//把Tag標示出來
-(void)refreshHasgTagColor{
    /* 首先清除之前所有的高亮： */
    NSRange paragaphRange = NSMakeRange(0, self.string.length-1);
    if(self.editedRange.location != NSNotFound)
    {
     paragaphRange = [self.string paragraphRangeForRange: self.editedRange];
    [self removeAttribute:NSForegroundColorAttributeName range:paragaphRange];
    [self removeAttribute:NSUnderlineStyleAttributeName range:paragaphRange];
    }
    
    static NSRegularExpression *expression;
    NSString *_highlightpattern = @"";
    
    /* 其次遍历所有的样式匹配项并高亮它们： */
    for (_highlightpattern in _highlightpattern_arr)
    {
        expression = [NSRegularExpression regularExpressionWithPattern:_highlightpattern options:0 error:NULL];
        
        [expression enumerateMatchesInString:self.string options:0 range:paragaphRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            [self addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:result.range];
            [self addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range:result.range];
            
        }];
        
    }
}



/* 
 This method is automatically invoked in response to an edited(_:range:changeInLength:) message or an endEditing() message if edits were made within the scope of a beginEditing() block. You should never need to invoke it directly.
 
 */

- (void)processEditing
{
    [super processEditing];
    [self refreshHasgTagColor];
}



@end
