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
 NSMutableArray *_SearchTagresult;
 NSArray *_dictionaryTag;
 UITextView *_displayTextView;
 NSArray *_tagstart;
 NSArray *_tagend;
 //id<HashTagModelDelegate> delegate;
    
 
}

- (instancetype)init
{
    NSLog(@"init");
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(instancetype)initWithTextView:(UITextView *)textview
{
    self = [super init];
    if (self) {
        NSLog(@"HashTagModel initWithTableView");
        _displayTextView = textview;
        _dictionaryresultTag =  [NSMutableArray arrayWithObjects:@"", nil];
        _dictionaryTag =  [NSArray arrayWithObjects:@"#hello",@"#hi",@"#hey", nil];
        _SearchTagresult = [NSMutableArray arrayWithObjects:@"#", nil];
        _tagstart = [NSArray arrayWithObjects:@"*", nil];
        _tagend = [NSArray arrayWithObjects:@"!",@"@",@"%",@" ", nil];

    }
    return self;
}

-(void)analyzeText:(NSString*)input change:(NSString*)replacestr{
    
    NSString *_input_cp = input;
    NSUInteger _cusor = 0;
    NSUInteger _subStratIndex = 0;
    [_SearchTagresult removeAllObjects];
    _SearchTagresult = [NSMutableArray arrayWithObjects:@"#", nil];
    
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
            NSLog(@"tagstr %@",_tagstr);
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
            
            _dictionaryresultTag = [NSMutableArray arrayWithObjects:@"", nil];
            
            if (_hasbeenend) {
                /* 已結尾 */
                NSLog(@"indexofend:%d",_indexofend);
                NSLog(@"target:%@~",endchar);
                _tagstr = [_tagstr substringToIndex:_indexofend];
                [_SearchTagresult addObject:_tagstr];
                _subStratIndex = _indexofhash + _indexofend + 2;
            }
            else{
                /* 未結尾 */
                if(replacestr.length != 0)
                {
                   /*  有選擇Tag  */
                  NSRange replacerange = NSMakeRange(_cusor + _indexofhash+1,input.length - 1 - (_indexofhash + _cusor));
                   _replaced = [input stringByReplacingCharactersInRange:replacerange withString:replacestr];
                  //NSLog(@"replace %@",_replaced);
                }
                else{
                   /* 系統推薦Tag */
                [self searchTagDictionary:_tagstr];
                }
                return;
            }
        }
        else{
            NSLog(@"Not Found #");
            break;
        }
    }while(1);
    /* 將完成的（需要標明）的Tag傳過去 */
    [self callDelegate];
   }



-(void)callDelegate{
    /* 將完成的（需要標明）的Tag傳過去 */
    [_delegate hasfindHashTag:_SearchTagresult];
}



-(void)searchTagDictionary:(NSString*)input{
    _dictionaryresultTag = [NSMutableArray arrayWithObjects:@"", nil];
    /*     搜尋字典     */
    for(int i=0;i<_dictionaryTag.count;i+=1)
    {
        NSString *_comparetag = [_dictionaryTag objectAtIndex:i];
        /*    配對    */
        if([_comparetag hasPrefix:input])
        {
            [_dictionaryresultTag addObject:_comparetag];
        }
    }

    [self callDelegate];
}


-(NSArray*)getResult{
    return _dictionaryresultTag;
}



@end
