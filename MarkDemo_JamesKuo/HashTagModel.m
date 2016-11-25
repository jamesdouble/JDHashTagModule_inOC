//
//  HashTagModel.m
//  MarkDemo_JamesKuo
//
//  Created by waninuser on 2016/11/4.
//  Copyright © 2016年 waninuser. All rights reserved.
//

#import "HashTagModel.h"


@interface HashTagModel()

@end


@implementation HashTagModel
{
 NSMutableArray *_dictionaryresultTag;
 NSArray *_tagstart;
 NSArray *_tagend;
 UITextChecker *_textChecker;
}

- (instancetype)init
{
    NSLog(@"init");
    self = [super init];
    if (self) {
        _tagstart = [NSArray arrayWithObjects:@"*", nil];
        _tagend = [NSArray arrayWithObjects:@"!",@"@",@"%",@" ", nil];
        _textChecker = [[UITextChecker alloc] init];
        _dictionaryresultTag = [[NSMutableArray alloc] init];
    }
    return self;
}


-(void)analyzeText:(NSString*)input change:(NSString*)replacestr{
    [self analyzeTag:input change:replacestr];
 }
    
-(void)analyzeTag:(NSString*)input change:(NSString*)replacestr{
    NSString *_input_cp = input;
    NSUInteger _cusor = 0;
    NSUInteger _subStratIndex = 0;
    do{
        /*      找下一個標籤        */
        _cusor += _subStratIndex;
        _input_cp = [_input_cp substringFromIndex:_subStratIndex];
        if([_input_cp containsString:@" #"])
        {
            /*      找到＃        */
            NSRange _range = [_input_cp rangeOfString:@" #"];
            NSUInteger _indexofhash = _range.location;
            NSString *_tagstr = @"";
            Boolean _hasbeenend = false;
            NSUInteger _indexofend = 0;
            
            _tagstr = [_input_cp substringFromIndex:(_indexofhash+1)]; //去空白
            /*       找尋tag是否含有結尾        */
            NSUInteger _endcharIndex = 999;
            NSString *endchar = @"";
            
            for(int i=0;i<_tagend.count;i+=1)
            {
                if([_tagstr containsString:[_tagend objectAtIndex:i]])
                {
                    NSUInteger temp_index = [_tagstr rangeOfString:[_tagend objectAtIndex:i]].location;
                    /* 看哪個結尾符號在前 */
                    if(temp_index < _endcharIndex){
                        endchar = [_tagend objectAtIndex:i];
                        _endcharIndex = temp_index;
                    }  /* 此tag已結尾 */
                    _hasbeenend = true;
                }
                _indexofend = _endcharIndex;
            }
            
            [_dictionaryresultTag removeAllObjects];
       
            
            if (_hasbeenend) {
                /* 已結尾 */
                _tagstr = [_tagstr substringToIndex:_indexofend];
                if(![endchar  isEqual: @" "])
                {
                    _subStratIndex = _indexofhash + _indexofend + 2;
                }
                else{
                    _subStratIndex = _indexofhash + _indexofend + 1;
                }
            }
            else{
                /* 未結尾 */
                if(replacestr.length != 0)
                {
                    /*  有選擇Tag  */
                    NSRange replacerange = NSMakeRange(_cusor + _indexofhash+1,input.length - 1 - (_indexofhash + _cusor));
                    _replaced = [input stringByReplacingCharactersInRange:replacerange withString:replacestr];
                }
                else{
                    /* 系統推薦Tag */
                    [self searchTagDictionary:_tagstr];
                }
                return;
            }
        }
        else{
            /* Not Found # */
            break;
        }
    }while(1);
    /* 將完成的（需要標明）的Tag傳過去 */
    [self callDelegate];
}


-(void)callDelegate{
    /* 將完成的（需要標明）的Tag傳過去 */
    [_delegate hasfindHashTag];
}


-(void)searchTagDictionary:(NSString*)input{
    /*     搜尋字典     */
    NSString *_checkingString = [input substringFromIndex:1];
    NSArray *_checkingArray = [_textChecker completionsForPartialWordRange:NSMakeRange(0, _checkingString.length) inString:_checkingString language:@"en"];

    /*     插入＃      */
    for(int i =0;i<_checkingArray.count;i+=1)
    {
        NSMutableString *_str = [NSMutableString stringWithString:_checkingArray[i]];
        [_str insertString:@"#" atIndex:0];
        [_dictionaryresultTag addObject:_str];
    }
    [self callDelegate];
}


-(NSArray*)getResult{
    return _dictionaryresultTag;
}



@end
