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
    NSLayoutManager *_layoutmanager;
    NSMutableArray *_name_arr;
    NSMutableArray<NSValue*> *_hashtagrange;
    NSMutableArray *_hashtag_arr;
    NSRange _asignrange;
    UIColor *_hashtagcolor;
    UIColor *_nametagcolor;
    BOOL _find_asign;
}


/******************
 
 
 NSTextStorage inheritance~
 
 
 ********************/

- (instancetype)init
{
    self = [super init];
    if (self) {
        _backingStore = [NSMutableAttributedString new];
        _name_arr = [[NSMutableArray alloc]init];
        _hashtagrange = [[NSMutableArray alloc] init];
        _hashtagcolor = [UIColor blackColor];
        _nametagcolor = [UIColor redColor];
        _find_asign = NO;
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

/******************
 
 
 color setting ~
 
 
 ********************/

-(void)setNameColor:(UIColor*)color{
    _nametagcolor = color;
    [self refreshHasgTagColor];
}

-(void)setTagColor:(UIColor*)color{
    _hashtagcolor = color;
    [self refreshHasgTagColor];
}

/******************
 
 
 Detect Module~
 
 
 ********************/

-(NSMutableArray*)gethashtagrange
{
    return _hashtagrange;
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
    [self removeAttribute:NSBackgroundColorAttributeName range:paragaphRange];

    }
    
     /*   HighLightTag    */
    [self highlightTag:paragaphRange];
    /*   HighLightUser    */
    [self highlightUser:paragaphRange];
}

     /*   HighLightTag    */
-(void)highlightTag:(NSRange)paragaphRange{
    
    [_hashtagrange removeAllObjects]; //清空
    
    static NSRegularExpression *expression;
    NSString *_highlightpattern = @"(\\s#)(\\S)*(\\s|!|%|@)";
    /* 其次遍历所有的样式匹配项并高亮它们： */
    expression = [NSRegularExpression regularExpressionWithPattern:_highlightpattern options:0 error:NULL];
    [expression enumerateMatchesInString:self.string options:0 range:paragaphRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        [_hashtagrange addObject:[NSValue valueWithRange:result.range]];

        NSRange _HashRange = NSMakeRange(result.range.location+1, result.range.length-1);
        [self addAttribute:NSForegroundColorAttributeName value:_hashtagcolor range:_HashRange];
        
    }];
}


/*   HighLightUser    */
-(void)highlightUser:(NSRange)paragaphRange{
    _asignrange = NSMakeRange(0, 0);
    _find_asign = NO;
    
    static NSRegularExpression *expression;
    NSString *_highlightnamePattern = @"(\\s@)(\\S)*(\\s)";
    expression = [NSRegularExpression regularExpressionWithPattern:_highlightnamePattern options:0 error:NULL];
    
    NSArray *matches = [expression matchesInString:self.string options:0 range:paragaphRange];
    for (NSTextCheckingResult *match in matches) {
        NSRange name_range = NSMakeRange(match.range.location+2, match.range.length -3);
        NSString* _highlighted = [[self string] substringWithRange:name_range];
        if(![_name_arr containsObject:_highlighted])
        {
        [_name_arr addObject:_highlighted];
        }

        _asignrange = NSMakeRange(match.range.location+1,1);
        _find_asign = YES;
    }
    
    if(_find_asign)
    {
        _find_asign = NO;
        [self setString:[[self string] stringByReplacingCharactersInRange:_asignrange withString:@" "]];
    }

    NSString* _namepattern = @"";
    for (_namepattern in _name_arr)
    {
        expression = [NSRegularExpression regularExpressionWithPattern:_namepattern options:0 error:NULL];
        [expression enumerateMatchesInString:self.string options:0 range:paragaphRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            UIColor *a_color = [_nametagcolor colorWithAlphaComponent:0.7];
            [self addAttribute:NSBackgroundColorAttributeName value:a_color range:result.range];
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

-(void)endEditing{
    [super endEditing];
    
}



@end
